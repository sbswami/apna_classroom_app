import 'dart:convert';

import 'package:apna_classroom_app/auth/auth.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/chat/controllers/chat_messages_controller.dart';
import 'package:apna_classroom_app/screens/classroom/controllers/classroom_list_controller.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

getToken() async {
  String token = await _firebaseMessaging.getToken();
  print('Firebase Token: ' + token);
  return token;
}

configureFirebase() {
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      handleOpenAppNotification(message);
//        _showItemDialog(message);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      handleOpenAppNotification(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      handleOpenAppNotification(message);
    },
  );
}

handleOpenAppNotification(Map message) async {
  bool setUnseen = true;
  if (message[C.DATA] != null) {
    message = {...message, ...message[C.DATA]};
    message.remove(C.DATA);
  }
  switch (message[C.ACTION]) {
    case E.MESSAGE:
      switch (message[C.TYPE]) {
        case E.MEDIA:
          message[C.MEDIA] = jsonDecode(message[C.MEDIA]);
          break;
        case E.EXAM_CONDUCTED:
          message[C.EXAM_CONDUCTED] = jsonDecode(message[C.EXAM_CONDUCTED]);
          break;
        case E.NOTE:
          message[C.NOTE] = jsonDecode(message[C.NOTE]);
          break;
        case E.CLASSROOM:
          message[C.CLASSROOM_ID] = jsonDecode(message[C.CLASSROOM_ID]);
          break;
      }
      message[C.CREATED_BY] = jsonDecode(message[C.CREATED_BY]);
      switch (Get.currentRoute) {
        case '/Chat':
          if (message[C.CLASSROOM].toString() ==
              ChatMessagesController.to.classroomId.toString()) {
            ChatMessagesController.to.insertMessages([message]);
            setUnseen = false;
            // Add message to
            break;
          }
          // POP notification
          break;
      }
      ClassroomListController.to
          .addMessage(message[C.CLASSROOM], message, setUnseen: setUnseen);
      break;

    case E.MESSAGE_DELETED:
      switch (Get.currentRoute) {
        case '/Chat':
          if (message[C.CLASSROOM].toString() ==
              ChatMessagesController.to.classroomId.toString()) {
            ChatMessagesController.to.deleteMessage(message[C.ID]);
            // Add message to
            break;
          }
          // POP notification - NO
          break;
      }
      break;
    case E.EXAM_CONDUCTED:
      switch (Get.currentRoute) {
        case '/RunningExam':
        case '/RunningExamQuestion':
        case '/SingleResult':
        case '/ClassroomDetails':
        case '/AllExamConducted':
        case '/Chat':
          await ok(
              isDismissible: false,
              title: S.THIS_EXAM_IS_DELETED.trParams({
                C.TITLE: message[C.TITLE],
              }),
              msg: S.EXAM_DELETED_NOTE.trParams({
                C.REASON: message[C.REASON],
                C.TITLE: message[C.TITLE],
              }));
          backToHome();
          break;

        default:
          ok(
            title: S.THIS_EXAM_IS_DELETED.trParams({C.TITLE: message[C.TITLE]}),
            msg: S.EXAM_DELETED_NOTE.trParams({
              C.REASON: message[C.REASON],
              C.TITLE: message[C.TITLE],
            }),
          );
      }

      break;
    case E.LOGGED_OUT:
      await ok(
          title: S.LOGGED_IN_WITH_NEW_DEVICE.tr,
          msg: S.LOGGED_OUT_FROM_THIS_DEVICE.tr,
          isDismissible: false);
      signOut();
      break;
  }
}

backToHome() {
  Get.back();
  Get.back();
  Get.back();
  Get.back();
  return;
}
