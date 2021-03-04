import 'package:apna_classroom_app/screens/classroom/classroom.dart';
import 'package:apna_classroom_app/screens/notes/notes.dart';
import 'package:apna_classroom_app/screens/quiz/quiz.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Classroom(pageController: _pageController),
          Quiz(pageController: _pageController),
          Notes(pageController: _pageController),
        ],
      ),
    );
  }
}
