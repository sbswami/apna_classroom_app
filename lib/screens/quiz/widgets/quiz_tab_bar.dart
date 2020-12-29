import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarQuiz extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const TabBarQuiz({Key key, this.tabController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: Theme.of(context).textTheme.bodyText2.color,
      tabs: <Widget>[
        Tab(text: S.EXAM.tr),
        Tab(text: S.QUESTION.tr),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(35);
}
