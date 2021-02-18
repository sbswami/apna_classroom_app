import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String msg;
  final String buttonName;
  final Function ok;

  const InfoDialog({Key key, this.title, this.msg, this.buttonName, this.ok})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: SelectableText(
        title ?? '',
        style: Theme.of(context).textTheme.headline6,
      ),
      content: SelectableText(
        msg ?? '',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: <Widget>[
        PrimaryButton(
          text: buttonName ?? S.OKAY,
          onPress: ok ?? () => Get.back(),
        )
      ],
    );
  }
}

ok(
    {String title,
    String msg,
    String buttonName,
    Function ok,
    bool isDismissible = true}) {
  return showDialog(
    context: Get.context,
    barrierDismissible: isDismissible,
    builder: (BuildContext context) => InfoDialog(
      title: title,
      msg: msg,
      ok: ok,
      buttonName: buttonName,
    ),
  );
}
