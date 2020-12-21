import 'package:apna_classroom_app/auth/auth.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/login/widgets/otp_input.dart';
import 'package:apna_classroom_app/screens/splash/initializer.dart';
import 'package:apna_classroom_app/util/assets.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final formData = {};

  void login() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      String phone = formData[C.PHONE_CODE] + formData[C.PHONE_NUMBER];
      if (phone.length == 10) {
        phone = Hint.COUNTRY_CODE + phone;
      }
      sendOtp(phone, onCodeSent: () {
        setState(() {
          isCodeSent = true;
        });
      });
    }
  }

  void submitOtp() async {
    showProgress();
    UserCredential userCredential = await signInWithPhoneNumber(otp.join(''));
    if (userCredential != null) {
      await handleAuthResult(userCredential);
      Get.offAll(getScreenForUser(await checkUser()));
    }
    Get.back();
  }

  // States
  bool isCodeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.LOGIN.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Image.asset(A.APP_ICON),
            ),
            Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 11.0),
                      child: TextFormField(
                        decoration:
                            InputDecoration(hintText: Hint.COUNTRY_CODE),
                        onSaved: (value) => formData[C.PHONE_CODE] = value,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: S.PHONE_NUMBER_LABEL.tr,
                            hintText: Hint.PHONE_NUMBER),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter(new RegExp('[0-9]'),
                              allow: true)
                        ],
                        onSaved: (value) => formData[C.PHONE_NUMBER] = value,
                        keyboardType: TextInputType.phone,
                        validator: phoneValidate,
                      ),
                    ),
                  )
                ],
              ),
            ),
            getOtpUi(),
            SizedBox(height: 32),
            PrimaryButton(
              onPress: isCodeSent ? submitOtp : login,
              text: S.CONTINUE.tr,
            )
          ],
        ),
      ),
    );
  }

  final otp = ['0', '0', '0', '0', '0', '0'];
  Widget getOtpUi() {
    if (isCodeSent) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(S.RESEND_OTP.tr),
                  style: ButtonStyle(),
                )
              ],
            ),
            OtpInput(otp: otp),
          ],
        ),
      );
    }
    return SizedBox();
  }
}
