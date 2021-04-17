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
        headline5: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(brightness: Brightness.dark));

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColorDark,
    accentColor: accentColorDark,
    cardColor: cardColorDark,
    // cardColor: cardColorDark,
    textTheme: TextTheme(
      button: buttonTextStyleDark,
      headline5: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      color: ThemeData.dark().primaryColor,
      actionsIconTheme: IconThemeData(color: primaryColorDark),
      iconTheme: IconThemeData(color: primaryColorDark),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: primaryColorDark,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
