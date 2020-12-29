import 'dart:io';
import 'dart:typed_data';

import 'package:apna_classroom_app/components/apna_menu.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/components/menu_item.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/image_viewer/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionCheckBox extends StatelessWidget {
  final bool checked;
  final Function(bool checked) onChanged;
  final String text;
  final String url;
  final File image;
  final Uint8List bytes;
  final String thumbnailUrl;
  final File thumbnailImage;
  final Uint8List thumbnailBytes;
  final Function onDelete;
  final int groupValue;
  final Function(int option) onChangeRadio;
  final int valueRadio;
  final bool isCheckBox;

  const OptionCheckBox(
      {Key key,
      this.checked,
      this.onChanged,
      this.text,
      this.url,
      this.image,
      this.bytes,
      this.thumbnailUrl,
      this.thumbnailImage,
      this.thumbnailBytes,
      this.onDelete,
      this.groupValue,
      this.onChangeRadio,
      this.valueRadio,
      this.isCheckBox})
      : super(key: key);

  onLongPress(BuildContext context) {
    List<MenuItem> items = [];
    if (onDelete != null) {
      items.add(
        MenuItem(
          text: S.DELETE.tr,
          iconData: Icons.delete,
          onTap: () {
            onDelete();
            Get.back();
          },
        ),
      );
    }
    if (text == null) {
      items.add(MenuItem(
        text: S.OPEN_IMAGE.tr,
        iconData: Icons.image,
        onTap: () {
          Get.back();
          Get.to(ImageViewer(image: image, bytes: bytes, url: url));
        },
      ));
    }
    if (items.isEmpty) return;
    showApnaMenu(context, items);
  }

  onTapBox() {
    if (isCheckBox && onChanged != null) return onChanged(!checked);
    if (!isCheckBox && onChangeRadio != null) return onChangeRadio(valueRadio);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isCheckBox) Checkbox(value: checked, onChanged: onChanged),
        if (!isCheckBox)
          Radio(
              value: valueRadio,
              groupValue: groupValue,
              onChanged: onChangeRadio),
        GestureDetector(
          child: text != null
              ? Text(text)
              : Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: getOption(),
                      )),
                ),
          onTap: onTapBox,
          onLongPress: () => onLongPress(context),
        ),
      ],
    );
  }

  Widget getOption() {
    if (thumbnailUrl != null) {
      return UrlImage(url: thumbnailUrl);
    }
    if (thumbnailImage != null) {
      return Image.file(thumbnailImage);
    }
    if (thumbnailBytes != null) {
      return Image.memory(thumbnailBytes);
    }
    return SizedBox();
  }
}
