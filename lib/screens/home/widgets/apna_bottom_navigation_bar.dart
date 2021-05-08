import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/home/controllers/home_tab_controller.dart';
import 'package:apna_classroom_app/screens/home/widgets/bottom_nav_button.dart';
import 'package:apna_classroom_app/screens/quiz/quiz_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApnaBottomNavigationBar extends StatelessWidget {
  final PageController pageController;

  const ApnaBottomNavigationBar({Key key, this.pageController})
      : super(key: key);

  _onTabChange(int tab) {
    String screen;
    switch (tab) {
      case 0:
        screen = ScreenNames.ClassroomTab;
        break;

      case 1:
        if (QuizTabController.to.activeTab == 0) {
          screen = ScreenNames.ExamsTab;
        } else {
          screen = ScreenNames.QuestionsTab;
        }
        break;

      case 2:
        screen = ScreenNames.NotesTab;
        break;
    }

    // Track Screen
    trackScreen(screen);

    HomeTabController.to.changeTab(tab);
    pageController.jumpToPage(tab);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 20.0,
      shape: CircularNotchedRectangle(),
      child: Obx(() => Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BottomNavButton(
                iconData: Icons.group,
                text: S.CLASSROOM.tr,
                selected: HomeTabController.to.activeTab.value == 0,
                onTap: () => _onTabChange(0),
              ),
              BottomNavButton(
                iconData: Icons.receipt_rounded,
                text: S.QUIZ.tr,
                selected: HomeTabController.to.activeTab.value == 1,
                onTap: () => _onTabChange(1),
              ),
              BottomNavButton(
                iconData: Icons.local_library_rounded,
                text: S.NOTES.tr,
                selected: HomeTabController.to.activeTab.value == 2,
                onTap: () => _onTabChange(2),
              ),
              SizedBox(width: 30)
              // SizedBox(width: 64),
            ],
          )),
    );
  }
}
