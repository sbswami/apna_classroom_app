import 'dart:io';

import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/screens/media/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LabeledImage extends StatelessWidget {
  final String label;
  final File image;
  final String url;
  final File thumbnailImage;

  const LabeledImage(
      {Key key, this.label, this.image, this.url, this.thumbnailImage})
      : super(key: key);

  onTap() {
    Get.to(ImageViewer(image: image, url: url));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width * 0.5 - 20,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: getContent(),
              ),
              SelectableText(label),
            ],
          ),
        ),
      ),
    );
  }

  Widget getContent() {
    if (url != null) {
      return UrlImage(url: url, fileName: FileName.THUMBNAIL);
    }
    if (thumbnailImage != null) {
      return Image.file(thumbnailImage);
    }
    return SizedBox();
  }
}
