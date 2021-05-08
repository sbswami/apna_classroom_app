import 'dart:typed_data';

import 'package:apna_classroom_app/api/storage/storage.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/components/buttons/flat_icon_text_button.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ApnaImagePicker extends StatelessWidget {
  const ApnaImagePicker({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatIconTextButton(
                iconData: Icons.camera_alt,
                text: S.CAMERA.tr,
                onPressed: () => Get.back(result: _CAMERA),
              ),
              FlatIconTextButton(
                iconData: Icons.photo_library,
                text: S.GALLERY.tr,
                onPressed: () => Get.back(result: _GALLERY),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

showApnaImagePicker(BuildContext context, {double maxSize}) async {
  var result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ApnaImagePicker();
      });
  final picker = ImagePicker();
  PickedFile pickedFile;

  showProgress();

  switch (result) {
    case _CAMERA:
      pickedFile = await picker.getImage(
          source: ImageSource.camera, maxWidth: maxSize, maxHeight: maxSize);
      break;
    case _GALLERY:
      pickedFile = await picker.getImage(
          source: ImageSource.gallery, maxWidth: maxSize, maxHeight: maxSize);
      break;
    default:
      return Get.back();
  }

  if (pickedFile == null) return Get.back();
  String filePath = pickedFile.path;
  Uint8List thumbnail = await compressImage(path: filePath, thumbnail: true);

  Uint8List compressedFile = await compressImage(path: filePath);

  // Save main image to local
  Map mainFile = await saveToDevice(
    bytes: compressedFile,
    extension: getExtension(filePath),
    type: FileType.IMAGE,
    name: FileName.MAIN,
  );
  var image = mainFile[C.FILE];

  // Save thumbnail to local
  Map thumbnailFile = await saveToDevice(
    // bytes: ImageLib.encodePng(thumbnail),
    bytes: thumbnail,
    extension: '.jpg',
    type: FileType.IMAGE,
    name: FileName.THUMBNAIL,
    filename: mainFile[C.NAME],
  );

  var thumbnailImage = thumbnailFile[C.FILE];

  Get.back();
  return [filePath, thumbnailImage, image];
}

const String _CAMERA = 'CAMERA';
const String _GALLERY = 'GALLERY';
