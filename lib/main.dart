import 'package:apna_classroom_app/app.dart';
import 'package:apna_classroom_app/internationalization/my_translation.dart';
import 'package:apna_classroom_app/util/local_storage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale locale = getLocal(await getLocale());
  bool _isDarkMode = await isDarkMode();
  runApp(ApnaApp(locale: locale, isDarkMode: _isDarkMode));
}
