import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YesNoDialog extends StatelessWidget {
  final String title;
  final String msg;
  final String yesName;
  final Function yes;
  final String noName;
  final Function no;
  final bool destructive;

  const YesNoDialog(
      {Key key,
      this.title,
      this.msg,
      this.yes,
      this.no,
      this.yesName,
      this.noName,
      this.destructive})
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
          text: yesName ?? S.OKAY.tr,
          onPress: () {
            Get.back(result: (yes ?? () {})());
          },
          destructive: destructive,
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

wantToDelete(Function onDelete, String msg) {
  return showDialog(
    context: Get.context,
    barrierDismissible: true,
    builder: (BuildContext context) => YesNoDialog(
      title: S.ARE_YOU_SURE_YOU_WANT_TO_DELETE.tr,
      msg: msg,
      yes: onDelete,
      yesName: S.DELETE.tr,
      noName: S.CANCEL.tr,
      destructive: true,
    ),
  );
}

wantToDiscard(Function onDiscard, String msg) {
  return showDialog(
    context: Get.context,
    barrierDismissible: true,
    builder: (BuildContext context) => YesNoDialog(
      title: S.ARE_YOU_SURE_YOU_WANT_TO_DISCARD.tr,
      msg: msg,
      yes: onDiscard,
      yesName: S.DISCARD.tr,
      noName: S.CANCEL.tr,
      destructive: true,
    ),
  );
}

wantToLeave({Function onLeave, String msg, String title}) {
  return showDialog(
    context: Get.context,
    barrierDismissible: true,
    builder: (BuildContext context) => YesNoDialog(
      title: S.ARE_YOU_SURE_YOU_WANT_TO_LEAVE.trParams({
        C.TITLE: title,
      }),
      msg: msg,
      yes: onLeave,
      yesName: S.LEAVE.tr,
      noName: S.CANCEL.tr,
      destructive: true,
    ),
  );
}

wantToEdit(Function onYes, String msg) {
  return showDialog(
    context: Get.context,
    barrierDismissible: true,
    builder: (BuildContext context) => YesNoDialog(
      title: S.ARE_YOU_SURE_YOU_WANT_TO_EDIT.tr,
      msg: msg,
      yes: onYes,
      yesName: S.EDIT.tr,
      noName: S.CANCEL.tr,
    ),
  );
}
