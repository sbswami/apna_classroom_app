import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/notes/widgets/notes_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/date_time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteMessageCard extends StatelessWidget {
  final message;

  const NoteMessageCard({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 16.0),
          child: Text(
            getFormattedDateTime(dateString: message[C.CREATED_AT]),
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }
}
