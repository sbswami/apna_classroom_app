import 'dart:io';
import 'dart:typed_data';

import 'package:apna_classroom_app/api/storage.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart';

const String PDF_PATH = '/pdf/';
const String IMAGE_PATH = '/image/';
const String VIDEO_PATH = '/video/';

const String PDF_THUMBNAIL_PATH = '/pdf/thumbnail/';
const String IMAGE_THUMBNAIL_PATH = '/image/thumbnail/';
const String VIDEO_THUMBNAIL_PATH = '/video/thumbnail/';

// User can't see files
Future<File> saveToDevice(
    {@required String path,
    Uint8List bytes,
    File file,
    String extension}) async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  Directory directory =
      await Directory(appDocDirectory.path + path).create(recursive: true);

  File newFile = File(directory.path + getUniqueId() + extension);

  if (bytes != null)
    await newFile.writeAsBytes(bytes);
  else if (file != null) await newFile.writeAsBytes(await file.readAsBytes());

  return newFile;
}

// Compress Image
Future<Image> compressImage({
  String path,
  Uint8List bytes,
  File file,
}) async {
  Image image;
  if (file != null) {
    image = decodeImage(await file.readAsBytes());
  } else if (path != null) {
    image = decodeImage(await File(path).readAsBytes());
  } else if (bytes != null) {
    image = decodeImage(bytes);
  }
  return copyResize(image, width: 200);
}

// Get PDF Cover page image
Future<File> getPdfCoverImage({@required String path}) async {
  final document = await PdfDocument.openFile(path);
  final page = await document.getPage(1);
  double aspectRatio = page.width / page.height;
  final pageImage = await page.render(
    width: 200,
    height: 200 ~/ aspectRatio,
  );
  page.close();
  document.close();

  // Save Image to Local
  File thumbnailImage = await saveToDevice(
    path: PDF_THUMBNAIL_PATH,
    bytes: pageImage.bytes,
    extension: '.png',
  );
  return thumbnailImage;
}

// Get File
Future<File> getFile(String fullPath) async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  String localPath =
      fullPath.replaceFirst(UserController.to.currentUser[C.ID], '');
  Directory directory =
      await Directory(appDocDirectory.path + removeFileName(localPath))
          .create(recursive: true);
  File file = File(
      directory.path + '/' + getFileNameWithExtension(filePath: localPath));
  if (await file.exists()) return file;
  String downloadUrl = await getDownloadUrl(fullPath);
  http.Response response = await http.get(downloadUrl);
  await file.writeAsBytes(response.bodyBytes);
  return file;
}
