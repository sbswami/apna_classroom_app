import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createUserDetails(Map<String, dynamic> payload) async {
  http.Response response =
      await apiCall(url: USER_DETAILS_CREATE, payload: payload, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.USER_DETAILS];
  }
}

Future unseenUserDetails(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: USER_DETAILS_UNSEEN,
      payload: payload,
      isUser: true,
      isLoading: false);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.MESSAGE];
  }
}
