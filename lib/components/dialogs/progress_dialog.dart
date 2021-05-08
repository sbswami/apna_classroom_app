import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressDialog extends StatelessWidget {
  final String text;

  const ProgressDialog({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 32.0),
            Text(text ?? S.PROCESSING.tr),
          ],
        ),
      ),
    );
  }
}

showProgress({String text}) {
  return showDialog(
    context: Get.context,
    barrierDismissible: false,
    builder: (BuildContext context) => ProgressDialog(
      text: text,
    ),
  );
}
