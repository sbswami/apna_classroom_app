import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/quiz/question/detailed_question.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final bool isSelected;
  final Function(bool selected) onChanged;
  final Function({BuildContext context}) onLongPress;
  final Function onRefresh;
  final bool isFromExam;
  final bool isEditable;

  const QuestionCard(
      {Key key,
      this.question,
      this.isSelected,
      this.onChanged,
      this.onLongPress,
      this.onRefresh,
      this.isFromExam,
      this.isEditable})
      : super(key: key);

  onTapQuestion() async {
    var result = await Get.to(DetailedQuestion(
      question: question,
      isEditable: isEditable,
      isFromExam: isFromExam,
    ));

    // Track screen back
    trackScreen(ScreenNames.QuestionsTab);

    if ((result ?? false) && onRefresh != null) onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (onLongPress != null) onLongPress(context: context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.symmetric(
            horizontal:
                BorderSide(width: 0.5, color: Theme.of(context).dividerColor),
          ),
        ),
        child: ExpansionTile(
          leading: isSelected != null
              ? Checkbox(
                  value: isSelected,
                  onChanged: onChanged,
                  checkColor: Theme.of(context).cardColor,
                )
              : null,
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (question[C.SOLVING_TIME] != null)
                Text(
                  getMinuteSt(question[C.SOLVING_TIME]),
                  style: Theme.of(context).textTheme.caption,
                ),
              if (question[C.SOLVING_TIME] != null) SizedBox(width: 30.0),
              if (question[C.MARKS] != null)
                Text(
                  '${S.MARKS.tr} ${question[C.MARKS]}',
                  style: Theme.of(context).textTheme.caption,
                ),
            ],
          ),
          title: GestureDetector(
            onTap: onTapQuestion,
            child: Text(
              question[C.TITLE],
              maxLines: 1,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          children: [
            GroupChips(
              list: question[C.EXAM].cast<String>().toList(),
            ),
            GroupChips(
              list: question[C.SUBJECT].cast<String>().toList(),
            ),
          ],
        ),
      ),
    );
  }
}
