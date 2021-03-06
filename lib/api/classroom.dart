import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/screens/classroom/controllers/classroom_list_controller.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
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
  if (response.statusCode == 403) {
    var data = json.decode(response.body);

    if (data[C.CLASSROOM] != null) {
      return data[C.CLASSROOM];
    }
    return {
      C.PRIVACY: E.PRIVATE,
    };
  }
}

Future listClassroom(Map<String, String> payload, List<String> subjects,
    List<String> exams) async {
  http.Response response = await apiGetCall(
      payload: payload,
      url: CLASSROOM_LIST,
      isUser: true,
      list: {C.SUBJECT: subjects, C.EXAM: exams});
  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
}

Future addMembers(Map<String, dynamic> payload) async {
  http.Response response =
      await apiCall(url: ADD_MEMBERS_CREATE, payload: payload, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
}

Future removeMember(Map<String, dynamic> payload) async {
  http.Response response =
      await apiCall(url: REMOVE_MEMBER, payload: payload, isUser: true);
  return response.statusCode == 200;
}

Future<bool> deleteClassroom(Map<String, dynamic> payload) async {
  http.Response response = await apiCall(
      url: CLASSROOM_DELETE, payload: payload, isUser: true, isLoading: true);

  return response.statusCode == 200;
}

joinClassroom(classroom) async {
  await addMembers({
    C.ID: classroom[C.ID],
    C.MEMBERS: [
      {
        C.ID: getUserId(),
        C.ROLE: E.MEMBER,
      }
    ]
  });
  ClassroomListController.to.insertClassrooms([classroom]);
}
