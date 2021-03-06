import 'dart:io';
import 'dart:typed_data';

import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/assets.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final File image;
  final Uint8List bytes;
  final String url;

  const ImageViewer({Key key, this.image, this.bytes, this.url})
      : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool isLoading = false;
  File image;

  _onFinish() {
    if (mounted) loadImage();
  }

  loadImage() async {
    if (widget.url != null) {
      File _image = await getFile(
        widget.url,
        name: FileName.MAIN,
        onLoadFinish: _onFinish,
      );
      if (_image != null) {
        setState(() {
          image = _image;
          isLoading = false;
        });
      }
    }

    // Track Event
    track(EventName.IMAGE_VIEWER, {
      EventProp.TYPE: widget.url == null ? 'File' : 'URL',
    });
  }

  @override
  void initState() {
    if (widget.url != null) {
      isLoading = true;
    }
    super.initState();

    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.IMAGE_VIEWER.tr),
      ),
      body: isLoading
          ? DetailsSkeleton(
              type: DetailsType.ImageInfo,
            )
          : Center(
              child: PhotoView(
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                imageProvider: getImage(),
              ),
            ),
    );
  }

  ImageProvider getImage() {
    if (widget.image != null) {
      return FileImage(widget.image);
    }
    if (widget.bytes != null) {
      return MemoryImage(widget.bytes);
    }
    if (widget.url != null) {
      return FileImage(image);
    }
    return AssetImage(A.APP_ICON);
  }
}
