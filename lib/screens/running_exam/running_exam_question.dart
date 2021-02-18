import 'package:apna_classroom_app/api/solved_exam.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/date_time/count_down.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/running_exam/controller/running_exam_controller.dart';
import 'package:apna_classroom_app/screens/running_exam/single_result.dart';
import 'package:apna_classroom_app/screens/running_exam/widgets/running_single_question.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RunningExamQuestion extends StatefulWidget {
  final examConducted;
  final remainingSolvingTime;

  const RunningExamQuestion(
      {Key key, this.examConducted, this.remainingSolvingTime})
      : super(key: key);
  @override
  _RunningExamQuestionState createState() => _RunningExamQuestionState();
}

class _RunningExamQuestionState extends State<RunningExamQuestion> {
  final PageController pageController = PageController();
  int _questionsLength = 0;

  onNext(int index) {
    pageController.jumpToPage(index + 1);
  }

  onPrev(int index) {
    pageController.jumpToPage(index - 1);
  }

  submitExam() async {
    var _solvedExam = await createSolvedExam({
      C.ID: RunningExamController.to.solvedExam[C.ID],
      C.FINISHED: true,
      C.FINISHED_TIME: DateTime.now().toString(),
    });
    _solvedExam[C.ATTENDER] = UserController.to.currentUser;

    Get.off(SingleResult(solvedExam: _solvedExam));
  }

  @override
  void initState() {
    _questionsLength = RunningExamController.to.answers.length;
    super.initState();
  }

  _onCountDownEnd() async {
    if (widget.examConducted[C.MUST_FINISH_WITHIN_TIME]) {
      ok(
          title: S.EXAM_ENDED.tr,
          msg: S.OUT_OF_TIME_EXAM_WLL_BE_SAVED.tr,
          buttonName: S.VIEW_RESULT.tr,
          ok: () async {
            await submitExam();
          },
          isDismissible: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CountDown(
          seconds: widget.remainingSolvingTime,
          onCountDownEnd: _onCountDownEnd,
        ),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: submitExam)],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: RunningExamController.to.answers
            .map(
              (index, value) => MapEntry(
                index,
                RunningSingleQuestion(
                  questionsLength: _questionsLength,
                  answerObj: value,
                  index: index,
                  onNext: () => onNext(index),
                  onPrev: () => onPrev(index),
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}
