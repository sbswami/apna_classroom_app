import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:flutter/material.dart';

class NotesCard extends StatelessWidget {
  final Map<String, dynamic> note;
  final Function onTap;
  const NotesCard({Key key, this.note, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                note[C.PRIVACY] == E.PUBLIC ? Icons.public : Icons.lock,
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
