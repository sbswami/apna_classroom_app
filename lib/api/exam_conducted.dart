import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/helper.dart';
import 'package:apna_classroom_app/screens/classroom/controllers/classroom_list_controller.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:http/http.dart' as http;

Future createExamConducted(Map<String, dynamic> payload) async {
  http.Response response =
      await apiCall(url: EXAM_CONDUCTED_CREATE, payload: payload, isUser: true);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    data[C.MESSAGE].forEach((element) {
      ClassroomListController.to
          .addMessage(element[C.CLASSROOM][C.ID], element);
    });
    return data[C.EXAM_CONDUCTED];
  }
}

Future deleteExamConducted(Map<String, dynamic> payload) async {
  http.Response response =
      await apiCall(url: EXAM_CONDUCTED_DELETE, payload: payload, isUser: true);

  if (response.statusCode == 200) {
    return true;
  }

  if (response.statusCode == 403) {
    return false;
  }
}

Future getExamConducted(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
    payload: payload,
    url: EXAM_CONDUCTED_GET,
    isUser: true,
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.EXAM_CONDUCTED];
  }
}

Future listExamConducted(Map<String, String> payload) async {
  http.Response response = await apiGetCall(
      payload: payload, url: EXAM_CONDUCTED_LIST, isUser: true);
  if (response.statusCode == 200) {
    return json.decode(response.body)[C.LIST];
  }
}
