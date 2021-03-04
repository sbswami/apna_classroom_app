import 'dart:convert';

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
      // handleOnLaunchNotification(context, message, updateScreen);
    },
    onResume: (Map<String, dynamic> message) async {
      // handleOnResumeNotification(context, message, updateScreen);
      print("onResume: $message");
    },
  );
}

handleOpenAppNotification(Map message) {
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
      }
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
  }
}
