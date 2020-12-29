import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/notes/detailed_note.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotesCard extends StatelessWidget {
  final Map<String, dynamic> note;
  const NotesCard({Key key, this.note}) : super(key: key);

  onTapNote() {
    Get.to(DetailedNote(
      note: note,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapNote,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.symmetric(
            horizontal:
                BorderSide(width: 0.5, color: Theme.of(context).dividerColor),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note[C.TITLE],
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  GroupChips(
                    list: note[C.SUBJECT].cast<String>().toList(),
                  ),
                ],
              ),
              Icon(
                getPrivacy(note[C.PRIVACY]),
                color: Theme.of(context).primaryColor,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
