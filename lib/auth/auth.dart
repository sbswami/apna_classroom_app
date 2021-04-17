import 'package:apna_classroom_app/api/fcm.dart';
import 'package:apna_classroom_app/api/user.dart';
import 'package:apna_classroom_app/api/user_details.dart';
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
import 'package:get/get.dart';

Future<int> checkUser() async {
  int userLevel = 0;
  // await Future.delayed(Duration(seconds: 2));
  if (FirebaseAuth.instance.currentUser != null) {
    bool isUser = await getUser();
    if (isUser ?? false) userLevel++;
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

ConfirmationResult confirmationResult;

sendOtp(String phoneNumber, {Function onCodeSent}) async {
  showProgress();
  if (GetPlatform.isWeb) {
    ConfirmationResult _result =
        await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
    confirmationResult = _result;
    onCodeSent();
    Get.back();
    return confirmationResult;
  }

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
  UserCredential userCredential;
  if (GetPlatform.isWeb) {
    userCredential = await confirmationResult.confirm(smsCode);
  } else {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    userCredential = await auth.signInWithCredential(credential);
  }

  final User user = userCredential.user;
  final User currentUser = auth.currentUser;
  assert(user.uid == currentUser.uid);
  return userCredential;
}

handleAuthResult(UserCredential authResult) async {
  if (authResult.user != null) {
    await createUser({
      C.PHONE: authResult.user.phoneNumber,
      C.UID: authResult.user.uid,
      C.DEVICE_ID: await getDeviceID(),
    });
    await postLoginLoadData();
    return;
  }
  ok(title: S.LOGIN_FAILED, msg: S.SOMETHING_WENT_WRONG);
}

postLoginLoadData() async {
  // Save User Details
  await createUserDetails({
    C.ID: getUserId(),
    C.FCM_TOKEN: await getToken(),
  });

  // Fetch all subjects and exams
  List subjects = await getSubjectsUser();
  List exams = await getExamsUser();
  await RecentlyUsedController.to.addAllSubject(subjects.cast<String>());
  await RecentlyUsedController.to.addAllExam(exams.cast<String>());
}

signOut() async {
  await FirebaseAuth.instance.signOut();
  await clearAllLocalStorage();
  await Get.offAll(Login());
  UserController.to.updateUser({});
}
