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
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularProgressIndicator(),
              if (text != null) Text(text),
            ],
          ),
        ),
      ),
    );
  }
}

showProgress({String text}) {
  showDialog(
    context: Get.context,
    barrierDismissible: true,
    builder: (BuildContext context) => ProgressDialog(
      text: text,
    ),
  );
}
