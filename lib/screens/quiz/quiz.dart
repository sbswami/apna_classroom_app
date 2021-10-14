import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/screens/home/widgets/apna_bottom_navigation_bar.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_drawer.dart';
import 'package:apna_classroom_app/screens/quiz/exam/add_exam.dart';
import 'package:apna_classroom_app/screens/quiz/exam/exams.dart';
import 'package:apna_classroom_app/screens/quiz/question/add_question.dart';
import 'package:apna_classroom_app/screens/quiz/question/questions.dart';
import 'package:apna_classroom_app/screens/quiz/quiz_provider.dart';
import 'package:apna_classroom_app/screens/quiz/quiz_tab_controller.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/quiz_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Quiz extends StatefulWidget {
  final PageController pageController;

  const Quiz({Key key, this.pageController}) : super(key: key);
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
      String screen;
      QuizTabController.to.changeTab(_tabController.index);
      if (_tabController.index == 0) {
        searchController.text = examSearchTitle ?? '';
        screen = ScreenNames.ExamsTab;
      } else {
        searchController.text = questionSearchTitle ?? '';
        screen = ScreenNames.QuestionsTab;
      }

      // Track Screen
      trackScreen(screen);
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

  // Add
  _add() async {
    final update = Provider.of<QuizProvider>(context, listen: false);
    switch (QuizTabController.to.activeTab) {
      case 0:
        var result = await Get.to(AddExam(
          accessedFrom: ScreenNames.ExamsTab,
        ));

        // Track screen back
        trackScreen(ScreenNames.ExamsTab);

        update.updateExam = (result != null);

        break;
      case 1:
        var result = await Get.to(AddQuestion());

        // Track screen back
        trackScreen(ScreenNames.QuestionsTab);

        update.updateQuestion = (result != null);
        break;
    }
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
                // updateExam: _updateExam,
                // setUpdateExam: _setUpdateExam,
              ),
              Questions(
                questionTitle: questionSearchTitle,
                // updateQuestion: _updateQuestion,
                // setUpdateQuestion: _setUpdateQuestion,
              ),
            ],
          ),
        ),
      ),
      drawer: HomeDrawer(),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: _add,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: ApnaBottomNavigationBar(
        pageController: widget.pageController,
      ),
    );
  }
}
