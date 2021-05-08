import 'dart:convert';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<http.Response> apiCall({
  String url,
  Map<String, dynamic> payload,
  bool isUser,
  bool isLoading = true,
}) async {
  if (payload == null) {
    payload = {};
  }
  payload[C.CREATED_AT] = DateTime.now().toString();
  Map<String, String> headers = {
    C.CONTENT_TYPE: C.APPLICATION_JSON,
  };
  if (isUser != null && isUser) {
    headers[C.UID] = FirebaseAuth.instance.currentUser.uid;
  }

  if (isLoading) showProgress();

  http.Response response = await http
      .post(apiRoot + url,
          body: json.encoder.convert(payload), headers: headers)
      .catchError(handleAPIError);
  if (isLoading) Get.back();
  return response;
}

Future<http.Response> apiGetCall({
  String url,
  Map<String, dynamic> payload,
  bool isUser,
  bool isLoading = false,
  Map<String, List<String>> list,
}) async {
  Map<String, String> headers = {
    C.CONTENT_TYPE: C.APPLICATION_JSON,
  };
  if (isUser != null && isUser) {
    headers[C.UID] = FirebaseAuth.instance.currentUser.uid;
  }

  if (isLoading) showProgress();

  Uri uri = Uri.http(apiRootGet, url, payload);
  String urlNew = uri.toString();
  if (list != null) {
    String initValue = payload == null ? '?' : '';
    String newPath = uri.toString() +
        list
            .map(
              (key, value) => MapEntry(
                key,
                value.fold(
                    initValue,
                    (previousValue, element) =>
                        previousValue + '&$key=$element'),
              ),
            )
            .values
            .join();
    urlNew = newPath;
  }
  http.Response response = await http.get(urlNew, headers: headers);

  if (isLoading) Get.back();
  return response;
}

parseUrl(String url) {
  Uri data = Uri.parse(url);
  return data.path
      .substring(data.path.lastIndexOf('/') + 1, data.path.length)
      .replaceAll('%2F', '/');
}

handleAPIError(error) {
  ok(title: S.BAD_REQUEST.tr, msg: S.BAD_REQUEST_PLEASE_GIVE_US_FEEDBACK.tr);
}
