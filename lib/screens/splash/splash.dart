import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Image.asset(A.APP_ICON),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor
        ),
      ),
    );
  }
}
