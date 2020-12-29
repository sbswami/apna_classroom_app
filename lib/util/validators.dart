import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:get/get.dart';

const int MAX_NOTE_TITLE_LENGTH = 20;

String phoneValidate(String value) {
  if (!GetUtils.isPhoneNumber(value)) {
    return S.PLEASE_ENTER_VALID_PHONE_NUMBER.tr;
  }
  return null;
}

String validName(String value) {
  if (!RegExp(r'^[A-Za-z]+([\ A-Za-z]+)*').hasMatch(value) ||
      value.isEmpty ||
      value.length > 20) {
    return S.NAME_INVALID.tr;
  }
  return null;
}

String validTitle(String value) {
  if (!RegExp(r'^[A-Za-z0-9]+([\ A-Za-z0-9]+)*').hasMatch(value) ||
      value.isEmpty ||
      value.length > 100) {
    return S.NOT_A_VALID_TITLE.tr;
  }
  return null;
}

String validQuestion(String value) {
  if (value.isEmpty || value.length > 500) {
    return S.NOT_A_VALID_QUESTION.tr;
  }
  return null;
}

String validAnswer(String value) {
  if (value.isEmpty || value.length > 500) {
    return S.NOT_A_VALID_ANSWER.tr;
  }
  return null;
}

String validRequired(String value) {
  if (value.isEmpty) {
    return S.THIS_FIELD_IS_REQUIRED.tr;
  }
  return null;
}
