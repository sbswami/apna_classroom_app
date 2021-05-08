import 'package:apna_classroom_app/app.dart';
import 'package:apna_classroom_app/internationalization/my_translation.dart';
import 'package:apna_classroom_app/notifications/notifications_helper.dart';
import 'package:apna_classroom_app/theme/styles.dart';
import 'package:apna_classroom_app/util/local_storage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale locale = getLocal(await getLocale());
  bool _isDarkMode = await isDarkMode();
  await Firebase.initializeApp();

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelKey: CQN_NOTIFY_CHANNEL,
          channelName: 'CQN (Classroom Quiz Notes)',
          channelDescription: 'CQN Notification Channel',
          defaultColor: primaryColor,
          ledColor: Colors.white,
        )
      ]);

  runApp(ApnaApp(locale: locale, isDarkMode: _isDarkMode));
}
