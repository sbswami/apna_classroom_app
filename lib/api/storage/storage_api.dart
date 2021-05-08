import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/storage/storage.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:http/http.dart' as http;
import 'package:video_compress/video_compress.dart';

uploadToStorage({File file, String type, File thumbnail}) async {
  // Track event
  track(EventName.MEDIA_UPLOADED, {
    EventProp.TYPE: type,
    EventProp.SIZE:
        ((await file.length()) / 1048576).floor(), // Convert into MB
  });

  // Without file name like, main or thumbnail
  String withoutFile = file.path.substring(0, file.path.lastIndexOf('/'));

  // Folder name
  String name = withoutFile.substring(withoutFile.lastIndexOf('/') + 1);

  // Saving file path
  String filePath = createFilePath(type: type, name: name);

  String fileExtension = getExtension(file.path);
  String thumbnailExtension = getExtension(thumbnail.path);

  // Save Thumbnail
  await uploadFileAndGetPath(
    thumbnail,
    filePath + '/' + FileName.THUMBNAIL + thumbnailExtension,
  );

  // Save file
  String mainPath = filePath + '/' + FileName.MAIN + fileExtension;

  // Notification ID
  int notificationId = int.parse(name.substring(name.length - 3));

  if (type == FileType.VIDEO) {
    int onStartJump = 5;

    // Upload Notification with base start of process
    uploadNotification(notificationId: notificationId, progress: onStartJump);

    // // Just show user having some progress
    // Future.delayed(Duration(seconds: 5), () {
    //   onStartJump += 5;
    //   uploadNotification(notificationId: notificationId, progress: onStartJump);
    // });

    VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
    ).then((mediaInfo) {
      uploadWithNotification(
        file: mediaInfo.file,
        path: mainPath,
        notificationId: notificationId,
        onStartJump: onStartJump,
      );
    });
  } else {
    uploadWithNotification(
      file: file,
      path: mainPath,
      notificationId: notificationId,
    );
  }

  return {StorageConstant.PATH: filePath};

  String url = '$storageApiRoot$UPLOAD_FILE';

  var uri = Uri.parse(url);

  var request = http.MultipartRequest('POST', uri)
    ..headers[StorageConstant.APP_KEY] = APP_KEY
    ..headers[StorageConstant.USER_ID] = getUserId()
    ..fields[StorageConstant.TYPE] = type
    ..fields[StorageConstant.NAME] = name
    ..files.add(
      await http.MultipartFile.fromPath(
        StorageConstant.FILE,
        file.path,
        // contentType: MediaType('application', 'x-tar'),
      ),
    )
    ..files.add(
      await http.MultipartFile.fromPath(
        StorageConstant.THUMBNAIL,
        thumbnail.path,
      ),
    );
  var streamResponse = await request.send();

  var response = await http.Response.fromStream(streamResponse);
  if (streamResponse.statusCode == 200) {
    return json.decode(response.body);
  }
  return {};
}

Future<http.Response> downloadFromStorage({String path, String name}) async {
  String downloadUrl = await getDownloadUrl(path + '/' + name);
  return http.get(downloadUrl);

  Map<String, String> payload = {
    StorageConstant.PATH: path,
    StorageConstant.TYPE: name,
  };

  Map<String, String> headers = {
    StorageConstant.APP_KEY: APP_KEY,
  };
  Uri uri = Uri.http(storageApiRootGet, FILE_ROOT, payload);
  String urlNew = uri.toString();
  http.Response response = await http.get(urlNew, headers: headers);
  return response;
}
