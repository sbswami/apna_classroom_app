import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createExam(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: EXAM_CREATE, payload: payload, isUser: true, isLoading: false);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.EXAM];
  }
}

Future getExam(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: EXAM_GET,
    isUser: true,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.EXAM];
  }
}

Future listExam(Map<String, String> payload, List<String> subjects,
    List<String> exams) async {
  http.Response response = await apiGetCall(
      payload: payload,
      url: EXAM_LIST,
      isUser: true,
      list: {C.SUBJECT: subjects, C.EXAM: exams});
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.LIST];
  }
}

Future getSubjectsExam() async {
  http.Response response = await apiGetCall(url: EXAM_SUBJECTS, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.SUBJECT];
  }
}
