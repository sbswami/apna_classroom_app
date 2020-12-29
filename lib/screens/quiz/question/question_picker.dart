import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/quiz/question/questions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionPicker extends StatefulWidget {
  final List<String> selectedQuestion;

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
      appBar: AppBar(
        title: TextFormField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: S.SEARCH.tr,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          cursorColor: Theme.of(context).cardColor,
          style: TextStyle(
            color: Theme.of(context).cardColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => onSearch(searchController.text),
          )
        ],
      ),
      body: Questions(
        onSelect: onSelect,
        selectedQuestion: widget.selectedQuestion,
        questionTitle: searchTitle,
      ),
    );
  }
}
