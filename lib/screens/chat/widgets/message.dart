import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/date_time.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final message;
  final bool isMe;

  const Message({Key key, this.message, this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Alignment _alignment = isMe ? Alignment.topRight : Alignment.topLeft;

    return Column(
      children: [
        Container(
          alignment: _alignment,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            margin: const EdgeInsets.only(bottom: 6.0, top: 16),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
            ),
            child: Column(
              children: [
                getMessageContent(),
              ],
            ),
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
    );
  }

  Widget getMessageContent() {
    switch (message[C.TYPE]) {
      case E.MESSAGE:
        return Text(
          message[C.MESSAGE],
          style: TextStyle(color: isMe ? Colors.white : null),
        );
    }
    return SizedBox.shrink();
  }
}
