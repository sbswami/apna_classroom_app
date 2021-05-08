import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/secrete/secrete_screen.dart';
import 'package:apna_classroom_app/util/assets.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatelessWidget {
  _openSecreteScreen() {
    if (!isLoggedIn()) {
      Get.to(() => SecreteScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.ABOUT.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                S.APP_NAME.tr,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 32),
              Text(
                S.APP_DESCRIPTION.tr,
                style: TextStyle(height: 1.6),
              ),
              SizedBox(height: 32),
              GestureDetector(
                onDoubleTap: _openSecreteScreen,
                child: SizedBox(
                  height: 84,
                  width: 84,
                  child: Image.asset(A.APP_ICON),
                ),
              ),
              SizedBox(height: 8),
              Text(S.APP_VERSION.tr),
              SizedBox(height: 8),
              Text('${Constants.VERSION_NAME} (${Constants.APP_VERSION})'),
            ],
          ),
        ),
      ),
    );
  }
}
