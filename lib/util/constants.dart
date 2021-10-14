import 'package:get/get.dart';

class Constants {
  static const String INVITE_DEEP_LINK = '';
  static const String PLAY_STORE_LINK =
      'https://play.google.com/store/apps/details?id=com.srewa.classroom_quiz_notes';
  static const String APP_STORE_LINK = 'https://www.apple.com/app-store/';
  static const int APP_VERSION = 9;
  static const String VERSION_NAME = '0.0.9';

  // Social Media
  static const String FACEBOOK_LINK =
      'https://www.facebook.com/ClassroomQuizNotes';
  static const String INSTAGRAM_LINK =
      'https://www.instagram.com/cqn_official/';
  static const String TWITTER_LINK = 'https://twitter.com/CQN_Official';
  static const String YOUTUBE_LINK =
      'https://www.youtube.com/channel/UCyN_lwpc3ymhWwCGaB47uZA/';
}

getAppLink() {
  if (GetPlatform.isAndroid) {
    return Constants.PLAY_STORE_LINK;
  } else if (GetPlatform.isIOS) {
    return Constants.APP_STORE_LINK;
  }
}

class Hint {
  // Hints
  static const String COUNTRY_CODE = '+91';
  static const String PHONE_NUMBER = '1234 567 890';
}

class E {
  // Privacy
  static const String PUBLIC = 'PUBLIC';
  static const String PRIVATE = 'PRIVATE';

  // Media Type
  static const String PDF = 'PDF';
  static const String IMAGE = 'IMAGE';
  static const String VIDEO = 'VIDEO';
  static const String TEXT = 'TEXT';

  // Question Type
  static const String MULTI_CHOICE = 'MULTI_CHOICE';
  static const String SINGLE_CHOICE = 'SINGLE_CHOICE';
  static const String DIRECT_ANSWER = 'DIRECT_ANSWER';

  // Difficulty
  static const String EASY = 'EASY';
  static const String NORMAL = 'NORMAL';
  static const String HARD = 'HARD';

  // Role
  static const String ADMIN = 'ADMIN';
  static const String MEMBER = 'MEMBER';

  // Permission
  static const String ALL = 'ALL';
  static const String ADMIN_ONLY = 'ADMIN_ONLY';

  // Join Permission
  static const String ANYONE = 'ANYONE';
  static const String REQUEST_BEFORE_JOIN = 'REQUEST_BEFORE_JOIN';

  // Message Type
  static const String MESSAGE = 'MESSAGE';
  static const String EXAM_CONDUCTED = 'EXAM_CONDUCTED';
  static const String NOTE = 'NOTE';
  static const String MEDIA = 'MEDIA';
  static const String CLASSROOM = 'CLASSROOM';
  static const String MESSAGE_DELETED = 'MESSAGE_DELETED';
  static const String LOGGED_OUT = 'LOGGED_OUT';

  // Report
  static const String OPEN = 'OPEN';
  static const String CLOSED = 'CLOSED';
}
