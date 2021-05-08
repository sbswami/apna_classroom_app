import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createJoinRequest(Map<String, dynamic> payload) async {
  http.Response response =
      await apiCall(url: JOIN_REQUEST_CREATE, payload: payload, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.JOIN_REQUEST];
  }
}

Future deleteJoinRequest(Map<String, String> payload) async {
  http.Response response =
      await apiCall(payload: payload, url: JOIN_REQUEST_DELETE, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.MESSAGE];
  }
}

Future listJoinRequest(Map<String, String> payload) async {
  http.Response response =
      await apiGetCall(payload: payload, url: JOIN_REQUEST_LIST, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.LIST];
  }
}
