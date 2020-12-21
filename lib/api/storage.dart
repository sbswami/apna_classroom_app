import 'dart:io';

import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

const String PROFILE_IMAGE = 'profileImage';
const String IMAGES = 'images';

/// Return download link
Future<String> uploadFile(File file, String path) async {
  if (file == null) return null;
  showProgress();
  Reference reference = FirebaseStorage.instance.ref(path);
  TaskSnapshot snapshot = await reference.putFile(file);
  String downloadUrl = await snapshot.ref.getDownloadURL();
  Get.back();
  return downloadUrl;
}

Future<String> uploadProfileImage(File image) {
  return uploadFile(image, '$PROFILE_IMAGE/${getUserId()}');
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
  return uploadFileAndGetPath(
      file, '${getUserId()}/$IMAGE_PATH/${getFileNameWithExtension(file)}');
}

/// Upload PDF to [PDF_PATH]
Future<String> uploadPdf(File file) async {
  return uploadFileAndGetPath(
      file, '${getUserId()}/$PDF_PATH/${getFileNameWithExtension(file)}');
}

/// Upload Image Thumbnail to [IMAGE_THUMBNAIL_PATH]
Future<String> uploadImageThumbnail(File file) async {
  return uploadFileAndGetPath(file,
      '${getUserId()}/$IMAGE_THUMBNAIL_PATH/${getFileNameWithExtension(file)}');
}

/// Upload PDF to [PDF_THUMBNAIL_PATH]
Future<String> uploadPdfThumbnail(File file) async {
  return uploadFileAndGetPath(file,
      '${getUserId()}/$PDF_THUMBNAIL_PATH/${getFileNameWithExtension(file)}');
}

Future<String> getDownloadUrl(String fullPath) async {
  return await FirebaseStorage.instance.ref(fullPath).getDownloadURL();
}

//--------------------------------+++++++++++++++++++++++++++++++--------------
/// Get File Name With Extension
String getFileNameWithExtension(File file) {
  return file.path.substring(file.path.lastIndexOf('/') + 1);
}

/// Get File Name Without Extension
String getFileName(File file) {
  return removeExtension(getFileNameWithExtension(file));
}

String removeExtension(String name) {
  var names = name.split('.');
  names.removeLast();
  return names.join('.');
}
