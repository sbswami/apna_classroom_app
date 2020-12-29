import 'dart:io';

import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/screens/image_viewer/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LabeledImage extends StatelessWidget {
  final String label;
  final File image;
  final String url;
  final File thumbnailImage;
  final String thumbnailUrl;

  const LabeledImage(
      {Key key,
      this.label,
      this.image,
      this.url,
      this.thumbnailImage,
      this.thumbnailUrl})
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
    if (thumbnailUrl != null) {
      return UrlImage(url: thumbnailUrl);
    }
    if (thumbnailImage != null) {
      return Image.file(thumbnailImage);
    }
    return SizedBox();
  }
}
