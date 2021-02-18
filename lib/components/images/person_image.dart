import 'dart:io';
import 'dart:math' as math;

import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/screens/media/image_viewer.dart';
import 'package:apna_classroom_app/util/assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const DEFAULT_IMAGE_SIZE = 150.0;

class PersonImage extends StatelessWidget {
  final double size;
  final bool editMode;
  final File image;
  final String url;
  final File thumbnailImage;
  final String thumbnailUrl;
  final Function onPhotoSelect;

  const PersonImage(
      {Key key,
      this.size,
      this.editMode,
      this.image,
      this.url,
      this.thumbnailImage,
      this.thumbnailUrl,
      this.onPhotoSelect})
      : super(key: key);

  onTap() {
    if ((image ?? url) != null) {
      Get.to(ImageViewer(
        image: image,
        url: url,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (image ?? url) != null ? onTap : null,
      child: Stack(
        children: [
          Container(
            child: ClipRRect(
              child: getImage(),
              borderRadius: BorderRadius.circular(size ?? DEFAULT_IMAGE_SIZE),
            ),
            height: size ?? DEFAULT_IMAGE_SIZE,
            width: size ?? DEFAULT_IMAGE_SIZE,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(size ?? DEFAULT_IMAGE_SIZE),
            ),
          ),
          if (editMode ?? false) BlackArc(diameter: size ?? DEFAULT_IMAGE_SIZE),
          if (editMode ?? false)
            Positioned(
              child: GestureDetector(
                onTap: onPhotoSelect,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: size ?? DEFAULT_IMAGE_SIZE,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              bottom: 1,
              // left: 67,
            ),
        ],
      ),
    );
  }

  Widget getImage() {
    if (thumbnailImage != null) {
      return Image.file(thumbnailImage, fit: BoxFit.cover);
    }
    if (thumbnailUrl != null) {
      return UrlImage(url: thumbnailUrl, fit: BoxFit.cover);
    }
    return Image.asset(A.PERSON);
  }
}

class BlackArc extends StatelessWidget {
  final double diameter;

  const BlackArc({Key key, this.diameter = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black38;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      2.12 * math.pi,
      math.pi * 0.75,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
