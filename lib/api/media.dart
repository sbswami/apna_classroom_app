import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createMedia(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: MEDIA_CREATE, payload: payload, isUser: true, isLoading: false);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.MEDIA];
  }
}

Future getMedia(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: MEDIA_GET,
    isUser: true,
    isLoading: true,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.MEDIA];
  }
}

Future listMedia(Map<String, String> payload, List<String> subjects) async {
  http.Response response = await apiGetCall(
      payload: payload,
      url: MEDIA_LIST,
      isUser: true,
      list: {C.SUBJECT: subjects});
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.LIST];
  }
}
