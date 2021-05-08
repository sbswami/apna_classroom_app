import 'package:apna_classroom_app/util/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Image.asset(
          A.LOADING,
          width: MediaQuery.of(context).size.width * 0.90,
        ),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
