import 'package:apna_classroom_app/auth/auth.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Classroom extends StatefulWidget {
  @override
  _ClassroomState createState() => _ClassroomState();
}

class _ClassroomState extends State<Classroom> {
  bool searchActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Column(
        children: [
          Container(
            child: Text(S.CLASSROOM.tr),
          ),
          RaisedButton(
            onPressed: () {
              signOut();
            },
            child: Text('LOG OUT'),
          ),
        ],
      ),
    );
  }
}
