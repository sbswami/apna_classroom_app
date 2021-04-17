import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleInputDialog extends StatefulWidget {
  final String title;
  final String labelText;
  final int maxChar;

  const SingleInputDialog({
    Key key,
    @required this.title,
    @required this.labelText,
    this.maxChar,
  }) : super(key: key);

  @override
  _SingleInputDialogState createState() => _SingleInputDialogState();
}

class _SingleInputDialogState extends State<SingleInputDialog> {
  final TextEditingController editingController = TextEditingController();

  String error;

  _okay() {
    if (editingController.text.trim().isEmpty) {
      return setState(() {
        error = S.THIS_FIELD_IS_REQUIRED.tr;
      });
    }
    Get.back(result: editingController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: SelectableText(
        widget.title,
        style: Theme.of(context).textTheme.headline6,
      ),
      content: TextField(
        decoration: InputDecoration(
          labelText: widget.labelText,
        ),
        maxLength: widget.maxChar ?? 300,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: editingController,
      ),
      actions: <Widget>[
        SecondaryButton(
          text: S.CANCEL.tr,
          onPress: () => Get.back(),
        ),
        PrimaryButton(
          text: S.OKAY,
          onPress: _okay,
        ),
      ],
    );
  }
}

showSingleInputDialog({String title, String labelText, int maxChar}) {
  return showDialog(
    context: Get.context,
    builder: (BuildContext context) {
      return SingleInputDialog(
        title: title,
        labelText: labelText,
        maxChar: maxChar,
      );
    },
  );
}
