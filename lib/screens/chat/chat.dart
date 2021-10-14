import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/message.dart';
import 'package:apna_classroom_app/api/storage/storage_api.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/chat/controllers/chat_messages_controller.dart';
import 'package:apna_classroom_app/screens/chat/widgets/message.dart';
import 'package:apna_classroom_app/screens/classroom/controllers/classroom_list_controller.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/screens/media/media_picker/media_picker.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chat extends StatefulWidget {
  final classroom;

  const Chat({Key key, @required this.classroom}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController messageInputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Variables
  bool isLoading = false;

  // Load message
  loadMessage() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    var messages = await listMessage({
      C.CLASSROOM: widget.classroom[C.ID],
      C.PRESENT: ChatMessagesController.to.messages.length.toString(),
      C.PER_PAGE: '10',
    });
    ChatMessagesController.to.addMessages(messages);
    setState(() {
      isLoading = false;
    });
  }

  // Send Message
  _send() async {
    if (messageInputController.text.trim().isEmpty) return;
    // Send Message
    // Create a temporary ID to check later and update the Message object
    String randomString = DateTime.now().millisecondsSinceEpoch.toString();

    // Message Object
    var messageObj = {
      C.TYPE: E.MESSAGE,
      C.MESSAGE: messageInputController.text.trim(),
      C.CLASSROOM: widget.classroom[C.ID],
      C.CREATED_BY: getUserId(),
    };

    // Insert new message
    ChatMessagesController.to.insertMessages([
      {...messageObj, C.ID: randomString}
    ]);

    // Clean text box
    messageInputController.clear();
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0.0,
          duration: Duration(seconds: 1), curve: Curves.ease);
    }

    var message = await createMessage(messageObj);

    // if message sent
    if (message != null) {
      ChatMessagesController.to.updateMessageObj(randomString, message);
      ClassroomListController.to.addMessage(widget.classroom[C.ID], message);
    }
    // message failed to sent
    else {
      // TODO: handle failed message
    }
  }

  // Media things
  _selectMedia() async {
    var result = await showApnaMediaPicker(false);
    if (result == null) return;
    await sendMediaToChat(result, widget.classroom[C.ID]);
  }

  @override
  void initState() {
    ChatMessagesController.to.newChat(widget.classroom[C.ID]);
    super.initState();
    // Set Current Screen
    trackScreen(ScreenNames.Chat);

    // track viewed screen event
    track(EventName.VIEWED_CHAT_SCREEN, {
      EventProp.PRIVACY: widget.classroom[C.PRIVACY],
      EventProp.WHO_CAN_JOIN: widget.classroom[C.WHO_CAN_JOIN],
      EventProp.IS_ADMIN: widget.classroom[C.IS_ADMIN],
      EventProp.ACCESSED_FROM: widget.classroom[C.CREATED_BY] == null
          ? ScreenNames.ClassroomTab
          : ScreenNames.ClassroomDetails,
    });

    loadMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classroom[C.TITLE]),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                var messages = ChatMessagesController.to.messages;
                int messagesLength = messages.length;

                if (messagesLength == 0 && isLoading) {
                  return DetailsSkeleton(
                    type: DetailsType.Chat,
                  );
                }

                if (messagesLength == 0) {
                  return EmptyList(
                    type: EmptyListType.Chat,
                  );
                }

                ClassroomListController.to.setUnseen(widget.classroom[C.ID]);
                return NotificationListener<ScrollNotification>(
                  key: Key('notification'),
                  onNotification: (ScrollNotification scrollInfo) {
                    if ((scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) &&
                        !isLoading) {
                      loadMessage();
                    }
                    return true;
                  },
                  child: ListView.custom(
                    key: Key('list'),
                    reverse: true,
                    padding: const EdgeInsets.all(8.0),
                    controller: _scrollController,
                    childrenDelegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final message = messages[index];

                        String creatorId = messageCreatedById(
                          message[C.CREATED_BY],
                        );

                        final bool isMe = isCreator(creatorId);

                        return Message(
                          key: ValueKey(message[C.ID]),
                          isMe: isMe,
                          message: message,
                          index: index,
                        );
                      },
                      childCount: messagesLength,
                      findChildIndexCallback: (Key key) {
                        final ValueKey valueKey = key;
                        final String id = valueKey.value;
                        int index = messages.indexWhere(
                          (element) => element[C.ID] == id,
                        );
                        return index;
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          if (canSendMessage(widget.classroom[C.WHO_CAN_SEND_MESSAGES],
              widget.classroom[C.IS_ADMIN]))
            Container(
              padding: const EdgeInsets.only(
                bottom: 16.0,
                left: 4.0,
                right: 4.0,
                // top: 8.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  )
                ],
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 180,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.file_copy_rounded),
                      onPressed: _selectMedia,
                      color: Theme.of(context).primaryColor,
                    ),
                    Expanded(
                      child: TextField(
                        controller: messageInputController,
                        decoration: InputDecoration(
                          hintText: S.TYPE_HERE.tr,
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _send,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

bool canSendMessage(String whoCanShare, bool _isAdmin) {
  switch (whoCanShare) {
    case E.ADMIN_ONLY:
      return _isAdmin;
      break;
    case E.ALL:
      return true;
      break;
  }
  return false;
}

sendMediaToChat(List mediaList, String classroomId) async {
  List messages = [];

  showProgress();

  await Future.wait(mediaList.map((media) async {
    String url;
    if (media[C.URL] != null) {
      url = media[C.URL];
    } else {
      switch (media[C.TYPE]) {
        case E.IMAGE:
          var storageResponse = await uploadToStorage(
              file: media[C.FILE],
              type: FileType.IMAGE,
              thumbnail: media[C.THUMBNAIL]);
          url = storageResponse[StorageConstant.PATH];
          break;

        case E.PDF:
          var storageResponse = await uploadToStorage(
              file: media[C.FILE],
              type: FileType.DOC,
              thumbnail: media[C.THUMBNAIL]);
          url = storageResponse[StorageConstant.PATH];
          break;

        case E.VIDEO:
          var storageResponse = await uploadToStorage(
              file: media[C.FILE],
              type: FileType.VIDEO,
              thumbnail: media[C.THUMBNAIL]);
          url = storageResponse[StorageConstant.PATH];
          break;
      }
    }

    // Send message
    // Create a temporary ID to check later and update the Message object
    String randomString = DateTime.now().millisecondsSinceEpoch.toString();

    // Message Object
    var messageObj = {
      C.TYPE: E.MEDIA,
      C.MEDIA: {
        C.ID: media[C.ID],
        C.TITLE: media[C.TITLE],
        C.TYPE: media[C.TYPE],
        C.URL: url,
        C.CREATED_AT: DateTime.now().toString(),
      },
      C.CLASSROOM: classroomId,
      C.CREATED_BY: getUserId(),
    };

    // Insert new message
    ChatMessagesController.to.insertMessages([
      {...messageObj, C.ID: randomString}
    ]);

    var message = await createMessage(messageObj);

    messages.add(message);

    // if message sent
    if (message != null) {
      ChatMessagesController.to.updateMessageObj(randomString, message);
      ClassroomListController.to.addMessage(classroomId, message);
    }
    // message failed to sent
    else {
      // TODO: handle failed message
    }
  }));
  Get.back();
  return messages.map((e) => e[C.MEDIA]).toList();
}
