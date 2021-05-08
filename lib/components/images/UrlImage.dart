import 'dart:io';

import 'package:apna_classroom_app/util/assets.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:flutter/material.dart';

class UrlImage extends StatefulWidget {
  final String fileName;
  final String url;
  final BoxFit fit;
  final double borderRadius;

  const UrlImage({
    Key key,
    this.url,
    this.fit,
    this.borderRadius,
    @required this.fileName,
  }) : super(key: key);

  @override
  _UrlImageState createState() => _UrlImageState();
}

class _UrlImageState extends State<UrlImage> {
  _onLoadFinish() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (widget.url == null || snapshot.hasError) {
          return Image.asset(
            A.PERSON,
            fit: widget.fit,
          );
        }
        if (snapshot.hasData || snapshot.data != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 4.0),
            child: Image.file(
              snapshot.data,
              fit: widget.fit,
            ),
          );
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        );
      },
      future: getFile(
        widget.url,
        name: widget.fileName,
        onLoadFinish: _onLoadFinish,
      ),
    );
  }
}
