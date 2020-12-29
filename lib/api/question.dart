import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createQuestion(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: QUESTION_CREATE, payload: payload, isUser: true, isLoading: false);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.QUESTION];
  }
}

Future getQuestion(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: QUESTION_GET,
    isUser: true,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.QUESTION];
  }
}

Future listQuestion(Map<String, String> payload, List<String> subjects,
    List<String> exams) async {
  http.Response response = await apiGetCall(
      payload: payload,
      url: QUESTION_LIST,
      isUser: true,
      list: {C.SUBJECT: subjects, C.EXAM: exams});
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.LIST];
  }
}

Future getSubjectsQuestion() async {
  http.Response response =
      await apiGetCall(url: QUESTION_SUBJECTS, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.SUBJECT];
  }
}
