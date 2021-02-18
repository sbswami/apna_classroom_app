import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createSolvedExam(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: SOLVED_EXAM_CREATE, payload: payload, isUser: true, isLoading: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.SOLVED_EXAM];
  }
}

Future getSolvedExam(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: SOLVED_EXAM_GET,
    isUser: true,
    isLoading: false,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.SOLVED_EXAM];
  }
}

Future addAnswerSolvedExam(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: SOLVED_EXAM_ADD_ANSWER,
      payload: payload,
      isUser: true,
      isLoading: false);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.MESSAGE];
  }
}

Future getResultOneSolvedExam(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: SOLVED_EXAM_RESULT_ONE,
    isUser: true,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.SOLVED_EXAM];
  }
}

Future getResultAllSolvedExam(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: SOLVED_EXAM_RESULT_ALL,
    isUser: true,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.RESULT];
  }
}

Future deleteSolvedExam(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: SOLVED_EXAM_DELETE, payload: payload, isUser: true, isLoading: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.MESSAGE];
  }
}
