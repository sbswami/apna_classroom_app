import 'dart:io';

import 'package:apna_classroom_app/api/storage.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as ImageLib;

showApnaFilePicker(bool multiple) async {
  try {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
      allowCompression: true,
      allowMultiple: multiple,
    );
    if (result == null) return;
    var newFiles = await Future.wait(result.files.map((single) async {
      String _filePath = single.path;

      switch (single.extension) {
        case 'pdf':
          File thumbnailImage = await getPdfCoverImage(path: _filePath);
          File pdfFile = await saveToDevice(
              path: PDF_PATH, file: File(_filePath), extension: '.pdf');
          return {
            C.TYPE: E.PDF,
            C.FILE: pdfFile,
            C.THUMBNAIL: thumbnailImage,
            C.TITLE: removeExtension(single.name)
          };
        case 'jpg':
        case 'png':
        case 'JPEG':
        case 'JPG':
        case 'PNG':
          ImageLib.Image thumbnail = await compressImage(path: _filePath);
          File thumbnailImage = await saveToDevice(
            path: IMAGE_THUMBNAIL_PATH,
            bytes: ImageLib.encodePng(thumbnail),
            extension: '.png',
          );
          File image = await saveToDevice(
              path: IMAGE_PATH,
              file: File(_filePath),
              extension: '.${single.extension}');
          return {
            C.TYPE: E.IMAGE,
            C.FILE: image,
            C.THUMBNAIL: thumbnailImage,
            C.TITLE: removeExtension(single.name)
          };
          break;
        case 'mp4':
          break;
      }
    }).toList());

    return newFiles;
  } on PlatformException catch (e) {
    print("Error while picking the file: " + e.toString());
  }
}
