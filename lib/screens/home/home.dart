import 'dart:async';

import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/components/share/apna_share.dart';
import 'package:apna_classroom_app/deeplinks/deeplink.dart';
import 'package:apna_classroom_app/screens/classroom/classroom.dart';
import 'package:apna_classroom_app/screens/notes/notes.dart';
import 'package:apna_classroom_app/screens/quiz/quiz.dart';
import 'package:apna_classroom_app/screens/quiz/quiz_provider.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController(initialPage: 0);

  StreamSubscription _mediaStream;
  StreamSubscription _textStream;

  @override
  void initState() {
    super.initState();

    // Dynamic links
    initDynamicLinks();

    /// Getting shared data form other apps
    handleContentProvider();

    // Check notification permission
    _notificationPermission();

    // Initial Screen Classroom Tab
    trackScreen(ScreenNames.ClassroomTab);

    // Track Viewed Home event
    track(
      EventName.VIEWED_HOME,
      {
        EventProp.THEME: Get.isDarkMode ? 'Dark' : 'Light',
        EventProp.LANGUAGE: Get.locale.languageCode,
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _mediaStream.cancel();
    _textStream.cancel();
  }

  handleContentProvider() async {
    // For sharing images coming from outside the app while the app is in the memory
    // Check for media when app is already running
    _mediaStream = ReceiveSharingIntent.getMediaStream().listen(
        (List<SharedMediaFile> mediaList) async {
      List mediaL = await shareMediaToMedia(mediaList);

      if (mediaL.length > 0) {
        internalShare(SharingContentType.Media, {C.MEDIA: mediaL});
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    /// Check for text when app was already running
    _textStream = ReceiveSharingIntent.getTextStream().listen((String text) {
      internalShare(SharingContentType.Text, {C.TEXT: text});
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    /// Check for text on app launch
    String text = await ReceiveSharingIntent.getInitialText();
    if (text != null) {
      return internalShare(SharingContentType.Text, {C.TEXT: text});
    }

    /// Check for media on app launch
    List<SharedMediaFile> mediaList =
        await ReceiveSharingIntent.getInitialMedia();
    List mediaL = await shareMediaToMedia(mediaList);
    if (mediaL.length > 0) {
      internalShare(SharingContentType.Media, {C.MEDIA: mediaL});
    }
  }

  void initDynamicLinks() async {
    /// Deep links
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        handleDeepLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      handleDeepLink(deepLink);
    }
  }

  // Notification permission
  _notificationPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => QuizProvider(),
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Classroom(pageController: _pageController),
            Quiz(pageController: _pageController),
            Notes(pageController: _pageController),
          ],
        ),
      ),
    );
  }
}
