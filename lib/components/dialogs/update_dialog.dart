import 'dart:convert';

import 'package:apna_classroom_app/api/remote_config/remote_config_constants.dart';
import 'package:apna_classroom_app/api/remote_config/remote_config_defaults.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  final bool mustUpdate;

  const UpdateDialog({Key key, this.mustUpdate}) : super(key: key);

  _skipThisVersion() {
    setSkipVersion(remoteConfig[RCC.LATEST_VERSION_CODE].asInt());
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: SelectableText(
        S.NEW_UPDATE.tr,
        style: Theme.of(context).textTheme.headline6,
      ),
      content: SelectableText(
        jsonDecode(
              remoteConfig[RCC.WHATS_NEW].asString(),
            )[Get.locale.languageCode] ??
            '',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: <Widget>[
        if (!mustUpdate)
          SecondaryButton(
            text: S.SKIP_THIS_VERSION.tr,
            onPress: _skipThisVersion,
          ),
        PrimaryButton(
          text: S.UPDATE.tr,
          onPress: openStore,
        ),
      ],
    );
  }
}

showUpdateDialog({bool mustUpdate = false}) {
  return showDialog(
    context: Get.context,
    barrierDismissible: !mustUpdate,
    builder: (BuildContext context) => UpdateDialog(mustUpdate: mustUpdate),
  );
}

openStore({bool popApp = true}) async {
  String url;
  if (GetPlatform.isAndroid) {
    url = Constants.PLAY_STORE_LINK;
  } else if (GetPlatform.isIOS) {
    url = Constants.APP_STORE_LINK;
  } else {
    return Get.back();
  }
  if (await canLaunch(url)) {
    await launch(url);
    if (popApp) {
      return SystemNavigator.pop(); // This only works for Android
    }
    return;
  }
  Get.back();
}
