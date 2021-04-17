import 'package:apna_classroom_app/internationalization/lang/en_IN.dart';
import 'package:apna_classroom_app/internationalization/lang/en_US.dart';
import 'package:apna_classroom_app/internationalization/lang/hi_IN.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {'en_US': EN_US, 'en_IN': EN_IN, 'hi_IN': HI_IN};
}

const String en_US = 'en_US';
const String en_IN = 'en_IN';
const String hi_IN = 'hi_IN';

getLocal(String value) {
  if (value == null) return;
  List data = value?.split('_');

  return Locale(data[0], data[1]);
}

getLocalToString({Locale locale}) {
  if (locale == null) locale = Get.locale;
  return '${locale.languageCode}_${locale.countryCode}';
}
