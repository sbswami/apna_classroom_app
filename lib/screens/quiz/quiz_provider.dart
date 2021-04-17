import 'package:flutter/material.dart';

class QuizProvider with ChangeNotifier {
  bool _updateExam = false;
  bool _updateQuestion = false;

  bool get updateExam => _updateExam;
  bool get updateQuestion => _updateQuestion;

  set updateExam(bool newValue) {
    _updateExam = newValue;
    notifyListeners();
  }

  set updateQuestion(bool newValue) {
    _updateQuestion = newValue;
    notifyListeners();
  }
}
