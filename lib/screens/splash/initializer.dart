import 'package:apna_classroom_app/api/api_constants.dart';
import 'package:apna_classroom_app/api/fcm.dart';
import 'package:apna_classroom_app/api/remote_config/remote_config.dart';
import 'package:apna_classroom_app/api/remote_config/remote_config_constants.dart';
import 'package:apna_classroom_app/api/remote_config/remote_config_defaults.dart';
import 'package:apna_classroom_app/auth/auth.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/update_dialog.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/chat/controllers/chat_messages_controller.dart';
import 'package:apna_classroom_app/screens/classroom/controllers/classroom_list_controller.dart';
import 'package:apna_classroom_app/screens/home/controllers/home_tab_controller.dart';
import 'package:apna_classroom_app/screens/home/home.dart';
import 'package:apna_classroom_app/screens/login/login.dart';
import 'package:apna_classroom_app/screens/profile/profile.dart';
import 'package:apna_classroom_app/screens/quiz/quiz_tab_controller.dart';
import 'package:apna_classroom_app/screens/splash/splash.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Initializer extends StatefulWidget {
  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  int userLevel = 0;
  bool loading = true;

  @override
  void initState() {
    Get.put(UserController());
    Get.put(RecentlyUsedController());
    Get.put(QuizTabController());
    Get.put(HomeTabController());
    Get.put(ChatMessagesController());
    Get.put(ClassroomListController());
    super.initState();
    configureFirebase();
    _checkUser();
  }

  _checkUser() async {
    await _setEnv();
    await initRemoteConfig();
    _checkForUpdate();
    _checkMaintenance();
    int _useLevel = await checkUser();

    setState(() {
      userLevel = _useLevel;
      loading = false;
    });
  }

  _checkForUpdate() async {
    // Check for minimum version
    if (remoteConfig[RCC.MINIMUM_VERSION_CODE].asInt() >
        Constants.APP_VERSION) {
      await showUpdateDialog(mustUpdate: true);
    }
    // Latest version is greater then current version
    // And Latest version is not skipped
    else if (remoteConfig[RCC.LATEST_VERSION_CODE].asInt() >
            Constants.APP_VERSION &&
        (await getSkipVersion()) !=
            remoteConfig[RCC.LATEST_VERSION_CODE].asInt()) {
      await showUpdateDialog();
    }
  }

  // Check for Maintenance
  _checkMaintenance() {
    if (remoteConfig[RCC.MAINTENANCE].asBool()) {
      ok(
        title: S.UNDER_MAINTENANCE.tr,
        msg: S.UNDER_MAINTENANCE_MSG.tr,
        isDismissible: false,
        noButton: true,
      );
    }
  }

  // Set Env
  _setEnv() async {
    String env = await getEnv();
    if (env == null) return;

    switch (env) {
      case 'DEV':
        apiRootGet = API_ROOT_GET_DEV;
        apiRoot = 'http://$apiRootGet';
        break;
      case 'PROD':
        apiRootGet = API_ROOT_GET_PROD;
        apiRoot = 'http://$apiRootGet';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Splash();
    return getScreenForUser(userLevel);
  }
}

Widget getScreenForUser(int key) {
  switch (key) {
    case 0:
      return Login();
    case 1:
      return ProfileScreen();
    case 2:
      return Home();
    default:
      return Login();
  }
}
