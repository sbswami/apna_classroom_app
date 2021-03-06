import 'dart:io';
import 'dart:typed_data';

import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/components/menu/apna_menu.dart';
import 'package:apna_classroom_app/components/menu/menu_item.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/media/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OptionCheckBox extends StatelessWidget {
  final bool checked;
  final Function(bool checked) onChanged;
  final String text;
  final String url;
  final File image;
  final Uint8List bytes;
  final File thumbnailImage;
  final Uint8List thumbnailBytes;
  final Function onDelete;
  final int groupValue;
  final Function(int option) onChangeRadio;
  final int valueRadio;
  final bool isCheckBox;
  final Color color;
  final bool isEditable;

  const OptionCheckBox(
      {Key key,
      this.checked,
      this.onChanged,
      this.text,
      this.url,
      this.image,
      this.bytes,
      this.thumbnailImage,
      this.thumbnailBytes,
      this.onDelete,
      this.groupValue,
      this.onChangeRadio,
      this.valueRadio,
      this.isCheckBox,
      this.color,
      this.isEditable})
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
    if (!(isEditable ?? false)) return;
    if (isCheckBox && onChanged != null) return onChanged(!checked);
    if (!isCheckBox && onChangeRadio != null) return onChangeRadio(valueRadio);
  }

  _onChanged(bool _checked) {
    if (isEditable) onChanged(_checked);
  }

  _onChangeRadio(int _option) {
    if (isEditable) onChangeRadio(_option);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isCheckBox)
          Checkbox(
            value: checked,
            onChanged: _onChanged,
            activeColor: color,
            checkColor: Theme.of(context).cardColor,
          ),
        if (!isCheckBox)
          Radio(
            value: valueRadio,
            groupValue: groupValue,
            onChanged: _onChangeRadio,
            activeColor: color,
          ),
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
    if (url != null) {
      return UrlImage(
        url: url,
        fileName: FileName.THUMBNAIL,
      );
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
