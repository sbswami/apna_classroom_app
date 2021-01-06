import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamConductedCard extends StatelessWidget {
  final Map examConducted;

  const ExamConductedCard({Key key, this.examConducted}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.symmetric(
          horizontal:
              BorderSide(width: 0.5, color: Theme.of(context).dividerColor),
        ),
      ),
      child: ExpansionTile(
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getMinuteSt(examConducted[C.EXAM][C.SOLVING_TIME]),
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              '${S.MARKS.tr} ${examConducted[C.EXAM][C.MARKS]}',
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              getDifficulty(examConducted[C.EXAM][C.DIFFICULTY]).tr,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
        title: Text(
          examConducted[C.EXAM][C.TITLE],
          maxLines: 1,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}
