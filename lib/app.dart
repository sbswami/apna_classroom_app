import 'package:apna_classroom_app/internationalization/my_translation.dart';
import 'package:apna_classroom_app/screens/splash/initializer.dart';
import 'package:apna_classroom_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApnaApp extends StatelessWidget {
  final Locale locale;
  final bool isDarkMode;

  const ApnaApp({Key key, this.locale, this.isDarkMode}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Apna Classroom',
      translations: MyTranslation(),
      locale: locale ?? Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      theme: (isDarkMode ?? Get.isPlatformDarkMode)
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
      home: Initializer(),
    );
  }
}
