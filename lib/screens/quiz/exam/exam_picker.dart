import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:apna_classroom_app/screens/quiz/exam/exams.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamPicker extends StatefulWidget {
  @override
  _ExamPickerState createState() => _ExamPickerState();
}

class _ExamPickerState extends State<ExamPicker> {
  onSelect(Map exam) {
    Get.back(result: exam);
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
      body: Exams(
        onSelect: onSelect,
        examTitle: searchTitle,
      ),
    );
  }
}
