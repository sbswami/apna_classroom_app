import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterOptionBar extends StatelessWidget {
  final Function addOptionImage;
  final TextEditingController optionTextController;
  final Function addTextOption;
  final FocusNode focusNode;

  const EnterOptionBar(
      {Key key,
      this.addOptionImage,
      this.optionTextController,
      this.addTextOption,
      this.focusNode})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.image),
          onPressed: addOptionImage,
          color: Theme.of(context).primaryColor,
        ),
        Flexible(
          child: TextField(
            controller: optionTextController,
            decoration: InputDecoration(
              labelText: S.ENTER_OPTION.tr,
            ),
            focusNode: focusNode,
          ),
        ),
        SizedBox(width: 12.0),
        SecondaryButton(text: S.PLUS_ADD.tr, onPress: addTextOption),
      ],
    );
  }
}
