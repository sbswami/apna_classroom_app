import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/running_exam/widgets/running_single_question.dart';
import 'package:apna_classroom_app/util/c.dart';
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
