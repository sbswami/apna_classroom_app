import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createMessage(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: MESSAGE_CREATE, payload: payload, isUser: true, isLoading: false);
  if (response?.statusCode == 200) {
    return json.decode(response.body)[C.MESSAGE];
  }
}

Future getMessage(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: MESSAGE_GET,
    isUser: true,
    isLoading: true,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.MESSAGE];
  }
}

Future listMessage(Map<String, String> payload) async {
  http.Response response =
      await apiGetCall(payload: payload, url: MESSAGE_LIST, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.LIST];
  }
}

Future getNoteMessage(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: MESSAGE_NOTE,
    isUser: true,
    isLoading: false,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.LIST];
  }
}
