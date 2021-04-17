import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createReport(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: REPORT_CREATE, payload: payload, isUser: true, isLoading: false);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.REPORT];
  }
}

Future getReport(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: REPORT_GET,
    isUser: true,
    isLoading: true,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.REPORT];
  }
}

Future listReport(Map<String, String> payload) async {
  http.Response response =
      await apiGetCall(payload: payload, url: REPORT_LIST, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.LIST];
  }
}
