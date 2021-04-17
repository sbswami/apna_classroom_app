import 'dart:io';

import 'package:apna_classroom_app/api/storage.dart';
import 'package:apna_classroom_app/components/buttons/flat_icon_text_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as ImageLib;
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
      return;
  }

  if (pickedFile == null) return;
  String filePath = pickedFile.path;
  ImageLib.Image thumbnail = await compressImage(path: filePath);
  File thumbnailImage = await saveToDevice(
    path: IMAGE_THUMBNAIL_PATH,
    bytes: ImageLib.encodePng(thumbnail),
    extension: '.png',
  );
  File image = await saveToDevice(
      path: IMAGE_PATH,
      file: File(filePath),
      extension: getExtension(filePath));
  return [filePath, thumbnailImage, image];
}

const String _CAMERA = 'CAMERA';
const String _GALLERY = 'GALLERY';
