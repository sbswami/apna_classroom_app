import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/api/user.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/home/home.dart';
import 'package:apna_classroom_app/screens/login/login.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:apna_classroom_app/util/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

Future<int> checkUser() async {
  int userLevel = 0;
  await Firebase.initializeApp();
  // await Future.delayed(Duration(seconds: 2));
  if (FirebaseAuth.instance.currentUser != null) {
    userLevel++;
    await getUser();
    if (UserController.to.currentUser[C.USERNAME] != null) {
      userLevel++;
    }
  }
  return userLevel;
}

FirebaseAuth auth = FirebaseAuth.instance;
var verificationId;
verifyPhoneNumber(
  String phoneNumber,
  Function(UserCredential) onAutoCompleted,
  onFailed,
  onCodeSent,
  onTimeout,
) async {
  final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential phoneAuthCredential) async {
    UserCredential authResult =
        await auth.signInWithCredential(phoneAuthCredential);
    onAutoCompleted(authResult);
  };

  final PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
    onFailed(authException);
    print(
        'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
  };

  final PhoneCodeSent codeSent =
      (String newVerificationId, [int forceResendingToken]) async {
    verificationId = newVerificationId;

    onCodeSent();
    print('Please check your phone for the verification code. $verificationId');
  };

  final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String newVerificationId) {
    onTimeout();
    verificationId = newVerificationId;
  };
  await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
}

sendOtp(String phoneNumber, {Function onCodeSent}) async {
  showProgress();
  await verifyPhoneNumber(phoneNumber, (UserCredential authResult) async {
    await handleAuthResult(authResult);
    Get.back();
    Get.offAll(Home());
  }, (authException) async {
    Get.back();
    ok(msg: S.WRONG_PHONE_NUMBER_LIMIT_EXCEED.tr);
  }, () async {
    Get.back();
    onCodeSent();
    ok(title: S.CODE_SENT.tr);
  }, () async {
    Get.back();
  });
}

Future<UserCredential> signInWithPhoneNumber(String smsCode) async {
  final AuthCredential credential = PhoneAuthProvider.credential(
    verificationId: verificationId,
    smsCode: smsCode,
  );

  final UserCredential result = await auth.signInWithCredential(credential);
  final User user = result.user;
  final User currentUser = auth.currentUser;
  assert(user.uid == currentUser.uid);
  return result;
}

handleAuthResult(UserCredential authResult) async {
  if (authResult.user != null) {
    await createUser({
      C.PHONE: authResult.user.phoneNumber,
      C.UID: authResult.user.uid,
      C.DEVICE_ID: await getDeviceID(),
    });
    postLoginLoadData();
    return;
  }
  ok(title: S.LOGIN_FAILED, msg: S.SOMETHING_WENT_WRONG);
}

postLoginLoadData() async {
  List subjects = await getSubjectsNote();
  await RecentlyUsedController.to.addAllSubject(subjects);
}

signOut() async {
  UserController.to.updateUser({});
  await FirebaseAuth.instance.signOut();
  await clearAllLocalStorage();
  Get.offAll(Login());
}
