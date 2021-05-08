import 'package:apna_classroom_app/internationalization/my_translation.dart';
import 'package:apna_classroom_app/screens/splash/initializer.dart';
import 'package:apna_classroom_app/theme/app_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApnaApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  // --
  final Locale locale;
  final bool isDarkMode;

  const ApnaApp({Key key, this.locale, this.isDarkMode}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CQN - Classroom Quiz Notes',
      translations: MyTranslation(),
      locale: locale ?? Get.deviceLocale,
      // navigatorObservers: <NavigatorObserver>[observer],
      fallbackLocale: Locale('en', 'US'),
      theme: (isDarkMode ?? Get.isPlatformDarkMode)
          ? AppTheme.darkTheme
          : AppTheme.lightTheme,
      home: Initializer(),
    );
  }
}
