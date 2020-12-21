import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:get/get.dart';

String validateUsername(String value) {
  if (!GetUtils.isUsername(value)) return S.USERNAME_INVALID.tr;
  return null;
}
