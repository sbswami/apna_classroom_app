import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyInfo extends StatelessWidget {
  final EmptyInfoType type;

  const EmptyInfo({Key key, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 64),
        Text(
          getHeading().tr,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 8),
        Text(getMessage().tr),
        SizedBox(height: 24),
        SizedBox(
          height: 200,
          child: Image.asset(
            getAsset(),
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

  getAsset() {
    return A.EMPTY_BOOK;
  }

  String getHeading() {
    switch (type) {
      case EmptyInfoType.Media:
        return S.NOT_FOUND;
        break;
    }
    return S.NOT_FOUND;
  }

  String getMessage() {
    switch (type) {
      case EmptyInfoType.Media:
        return S.NO_MEDIA_MSG;
        break;
    }
    return S.NOT_FOUND_MSG;
  }
}

enum EmptyInfoType { Media }
