import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createClassroom(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: CLASSROOM_CREATE, payload: payload, isUser: true, isLoading: false);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.CLASSROOM];
  }
}

Future getClassroom(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: CLASSROOM_GET,
    isUser: true,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.CLASSROOM];
  }
}

Future listClassroom(Map<String, String> payload, List<String> subjects,
    List<String> exams) async {
  http.Response response = await apiGetCall(
      payload: payload,
      url: CLASSROOM_LIST,
      isUser: true,
      list: {C.SUBJECT: subjects, C.CLASSROOM: exams});
  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
}

Future addMembers(Map<String, dynamic> payload) async {
  http.Response response =
      await apiCall(url: ADD_MEMBERS_CREATE, payload: payload, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.MESSAGE];
  }
}
