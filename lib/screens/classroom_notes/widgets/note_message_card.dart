import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/message_sender_name.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/message_sent_time.dart';
import 'package:apna_classroom_app/screens/notes/widgets/notes_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteMessageCard extends StatelessWidget {
  final message;

  const NoteMessageCard({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: MessageSenderName(
            creator: message[C.CREATED_BY],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 4,
          child: MessageSentTime(
            createdAt: message[C.CREATED_AT],
          ),
        ),
        Column(
          children: [
            SizedBox(height: 42),
            if (message[C.NOTE] == null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                child: Text(S.NOTES_ARE_DELETED_BY_CREATOR.tr,
                    style: Theme.of(context).textTheme.caption),
              )
            else
              NotesCard(note: message[C.NOTE], fromClassroom: true),
            SizedBox(height: 24),
          ],
        ),
      ],
    );
  }
}
