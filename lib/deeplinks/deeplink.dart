import 'package:apna_classroom_app/api/exam.dart';
import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom/classroom_details.dart';
import 'package:apna_classroom_app/screens/notes/detailed_note.dart';
import 'package:apna_classroom_app/screens/quiz/exam/detailed_exam.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

const String FIREBASE_PREFIX_URL = 'https://apnaclassroomapp.page.link';
const String WEBSITE_LINK = 'apna.srewa.com';

const String ANDROID_PACKAGE = 'com.srewa.apna_classroom_app';

Future<Uri> getDeepLink(String screen,
    {Map<String, String> payload, String title, String description}) async {
  showProgress();
  if (title == null) title = S.APP_NAME.tr;

  Uri link = Uri.http(WEBSITE_LINK, screen, payload);

  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: FIREBASE_PREFIX_URL,
    link: link,
    androidParameters: AndroidParameters(
      packageName: ANDROID_PACKAGE,
      minimumVersion: 1,
    ),
    // iosParameters: IosParameters(
    //   bundleId: 'com.srewa.apnaClassroomApp',
    //   minimumVersion: '1.0.0',
    //   appStoreId: '123456789',
    // ),
    // googleAnalyticsParameters: GoogleAnalyticsParameters(
    //   campaign: 'example-promo',
    //   medium: 'social',
    //   source: 'orkut',
    // ),
    // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
    //   providerToken: '123456',
    //   campaignToken: 'example-promo',
    // ),

    socialMetaTagParameters: SocialMetaTagParameters(
      title: title,
      description: description,
    ),
  );
  final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
  final Uri shortUrl = shortDynamicLink.shortUrl;
  Get.back();
  return shortUrl;
}

handleDeepLink(Uri link) async {
  String path = link.path;
  var parameters = link.queryParameters;
  var allParameters = link.queryParametersAll;

  switch (path) {
    // Classroom
    case Path.CLASSROOM_TAB:
      break;
    case Path.CLASSROOM_DETAILS:
      Get.to(
        () => ClassroomDetails(
          classroom: {C.ID: parameters[C.ID]},
        ),
      );
      break;

    // Exam
    case Path.EXAM_TAB:
      break;
    case Path.EXAM_DETAILS:
      await addToAccessListExam({C.ID: parameters[C.ID]});
      Get.to(
        () => DetailedExam(
          exam: {C.ID: parameters[C.ID]},
        ),
      );
      break;

    // Question
    case Path.QUESTION_TAB:
      break;
    case Path.QUESTION_DETAILS:
      break;

    // Note
    case Path.NOTE_TAB:
      break;
    case Path.NOTE_DETAILS:
      await addToAccessListNote({C.ID: parameters[C.ID]});
      Get.to(
        () => DetailedNote(
          note: {C.ID: parameters[C.ID]},
        ),
      );
      break;
  }
}

class Path {
  // Classroom
  static const String CLASSROOM_TAB = '/Classroom';
  static const String CLASSROOM_DETAILS = '/ClassroomDetails';

  // Exam
  static const String EXAM_TAB = '/Exam';
  static const String EXAM_DETAILS = '/ExamDetails';

  // Question
  static const String QUESTION_TAB = '/Question';
  static const String QUESTION_DETAILS = '/QuestionDetails';

  // Note
  static const String NOTE_TAB = '/Note';
  static const String NOTE_DETAILS = '/NoteDetails';
}
