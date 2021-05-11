import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/auth/auth.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/about/about.dart';
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
  final FocusNode phoneInput = FocusNode();
  final formData = {};

  void login({bool resend = false}) {
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
        track(EventName.SEND_OTP, {EventProp.RESEND: resend});
      });
      phoneInput.unfocus();
    }
  }

  void submitOtp() async {
    String otpStr = otp.join('');
    if (otpStr.length != 6 || otpStr == '000000') {
      return ok(title: S.WRONG_OTP.tr, msg: S.OTP_MESSAGE.tr);
    }
    showProgress();
    UserCredential userCredential = await signInWithPhoneNumber(otp.join(''));
    // Tack Event
    track(EventName.SUBMIT_OTP, {EventProp.CORRECT: userCredential != null});

    if (userCredential == null) {
      Get.back();
      ok(title: S.WRONG_OTP.tr, msg: S.OTP_MESSAGE.tr);

      setState(() {
        otp = ['0', '0', '0', '0', '0', '0'];
      });
      return;
    }

    await handleAuthResult(userCredential);
    Get.offAll(getScreenForUser(await checkUser()));
  }

  // States
  bool isCodeSent = false;

  // Open About page
  _openAbout() {
    Get.to(() => AboutScreen());
  }

  @override
  void initState() {
    super.initState();
    track(EventName.VIEWED_LOGIN, {});
    trackScreen(ScreenNames.Login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.LOGIN.tr),
        actions: [
          IconButton(
              icon: Icon(Icons.info_outline_rounded), onPressed: _openAbout)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child:
                  Container(child: Image.asset(A.APP_ICON_ALONE), height: 350),
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextFormField(
                        decoration:
                            InputDecoration(hintText: Hint.COUNTRY_CODE),
                        onSaved: (value) => formData[C.PHONE_CODE] = value,
                        keyboardType: TextInputType.phone,
                        maxLength: 4,
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
                        maxLength: 10,
                        focusNode: phoneInput,
                        onSaved: (value) => formData[C.PHONE_NUMBER] = value,
                        keyboardType: TextInputType.number,
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

  List otp = ['0', '0', '0', '0', '0', '0'];
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
                  onPressed: () => login(resend: true),
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
