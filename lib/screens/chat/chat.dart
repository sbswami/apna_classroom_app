import 'package:apna_classroom_app/api/message.dart';
import 'package:apna_classroom_app/api/storage.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/apna_file_picker.dart';
import 'package:apna_classroom_app/components/dialogs/upload_dialog.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/chat/controllers/chat_messages_controller.dart';
import 'package:apna_classroom_app/screens/chat/widgets/message.dart';
import 'package:apna_classroom_app/screens/classroom/controllers/classroom_list_controller.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
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

  // Fetch message on start
  // Add message here if receive message via FCM

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
    List mediaList = await showApnaFilePicker(true);
    if (mediaList == null) return;
    await _sendMedia(mediaList);
  }

  _sendMedia(List mediaList) async {
    UploadController.to.resetUpload(mediaList.length);
    showUploadDialog();

    await Future.wait(mediaList.map((media) async {
      String url;
      String thumbnailUrl;

      switch (media[C.TYPE]) {
        case E.IMAGE:
          url = await uploadImage(media[C.FILE]);
          thumbnailUrl = await uploadImageThumbnail(media[C.THUMBNAIL]);
          break;

        case E.PDF:
          url = await uploadPdf(media[C.FILE]);
          thumbnailUrl = await uploadPdfThumbnail(media[C.THUMBNAIL]);
          break;
      }
      UploadController.to.increaseUpload();

      // Send message
      // Create a temporary ID to check later and update the Message object
      String randomString = DateTime.now().millisecondsSinceEpoch.toString();

      // Message Object
      var messageObj = {
        C.TYPE: E.MEDIA,
        C.MEDIA: {
          C.TITLE: media[C.TITLE],
          C.TYPE: media[C.TYPE],
          C.URL: url,
          C.THUMBNAIL_URL: thumbnailUrl,
          C.CREATED_AT: DateTime.now().toString(),
        },
        C.CLASSROOM: widget.classroom[C.ID],
        C.CREATED_BY: getUserId(),
      };

      // Insert new message
      ChatMessagesController.to.insertMessages([
        {...messageObj, C.ID: randomString}
      ]);

      // Clean text box
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
    }));
    Get.back();
  }

  @override
  void initState() {
    ChatMessagesController.to.newChat(widget.classroom[C.ID]);
    super.initState();
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
                  onNotification: (ScrollNotification scrollInfo) {
                    if ((scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) &&
                        !isLoading) {
                      loadMessage();
                    }
                    return true;
                  },
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messagesLength,
                    padding: const EdgeInsets.all(8.0),
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      final message = messages[index];
                      final bool isMe = isCreator(message[C.CREATED_BY]);
                      return Message(
                          key: Key(message[C.ID]),
                          isMe: isMe,
                          message: message);
                    },
                  ),
                );
              },
            ),
          ),
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
