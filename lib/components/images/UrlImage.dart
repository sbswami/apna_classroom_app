import 'dart:io';

import 'package:apna_classroom_app/util/assets.dart';
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
        if (url == null || snapshot.hasError) {
          return Image.asset(
            A.PERSON,
            fit: fit,
          );
        }
        if (snapshot.hasData) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.file(
              snapshot.data,
              fit: fit,
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
      future: getFile(url),
    );
  }
}
