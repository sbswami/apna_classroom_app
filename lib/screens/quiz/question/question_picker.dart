import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:apna_classroom_app/screens/quiz/question/questions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionPicker extends StatefulWidget {
  final List selectedQuestion;

  const QuestionPicker({Key key, this.selectedQuestion}) : super(key: key);
  @override
  _QuestionPickerState createState() => _QuestionPickerState();
}

class _QuestionPickerState extends State<QuestionPicker> {
  onSelect(List list) {
    Get.back(result: list);
  }

  // Search
  String searchTitle;
  TextEditingController searchController = TextEditingController();
  onSearch(String value) {
    setState(() {
      searchTitle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(onSearch: onSearch, searchActive: true),
      body: Questions(
        onSelect: onSelect,
        selectedQuestion: widget.selectedQuestion,
        questionTitle: searchTitle,
      ),
    );
  }
}
