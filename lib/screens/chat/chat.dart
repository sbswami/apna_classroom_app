import 'package:apna_classroom_app/api/message.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/chat/controllers/chat_messages_controller.dart';
import 'package:apna_classroom_app/screens/chat/widgets/message.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chat extends StatefulWidget {
  final classroom;

  const Chat({Key key, this.classroom}) : super(key: key);

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
      C.MESSAGE: messageInputController.text,
      C.CLASSROOM: widget.classroom[C.ID],
      C.CREATED_BY: UserController.to.currentUser[C.ID],
    };

    // Insert new message
    ChatMessagesController.to.insertMessages([
      {...messageObj, C.ID: randomString}
    ]);

    // Clean text box
    messageInputController.text = '';
    _scrollController.animateTo(0.0,
        duration: Duration(seconds: 1), curve: Curves.ease);

    var message = await createMessage(messageObj);

    // if message sent
    if (message != null) {
      ChatMessagesController.to.updateMessageObj(randomString, message);
    }
    // message failed to sent
    else {
      // TODO: handle failed message
    }
  }

  _selectMedia() {}

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
                      final bool isMe = message[C.CREATED_BY] ==
                          UserController.to.currentUser[C.ID];
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
              top: 8.0,
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
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.file_copy_rounded),
                  onPressed: () {},
                  color: Theme.of(context).primaryColor,
                ),
                Expanded(
                  child: TextField(
                    controller: messageInputController,
                    decoration: InputDecoration(
                      hintText: S.TYPE_HERE.tr,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _send,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
