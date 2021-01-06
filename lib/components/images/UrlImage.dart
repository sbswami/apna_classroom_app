import 'dart:io';

import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:flutter/material.dart';

class UrlImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const UrlImage({Key key, this.url, this.fit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.hasData) {
          return Image.file(
            snapshot.data,
            fit: fit,
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        );
      },
      future: getFile(url),
    );
  }
}
