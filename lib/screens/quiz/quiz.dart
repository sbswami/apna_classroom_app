import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:apna_classroom_app/screens/quiz/exam/exams.dart';
import 'package:apna_classroom_app/screens/quiz/question/questions.dart';
import 'package:apna_classroom_app/screens/quiz/quiz_tab_controller.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/quiz_tab_bar.dart';
import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> with SingleTickerProviderStateMixin {
  TabController _tabController;
  String examSearchTitle;
  String questionSearchTitle;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      QuizTabController.to.changeTab(_tabController.index);
      if (_tabController.index == 0) {
        searchController.text = examSearchTitle ?? '';
      } else {
        searchController.text = questionSearchTitle ?? '';
      }
    });
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  onSearch(String value) {
    setState(() {
      if (QuizTabController.to.activeTab == 0)
        examSearchTitle = value;
      else
        questionSearchTitle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          HomeAppBar(onSearch: onSearch, searchController: searchController),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBarQuiz(
            tabController: _tabController,
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Exams(
                examTitle: examSearchTitle,
              ),
              Questions(
                questionTitle: questionSearchTitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
