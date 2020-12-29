import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom/classroom.dart';
import 'package:apna_classroom_app/screens/home/widgets/bottom_nav_button.dart';
import 'package:apna_classroom_app/screens/notes/add_notes.dart';
import 'package:apna_classroom_app/screens/notes/notes.dart';
import 'package:apna_classroom_app/screens/quiz/exam/add_exam.dart';
import 'package:apna_classroom_app/screens/quiz/question/add_question.dart';
import 'package:apna_classroom_app/screens/quiz/quiz.dart';
import 'package:apna_classroom_app/screens/quiz/quiz_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController(initialPage: 0);
  int _activeTab = 0;

  _changeTab(int tab) {
    _pageController.jumpToPage(tab);
    setState(() {
      _activeTab = tab;
    });
  }

  _add() async {
    switch (_activeTab) {
      case 0:
        break;
      case 1:
        switch (QuizTabController.to.activeTab) {
          case 0:
            await Get.to(AddExam());
            break;
          case 1:
            await Get.to(AddQuestion());
            break;
        }
        break;
      case 2:
        await Get.to(AddNotes());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Classroom(),
          Quiz(),
          Notes(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 20.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BottomNavButton(
              iconData: Icons.group,
              text: S.CLASSROOM.tr,
              selected: _activeTab == 0,
              onTap: () => _changeTab(0),
            ),
            BottomNavButton(
              iconData: Icons.receipt,
              text: S.QUIZ.tr,
              selected: _activeTab == 1,
              onTap: () => _changeTab(1),
            ),
            BottomNavButton(
              iconData: Icons.local_library,
              text: S.NOTES.tr,
              selected: _activeTab == 2,
              onTap: () => _changeTab(2),
            ),
            SizedBox(width: 30)
            // SizedBox(width: 64),
          ],
        ),
      ),
    );
  }
}
