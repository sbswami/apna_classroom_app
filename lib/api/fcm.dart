import 'package:apna_classroom_app/screens/chat/controllers/chat_messages_controller.dart';
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
  print(0);
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print(1);
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

handleOpenAppNotification(message) {
  switch (message[C.ACTION]) {
    case E.MESSAGE:
      switch (Get.currentRoute) {
        case '/Chat':
          if (message[C.CLASSROOM].toString() ==
              ChatMessagesController.to.classroomId.toString()) {
            print(message);
            ChatMessagesController.to.insertMessages([message]);
            // Add message to
            return;
          }
          // POP notification
          break;
      }
      break;
  }
}
