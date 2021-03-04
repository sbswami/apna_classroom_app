import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyList extends StatelessWidget {
  final Function onClearFilter;
  final EmptyListType type;

  const EmptyList({Key key, this.onClearFilter, this.type}) : super(key: key);

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
        Image.asset(
          getAsset(),
          fit: BoxFit.fitHeight,
        ),
        SizedBox(height: 32),
        if (onClearFilter != null)
          PrimaryButton(
            text: S.CLEAR_FILTER.tr,
            onPress: onClearFilter,
          ),
      ],
    );
  }

  getAsset() {
    switch (type) {
      case EmptyListType.Chat:
        return A.EMPTY_CHAT;
      case EmptyListType.List:
        return A.EMPTY_BOOK;
      default:
        return A.EMPTY_BOOK;
    }
  }

  String getHeading() {
    switch (type) {
      case EmptyListType.List:
        return S.NOT_FOUND;
        break;
      case EmptyListType.Chat:
        return S.START_CHAT;
        break;
      default:
        return S.NOT_FOUND;
    }
  }

  String getMessage() {
    switch (type) {
      case EmptyListType.List:
        return S.NOT_FOUND_MSG;
        break;
      case EmptyListType.Chat:
        return S.START_CHAT_MSG;
        break;
      default:
        return S.NOT_FOUND_MSG;
    }
  }
}

enum EmptyListType { List, Chat }
