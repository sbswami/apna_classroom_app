import 'package:apna_classroom_app/internationalization/my_translation.dart';
import 'package:apna_classroom_app/screens/splash/initializer.dart';
import 'package:apna_classroom_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApnaApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Apna Classroom',
      translations: MyTranslation(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      theme: AppTheme.lightTheme,
      // theme: ThemeData(
      //     primaryColor: Color(0xFF3F6DF2),
      //     primarySwatch: Colors.blue,
      //     visualDensity: VisualDensity.adaptivePlatformDensity,
      //     textTheme: TextTheme(button: TextStyle(color: Colors.white))),
      home: Initializer(),
    );
  }
}
