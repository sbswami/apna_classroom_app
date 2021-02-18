import 'package:apna_classroom_app/util/c.dart';
import 'package:get/get.dart';

/// Create a controller for 2 Object
/// 1. Exam Conducted
/// 2. Solved Exam Answer List
///
///

class RunningExamController extends GetxController {
  Map answers = {};
  Map solvedExam;

  static RunningExamController get to => Get.find<RunningExamController>();

  resetData(questions, _solvedExam) {
    answers = (_solvedExam[C.ANSWER] ?? [])
        .asMap()
        .map((index, value) => MapEntry(index, value));
    int processLength = answers.keys.length;
    questions = questions
        .where((question) => !answers.values.any((element) =>
            element[C.QUESTION][C.QUESTION][C.ID] ==
            question[C.QUESTION][C.ID]))
        .toList();

    print(questions.length);
    answers.addAll(questions.asMap().map((index, value) =>
        MapEntry(index + processLength, {C.QUESTION: value})));
    solvedExam = _solvedExam;
  }

  updateOneAnswer(int index, _answer) {
    answers[index] = _answer;
  }

  setSolvedExam(Map _solvedExam) {
    solvedExam = _solvedExam;
  }
}
