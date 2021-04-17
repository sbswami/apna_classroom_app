import 'package:apna_classroom_app/api/message.dart';
import 'package:apna_classroom_app/api/report.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/single_input_dialog.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/components/menu/apna_menu.dart';
import 'package:apna_classroom_app/components/menu/menu_item.dart';
import 'package:apna_classroom_app/components/share/apna_share.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/chat/controllers/chat_messages_controller.dart';
import 'package:apna_classroom_app/screens/chat/widgets/classroom_message_card.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/exam_conducted_card.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/exam_conducted_list.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/message_sender_name.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/message_sent_time.dart';
import 'package:apna_classroom_app/screens/media/media_helper.dart';
import 'package:apna_classroom_app/screens/notes/widgets/notes_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Message extends StatelessWidget {
  final message;
  final bool isMe;

  const Message({Key key, this.message, this.isMe}) : super(key: key);

  _onTap() {
    switch (message[C.TYPE]) {
      case E.MEDIA:
        showMedia(message[C.MEDIA]);
        break;
    }
  }

  _shareMessage() {
    Get.back();
    internalShare(SharingContentType.Message, message);
  }

  _copyMessage() {
    Clipboard.setData(ClipboardData(text: message[C.MESSAGE]));
    ScaffoldMessenger.of(Get.context).showSnackBar(
      SnackBar(
        content: Text(S.MESSAGE_COPIED.tr),
        duration: Duration(seconds: 1),
      ),
    );
    Get.back();
  }

  _reportMessage() async {
    Get.back();
    var text = await showSingleInputDialog(
      maxChar: 1000,
      title: S.REPORT.tr,
      labelText: S.ENTER_YOUR_COMPLAIN.tr,
    );

    if (text == null) return;

    var report = await createReport({
      C.TEXT: text,
      C.TYPE: E.MESSAGE,
      C.MESSAGE: message[C.ID],
      C.CLASSROOM: message[C.CLASSROOM],
    });

    if (report != null) {
      return ok(
        title: S.REPORT.tr,
        msg: S.REPORT_SUBMITTED_MESSAGE.tr,
      );
    }
  }

  _deleteMessage() async {
    Get.back();
    var isDeleted = await deleteMessage({C.ID: message[C.ID]});
    if (!isDeleted)
      return ok(
        title: S.SOMETHING_WENT_WRONG.tr,
        msg: S.CAN_NOT_DELETE_NOW.tr,
      );
    ChatMessagesController.to.updateMessageObj(message[C.ID], {
      C.TYPE: message[C.TYPE],
      C.CREATED_BY: message[C.CREATED_BY],
      C.CLASSROOM: message[C.CLASSROOM],
      C.CREATED_AT: message[C.CREATED_AT],
      C.DELETED: true,
    });
  }

  _onLongPress(BuildContext context) async {
    if (message[C.DELETED] ?? false) return;
    List<MenuItem> list = [];
    if (message[C.TYPE] != E.EXAM_CONDUCTED) {
      list.add(MenuItem(
        iconData: Icons.share_rounded,
        text: S.SHARE.tr,
        onTap: _shareMessage,
      ));
      if (isMe) {
        list.add(MenuItem(
          iconData: Icons.delete_rounded,
          text: S.DELETE.tr,
          onTap: _deleteMessage,
        ));
      }
    }

    if (message[C.TYPE] == E.MESSAGE) {
      list.add(MenuItem(
        iconData: Icons.copy_rounded,
        text: S.COPY.tr,
        onTap: _copyMessage,
      ));
    }

    if (!isMe) {
      list.add(MenuItem(
        iconData: Icons.report,
        text: S.REPORT.tr,
        onTap: _reportMessage,
      ));
    }
    if (list.isEmpty) return;
    showApnaMenu(context, list, type: MenuType.BottomSheet);
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.8;
    Alignment _alignment = Alignment.topLeft;
    Color _cardColor = Theme.of(context).cardColor;
    EdgeInsetsGeometry _padding;
    if (isMe) _alignment = Alignment.topRight;

    if (message[C.TYPE] == E.MESSAGE) {
      if (isMe) _cardColor = Theme.of(context).primaryColor;
      _padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
    }

    return Stack(
      children: [
        if (!isMe && (message[C.SAME_USER] ?? true))
          MessageSenderName(
            creator: message[C.CREATED_BY],
          ),
        Positioned(
          bottom: 0,
          right: isMe ? 0 : null,
          child: MessageSentTime(
            alignmentGeometry: _alignment,
            createdAt: message[C.CREATED_AT],
          ),
        ),
        GestureDetector(
          onTap: _onTap,
          onLongPress: () => _onLongPress(context),
          child: Column(
            children: [
              SizedBox(height: isMe ? 16 : 42),
              Container(
                alignment: _alignment,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                  ),
                  padding: _padding,
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: getMessageContent(),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  Widget getMessageContent() {
    switch (message[C.TYPE]) {
      case E.MESSAGE:
        if (message[C.MESSAGE] == null)
          return Text(
            S.MESSAGED_DELETED.tr,
            style: TextStyle(
                color: isMe
                    ? Theme.of(Get.context).cardColor.withOpacity(0.7)
                    : Theme.of(Get.context).textTheme.caption.color),
          );
        return Linkify(
          text: message[C.MESSAGE],
          onOpen: _onOpen,
          style:
              TextStyle(color: isMe ? Theme.of(Get.context).cardColor : null),
          linkStyle: TextStyle(
              color: isMe ? Theme.of(Get.context).cardColor : null,
              fontWeight: FontWeight.w500),
        );
        return Text(
          message[C.MESSAGE],
          style:
              TextStyle(color: isMe ? Theme.of(Get.context).cardColor : null),
        );
      case E.MEDIA:
        if (message[C.MEDIA] == null) return getDeletedNote();
        return UrlImage(url: message[C.MEDIA][C.THUMBNAIL_URL]);
      case E.EXAM_CONDUCTED:
        if (message[C.EXAM_CONDUCTED] == null) return getDeletedNote();
        bool upcomingExam =
            isFutureDate(dateSt: message[C.EXAM_CONDUCTED][C.START_TIME]);
        bool completedExam = false;
        if (message[C.EXAM_CONDUCTED][C.EXPIRE_TIME] != null) {
          completedExam =
              !isFutureDate(dateSt: message[C.EXAM_CONDUCTED][C.EXPIRE_TIME]);
        }

        ExamConductedState type = ExamConductedState.RUNNING;
        if (upcomingExam) {
          type = ExamConductedState.UPCOMING;
        } else if (completedExam) {
          type = ExamConductedState.COMPLETED;
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: ExamConductedCard(
            buttons: getExamConductedButtons(type, message[C.EXAM_CONDUCTED]),
            examConducted: message[C.EXAM_CONDUCTED],
          ),
        );
      case E.NOTE:
        if (message[C.NOTE] == null) return getDeletedNote();
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: NotesCard(
              note: message[C.NOTE],
              fromClassroom: true,
              maxWidth: MediaQuery.of(Get.context).size.width * 0.8),
        );
      case E.CLASSROOM:
        if (message[C.CLASSROOM_ID] == null) return getDeletedNote();
        return ClassroomMessageCard(classroomMessage: message[C.CLASSROOM_ID]);
    }
    return SizedBox.shrink();
  }

  Widget getDeletedNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        S.MESSAGED_DELETED.tr,
        style: TextStyle(color: Theme.of(Get.context).textTheme.caption.color),
      ),
    );
  }
}
