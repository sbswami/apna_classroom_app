import 'dart:io';

import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/notifications/notifications_helper.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

const String IMAGES = 'images';

/// Return download link
UploadTask uploadFile(File file, String path) {
  if (file == null) return null;
  Reference reference = FirebaseStorage.instance.ref(path);
  return reference.putFile(file);
}

/// Upload with Notification
uploadWithNotification(
    {File file, String path, int notificationId = 0, int onStartJump = 0}) {
  // Upload Task
  UploadTask uploadTask = uploadFile(file, path);

  uploadTask.snapshotEvents.listen((event) {
    int progress = ((event.bytesTransferred / event.totalBytes) * 100).floor();
    if (onStartJump != 0 && progress < onStartJump) {
      progress = onStartJump;
    }

    uploadNotification(notificationId: notificationId, progress: progress);

    if (progress == 100) {
      AwesomeNotifications().cancel(notificationId);
    }
  });
}

/// Upload Notification
uploadNotification({int notificationId, int progress}) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: notificationId,
      channelKey: CQN_NOTIFY_CHANNEL,
      title: progress == 100 ? S.UPLOADED.tr : S.UPLOADING_FILE.tr,
      progress: progress,
      notificationLayout: NotificationLayout.ProgressBar,
      locked: progress != 100,
    ),
  );
}

List<String> downloading = [];
downloadWithNotification({
  File file,
  String fullPath,
  String fileType,
  Function onLoadFinish,
}) async {
  // Folder name
  String name = fullPath.substring(fullPath.lastIndexOf('/') + 1);

  // Notification ID
  int notificationId = int.parse(name.substring(name.length - 3));

  Reference ref = FirebaseStorage.instance.ref(fullPath);

  ListResult listAll = await ref.listAll();

  if (listAll.items.length == 0) {
    if (fileType != FileName.THUMBNAIL)
      ok(title: S.UPLOADING_FILE.tr, msg: S.UPLOADING_BY_CREATOR.tr);

    return null;
  }

  // Check for non-uploaded file
  int fileIndex = listAll.items.indexWhere(
    (element) => element.name.contains(fileType),
  );
  Reference storageFile = fileIndex >= 0 ? listAll.items[fileIndex] : null;

  if (storageFile == null || storageFile.isBlank) {
    if (fileType != FileName.THUMBNAIL)
      ok(title: S.UPLOADING_FILE.tr, msg: S.UPLOADING_BY_CREATOR.tr);

    return null;
  }

  FullMetadata metaData = await storageFile.getMetadata();

  // Below 500KB files
  if (metaData.size < 500000) {
    await file.writeAsBytes(await storageFile.getData());
    return file;
  }

  if (downloading.contains(fullPath)) {
    return;
  }

  DownloadTask task = storageFile.writeToFile(file);

  downloading.add(fullPath);

  if (GetPlatform.isIOS)
    downloadNotification(notificationId: notificationId, progress: 0);

  task.snapshotEvents.listen((event) {
    int progress = ((event.bytesTransferred / event.totalBytes) * 100).floor();

    if (GetPlatform.isAndroid)
      downloadNotification(notificationId: notificationId, progress: progress);

    if (progress == 100) {
      AwesomeNotifications().cancel(notificationId);
      downloading.remove(fullPath);
      if (onLoadFinish != null) onLoadFinish();
    }
  });
  return null;
}

downloadNotification({int notificationId, int progress}) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: notificationId,
      channelKey: CQN_NOTIFY_CHANNEL,
      title: progress == 100 ? S.DOWNLOADED.tr : S.DOWNLOADING_FILE.tr,
      progress: progress,
      displayOnForeground: true,
      notificationLayout: NotificationLayout.ProgressBar,
    ),
  );
}

/// Upload File and Get Full Path
Future<String> uploadFileAndGetPath(File file, String path) async {
  if (file == null) return null;
  Reference reference = FirebaseStorage.instance.ref(path);
  TaskSnapshot snapshot = await reference.putFile(file);
  return snapshot.ref.fullPath;
}

/// Upload Images to [IMAGE_PATH]
Future<String> uploadImage(File file) async {
  return uploadFileAndGetPath(file,
      '${getUserId()}/$IMAGE_PATH/${getFileNameWithExtension(file: file)}');
}

/// Upload PDF to [PDF_PATH]
Future<String> uploadPdf(File file) async {
  return uploadFileAndGetPath(
      file, '${getUserId()}/$PDF_PATH/${getFileNameWithExtension(file: file)}');
}

/// Upload Image Thumbnail to [IMAGE_THUMBNAIL_PATH]
Future<String> uploadImageThumbnail(File file) async {
  return uploadFileAndGetPath(file,
      '${getUserId()}/$IMAGE_THUMBNAIL_PATH/${getFileNameWithExtension(file: file)}');
}

/// Upload PDF to [PDF_THUMBNAIL_PATH]
Future<String> uploadPdfThumbnail(File file) async {
  return uploadFileAndGetPath(file,
      '${getUserId()}/$PDF_THUMBNAIL_PATH/${getFileNameWithExtension(file: file)}');
}

Future<String> getDownloadUrl(String fullPath) async {
  return await FirebaseStorage.instance.ref(fullPath).getDownloadURL();
}

//--------------------------------+++++++++++++++++++++++++++++++--------------
/// Get File Name With Extension
String getFileNameWithExtension({File file, String filePath}) {
  String path = filePath ?? file.path;
  return path.substring(path.lastIndexOf('/') + 1);
}

/// Get File Name Without Extension
String getFileName({File file, String filePath}) {
  return removeExtension(
      getFileNameWithExtension(file: file, filePath: filePath));
}

/// Remove File extension from file name
String removeExtension(String name) {
  var names = name.split('.');
  names.removeLast();
  return names.join('.');
}

/// Remove File name from file path
String removeFileName(String fullPath) {
  var path = fullPath.split('/');
  path.removeLast();
  return path.join('/');
}

/// Get extension from file name or path
String getExtension(String name) {
  var names = name.split('.');
  return '.' + names.last;
}

/// Create file path
String createFilePath({String type, String name}) {
  String userId = getUserId();
  if (apiRootGet == API_ROOT_GET_DEV) {
    userId = 'dev' + '/' + userId;
  }
  return userId + '/' + type + '/' + name;
}
