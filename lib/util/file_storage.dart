import 'dart:io';
import 'dart:typed_data';

import 'package:apna_classroom_app/api/storage/storage.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
Future<Map<String, dynamic>> saveToDevice(
    {@required String type,
    @required String name,
    String filename,
    Uint8List bytes,
    File file,
    String extension}) async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();

  // File Name, filename is root file name in case of thumbnail
  String fileName = filename ?? getUniqueId();

  // File path same as Storage service
  String fullPath = createFilePath(type: type, name: fileName);

  // Local Directory to the files
  Directory directory = await Directory(appDocDirectory.path + '/' + fullPath)
      .create(recursive: true);

  // New File
  File newFile = File(directory.path + '/' + name + extension);

  // If bytes
  if (bytes != null) {
    await newFile.writeAsBytes(bytes);
  }
  // If file
  else if (file != null) {
    await newFile.writeAsBytes(await file.readAsBytes());
  }

  return {C.NAME: fileName, C.FILE: newFile};
}

// Compress Image
Future<Uint8List> compressImage({
  String path,
  File file,
  bool thumbnail = false,
}) async {
  if (path == null) path = file.path;
  int size = 1280;
  if (thumbnail) size = 200;

  var result = await FlutterImageCompress.compressWithFile(
    path,
    minWidth: size,
    minHeight: size,
    quality: thumbnail ? 20 : 50,
  );

  return result;
}

// Get PDF Cover page image
Future<File> getPdfCoverImage({
  @required String path,
  @required filename,
}) async {
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
  Map thumbnailFile = await saveToDevice(
    bytes: pageImage.bytes,
    extension: '.png',
    filename: filename,
    type: FileType.DOC,
    name: FileName.THUMBNAIL,
  );
  var thumbnailImage = thumbnailFile[C.FILE];

  return thumbnailImage;
}

// Get File
Future<File> getFile(String fullPath,
    {String name = FileName.THUMBNAIL, Function onLoadFinish}) async {
  if (fullPath == null) return null;

  if (downloading.contains(fullPath) && name != FileName.THUMBNAIL) {
    return null;
  }

  // Get local file dir
  Directory appDocDirectory = await getApplicationDocumentsDirectory();

  // Create dir if not exists and get path dir
  Directory directory = await Directory(appDocDirectory.path + '/' + fullPath)
      .create(recursive: true);

  // Get list of all files in a dir
  List files = directory.listSync();

  // Find the file contains the name
  List rightFiles = files
      .where(
        (element) => element.path.contains(name),
      )
      .toList();

  // If found a file contains the name
  if (rightFiles.length > 0) {
    // File name with extension
    String fullName = getFileNameWithExtension(filePath: rightFiles.first.path);

    // File with extension
    File file = File(directory.path + '/' + fullName);

    // If file locally exists return
    if (await file.exists()) return file;
  }

  // Get file
  File file = File(directory.path + '/' + name);

  return await downloadWithNotification(
    file: file,
    fullPath: fullPath,
    fileType: name,
    onLoadFinish: onLoadFinish,
  );

  // Reference ref = FirebaseStorage.instance.ref(fullPath);
  // DownloadTask task = ref.writeToFile(file);
  //
  // task.snapshotEvents.listen((event) {});
  //
  // // Download image
  // http.Response response = await downloadFromStorage(
  //   name: name,
  //   path: fullPath,
  // );
  //
  // // Save image to local storage
  // await file.writeAsBytes(response.bodyBytes);
  return file;
}
