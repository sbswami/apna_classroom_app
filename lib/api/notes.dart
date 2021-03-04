import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createNote(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: NOTE_CREATE, payload: payload, isUser: true, isLoading: false);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.NOTE];
  }
}

Future getNote(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: NOTE_GET,
    isUser: true,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.NOTE];
  }
}

Future listNote(Map<String, String> payload, List<String> subjects) async {
  http.Response response = await apiGetCall(
      payload: payload,
      url: NOTE_LIST,
      isUser: true,
      list: {C.SUBJECT: subjects});
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.LIST];
  }
}

Future<bool> deleteNote(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: NOTE_DELETE, payload: payload, isUser: true, isLoading: true);

  return response.statusCode == 200;
}
