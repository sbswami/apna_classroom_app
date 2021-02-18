import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createText(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: TEXT_CREATE, payload: payload, isUser: true, isLoading: false);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.TEXT];
  }
}

Future getText(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: TEXT_GET,
    isUser: true,
    isLoading: true,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.TEXT];
  }
}
