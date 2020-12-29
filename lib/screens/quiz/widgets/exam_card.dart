import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/quiz/exam/detailed_exam.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamCard extends StatelessWidget {
  final Map<String, dynamic> exam;

  const ExamCard({Key key, this.exam}) : super(key: key);

  onTapExam() {
    Get.to(DetailedExam(
      exam: exam,
    ));
  }

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
              getMinuteSt(exam[C.SOLVING_TIME]),
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              '${S.MARKS.tr} ${exam[C.MARKS]}',
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              getDifficulty(exam[C.DIFFICULTY]).tr,
              style: Theme.of(context).textTheme.caption,
            ),
            Icon(
              getPrivacy(exam[C.PRIVACY]),
              size: 18,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
        title: GestureDetector(
          onTap: onTapExam,
          child: Text(
            exam[C.TITLE],
            maxLines: 1,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        children: [
          GroupChips(
            list: exam[C.EXAM].cast<String>().toList(),
          ),
          GroupChips(
            list: exam[C.SUBJECT].cast<String>().toList(),
          ),
        ],
      ),
    );
  }
}
