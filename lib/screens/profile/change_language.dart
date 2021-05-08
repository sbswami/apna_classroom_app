import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/radio/radio_group.dart';
import 'package:apna_classroom_app/internationalization/my_translation.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  String selectedLang;

  _onChangeLang(String value) {
    setState(() {
      selectedLang = value;
    });
  }

  _updateLang() {
    // Track Language change Event
    track(EventName.CHANGE_LANGUAGE, {
      EventProp.NEW_LANGUAGE: selectedLang,
      EventProp.OLD_LANGUAGE: Get.locale.toString()
    });

    Get.updateLocale(getLocal(selectedLang));
    setLocale(localeString: selectedLang);
  }

  @override
  void initState() {
    // selectedLang = from local storage
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> list = {
      en_US: S.ENGLISH_USA.tr,
      en_IN: S.ENGLISH_IN.tr,
      hi_IN: S.HINDI_IN.tr,
    };

    Locale locale = Get.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.CHANGE_LANGUAGE.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            RadioGroup(
              list: list,
              isVertical: true,
              defaultValue: '${locale.languageCode}_${locale.countryCode}',
              onChange: _onChangeLang,
            ),
            SizedBox(height: 32.0),
            PrimaryButton(
              text: S.SAVE.tr,
              onPress: _updateLang,
            )
          ],
        ),
      ),
    );
  }
}
