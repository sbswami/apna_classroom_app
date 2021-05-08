import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/auth/auth.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:http/http.dart' as http;

Future createUser(Map<String, dynamic> payload) async {
  http.Response response =
      await apiCall(url: USER_CREATE, payload: payload, isLoading: false);
  if (response.statusCode == 200) {
    UserController.to.updateUser(json.decode(response.body)[C.USER]);
  }
}

Future getUser() async {
  http.Response response = await apiGetCall(url: USER_GET, isUser: true);
  if (response.statusCode == 200) {
    var _user = json.decode(response.body)[C.USER];
    if (_user[C.ACTIVE_DEVICE] != await getDeviceID()) {
      await signOut();
      return;
    }
    UserController.to.updateUser(_user);
    return true;
  }
}

Future updateUser(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: USER_UPDATE, payload: payload, isUser: true, isLoading: false);
  if (response.statusCode == 200) {
    UserController.to.updateUser(json.decode(response.body)[C.USER]);
  }
}

Future checkUsername(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
      url: USER_CHECK_USERNAME, payload: payload, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.USER];
  }
}

Future searchPerson(Map<String, String> payload) async {
  http.Response response =
      await apiGetCall(url: USER_SEARCH_PERSON, payload: payload, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.LIST];
  }
}

Future getPerson(Map<String, String> payload) async {
  http.Response response =
      await apiGetCall(url: USER_GET_PERSON, payload: payload, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.PERSON];
  }
  if (response.statusCode == 403) {
    return {};
  }
}

Future getSubjectsUser() async {
  http.Response response = await apiGetCall(url: USER_SUBJECTS, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.SUBJECT];
  }
}

Future getExamsUser() async {
  http.Response response = await apiGetCall(url: USER_EXAMS, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.EXAM];
  }
}
