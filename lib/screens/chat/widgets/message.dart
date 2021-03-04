import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/exam_conducted_card.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/exam_conducted_list.dart';
import 'package:apna_classroom_app/screens/media/media_helper.dart';
import 'package:apna_classroom_app/screens/notes/widgets/notes_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/date_time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Message extends StatelessWidget {
  final message;
  final bool isMe;

  const Message({Key key, this.message, this.isMe}) : super(key: key);

  _onTap() {
    switch (message[C.TYPE]) {
      case E.MEDIA:
        showMedia(message[C.MEDIA]);
        break;
      case E.EXAM_CONDUCTED:
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width * 0.8;
    Alignment _alignment = Alignment.topLeft;
    Color _cardColor = Theme.of(context).cardColor;
    EdgeInsetsGeometry _padding;
    if (isMe) {
      _cardColor = Theme.of(context).primaryColor;
      _alignment = Alignment.topRight;
    }
    if (message[C.TYPE] == E.MESSAGE) {
      _padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
    }
    return GestureDetector(
      onTap: _onTap,
      child: Column(
        children: [
          Container(
            alignment: _alignment,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              padding: _padding,
              margin: const EdgeInsets.only(bottom: 6.0, top: 16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 0,
                    blurRadius: 15,
                  )
                ],
              ),
              child: getMessageContent(),
            ),
          ),
          Container(
            alignment: _alignment,
            child: Text(
              getFormattedDateTime(dateString: message[C.CREATED_AT]),
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );
  }

  Widget getMessageContent() {
    switch (message[C.TYPE]) {
      case E.MESSAGE:
        if (message[C.MESSAGE] == null) return getDeletedNote();
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
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: ExamConductedCard(
            buttons:
                getExamConductedButtons(RUNNING, message[C.EXAM_CONDUCTED]),
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
    }
    return SizedBox.shrink();
  }

  Widget getDeletedNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        S.MESSAGED_DELETED.tr,
        style: TextStyle(
            color: isMe
                ? Theme.of(Get.context).cardColor.withOpacity(0.7)
                : Theme.of(Get.context).textTheme.caption.color),
      ),
    );
  }
}
