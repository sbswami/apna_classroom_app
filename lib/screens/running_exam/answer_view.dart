import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/running_exam/widgets/running_single_question.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnswerView extends StatefulWidget {
  final solvedExam;

  const AnswerView({Key key, this.solvedExam}) : super(key: key);

  @override
  _AnswerViewState createState() => _AnswerViewState();
}

class _AnswerViewState extends State<AnswerView> {
  final PageController pageController = PageController();
  int questionsLength = 0;

  @override
  void initState() {
    questionsLength = widget.solvedExam[C.ANSWER]?.length;
    super.initState();

    // Track screen
    trackScreen(ScreenNames.AnswerView);

    // Track event
    track(EventName.SHOW_ANSWER, {
      EventProp.SELF: widget.solvedExam[C.ATTENDER][C.ID] == getUserId(),
      EventProp.PERCENTAGE: getPercentage(widget.solvedExam[C.MARKS],
          widget.solvedExam[C.EXAM_CONDUCTED][C.EXAM][C.MARKS]),
      EventProp.EXAMS: widget.solvedExam[C.EXAM_CONDUCTED][C.EXAM][C.EXAM],
      EventProp.SUBJECTS: widget.solvedExam[C.EXAM_CONDUCTED][C.EXAM]
          [C.SUBJECT],
    });
  }

  onNext(int index) {
    pageController.jumpToPage(index + 1);
  }

  onPrev(int index) {
    pageController.jumpToPage(index - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.ANSWER.tr)),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: widget.solvedExam[C.ANSWER]
            .asMap()
            .map(
              (index, value) => MapEntry(
                index,
                RunningSingleQuestion(
                  questionsLength: questionsLength,
                  answerObj: value,
                  index: index,
                  onNext: () => onNext(index),
                  onPrev: () => onPrev(index),
                  showOnly: true,
                  showSolutionAndAnswer: widget.solvedExam[C.EXAM_CONDUCTED]
                      [C.SHOW_SOLUTION_AND_ANSWER],
                ),
              ),
            )
            .values
            .toList()
            .cast<Widget>(),
      ),
    );
  }
}
