import 'package:apna_classroom_app/auth/auth.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Classroom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
