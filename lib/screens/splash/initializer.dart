import 'package:apna_classroom_app/auth/auth.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/screens/home/home.dart';
import 'package:apna_classroom_app/screens/login/login.dart';
import 'package:apna_classroom_app/screens/profile/profile.dart';
import 'package:apna_classroom_app/screens/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Initializer extends StatefulWidget {
  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  int userLevel = 0;
  bool loading = true;

  @override
  void initState() {
    Get.put(UserController());
    Get.put(RecentlyUsedController());
    super.initState();
    _checkUser();
  }

  _checkUser() async {
    int _useLevel = await checkUser();
    setState(() {
      userLevel = _useLevel;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Splash();
    return getScreenForUser(userLevel);
  }
}

Widget getScreenForUser(int key) {
  switch (key) {
    case 0:
      return Login();
    case 1:
      return ProfileScreen();
    case 2:
      return Home();
    default:
      return Login();
  }
}
