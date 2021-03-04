import 'package:apna_classroom_app/theme/styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    accentColor: accentColor,
    // scaffoldBackgroundColor: Color(0xFFEEEEEE),
    textTheme: TextTheme(
      button: buttonTextStyle,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // primaryColor: primaryColorDark,
    accentColor: accentColorDark,
    // cardColor: cardColorDark,
    textTheme: TextTheme(
      button: buttonTextStyleDark,
    ),
  );
}
