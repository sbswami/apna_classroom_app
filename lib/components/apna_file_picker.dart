import 'dart:io';
import 'dart:typed_data';

import 'package:apna_classroom_app/api/storage/storage.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart'
    as StorageThing;
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

showApnaFilePicker(bool multiple) async {
  try {
    showProgress();
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'mp4'],
      allowCompression: true,
      allowMultiple: multiple,
    );

    if (result == null) return Get.back();

    var newFiles = await Future.wait(result.files.map((single) async {
      String _filePath = single.path;

      // More the 200MB is not allowed
      if (single.size > 209715200) {
        return null;
      }

      switch (single.extension) {
        case 'pdf':
        case 'PDF':
          Map file = await saveToDevice(
            file: File(_filePath),
            extension: '.${single.extension}',
            type: StorageThing.FileType.DOC,
            name: StorageThing.FileName.MAIN,
          );

          var pdfFile = file[C.FILE];

          File thumbnailImage = await getPdfCoverImage(
            path: _filePath,
            filename: file[C.NAME],
          );

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
        case 'jpeg':
          Uint8List thumbnail = await compressImage(
            path: _filePath,
            thumbnail: true,
          );

          Uint8List compressedFile = await compressImage(path: _filePath);

          // Save main image to local
          Map mainFile = await saveToDevice(
            bytes: compressedFile,
            extension: '.${single.extension}',
            type: StorageThing.FileType.IMAGE,
            name: StorageThing.FileName.MAIN,
          );
          var image = mainFile[C.FILE];

          // Save thumbnail to local
          Map thumbnailFile = await saveToDevice(
            bytes: thumbnail,
            extension: '.jpg',
            type: StorageThing.FileType.IMAGE,
            name: StorageThing.FileName.THUMBNAIL,
            filename: mainFile[C.NAME],
          );

          var thumbnailImage = thumbnailFile[C.FILE];

          return {
            C.TYPE: E.IMAGE,
            C.FILE: image,
            C.THUMBNAIL: thumbnailImage,
            C.TITLE: removeExtension(single.name)
          };
          break;
        case 'mp4':
        case 'MP4':
          // MediaInfo mediaInfo = await VideoCompress.compressVideo(
          //   _filePath,
          //   quality: VideoQuality.DefaultQuality,
          // );
          //
          // print(mediaInfo.filesize);
          // print(single.size);
          //
          // // Save main video to local
          Map mainFile = await saveToDevice(
            file: File(_filePath),
            extension: '.${single.extension}',
            type: StorageThing.FileType.VIDEO,
            name: StorageThing.FileName.MAIN,
          );
          var video = mainFile[C.FILE];

          Uint8List thumbnail = await VideoCompress.getByteThumbnail(
            _filePath,
            quality: 25,
          );

          // Save thumbnail to local
          Map thumbnailFile = await saveToDevice(
            bytes: thumbnail,
            extension: '.jpg',
            type: StorageThing.FileType.VIDEO,
            name: StorageThing.FileName.THUMBNAIL,
            filename: mainFile[C.NAME],
          );

          var thumbnailImage = thumbnailFile[C.FILE];

          return {
            C.TYPE: E.VIDEO,
            C.FILE: video,
            C.THUMBNAIL: thumbnailImage,
            C.TITLE: removeExtension(single.name)
          };
          break;
      }
    }).toList());
    Get.back();
    return newFiles;
  } on PlatformException catch (e) {
    print("Error while picking the file: " + e.toString());
  }
}
