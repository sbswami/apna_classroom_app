import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YesNoDialog extends StatelessWidget {
  final String title;
  final String msg;
  final String yesName;
  final Function yes;
  final String noName;
  final Function no;

  const YesNoDialog(
      {Key key,
      this.title,
      this.msg,
      this.yes,
      this.no,
      this.yesName,
      this.noName})
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
        if (noName != null)
          SecondaryButton(
            text: noName,
            onPress: () => Get.back(result: (no ?? () {})()),
          ),
        PrimaryButton(
          text: yesName ?? S.OKAY,
          onPress: () {
            Get.back(result: (yes ?? () {})());
          },
        ),
      ],
    );
  }
}

yesOrNo(
    {String title,
    String msg,
    String yesName,
    Function yes,
    String noName,
    Function no,
    bool isDismissible = true}) {
  return showDialog(
    context: Get.context,
    barrierDismissible: isDismissible,
    builder: (BuildContext context) => YesNoDialog(
      title: title,
      msg: msg,
      yes: yes,
      yesName: yesName,
      no: no,
      noName: noName,
    ),
  );
}
