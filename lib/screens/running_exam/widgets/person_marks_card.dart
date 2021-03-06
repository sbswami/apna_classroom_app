import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';

class PersonMarksCard extends StatelessWidget {
  final Function onTap;
  final person;

  const PersonMarksCard({Key key, this.onTap, this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var attender = person[C.ATTENDER][0];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.symmetric(
            horizontal:
                BorderSide(width: 0.5, color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attender[C.NAME],
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    attender[C.USERNAME],
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
            Text(
              '${person[C.MARKS]}',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
