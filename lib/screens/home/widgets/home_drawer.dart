import 'package:apna_classroom_app/auth/auth.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/images/person_image.dart';
import 'package:apna_classroom_app/components/menu/menu_item.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/profile/change_language.dart';
import 'package:apna_classroom_app/screens/profile/profile_details.dart';
import 'package:apna_classroom_app/theme/app_theme.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

class HomeDrawer extends StatelessWidget {
  // Switch Theme
  switchTheme() {
    if (Get.isDarkMode) {
      Get.changeTheme(AppTheme.lightTheme);
      setDarkMode(false);
    } else {
      Get.changeTheme(AppTheme.darkTheme);
      setDarkMode(true);
    }
  }

  // Open Profile
  _openProfile() {
    Get.to(ProfileDetails());
  }

  // Sign out
  _signOut() {
    signOut();
  }

  // Invite
  _invite() {
    Share.share(
      S.SHARING_NOTE.trParams({
        'link': Constants.PLAY_STORE_LINK, // TODO: add deeplink for invite
      }),
      subject: S.APP_NAME.tr,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: "home_drawer",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            child: GestureDetector(
              onTap: _openProfile,
              child: Obx(() {
                var user = UserController.to.currentUser;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PersonImage(
                      thumbnailUrl: (user[C.MEDIA] ?? {})[C.THUMBNAIL_URL],
                      size: 70,
                    ),
                    SizedBox(width: 16.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user[C.NAME],
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          user[C.USERNAME],
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                );
              }),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 16.0),
            child: Column(
              children: [
                MenuItem(
                  text: S.CHANGE_LANGUAGE.tr,
                  onTap: () {
                    Get.to(ChangeLanguage());
                  },
                  iconData: Icons.public_rounded,
                ),
                SizedBox(height: 12.0),
                Divider(),
                SizedBox(height: 12.0),
                MenuItem(
                  text: Get.isDarkMode ? S.LIGHT_MODE.tr : S.DARK_MODE.tr,
                  iconData: Get.isDarkMode
                      ? Icons.brightness_7_rounded
                      : Icons.brightness_2_rounded,
                  onTap: switchTheme,
                ),
                SizedBox(height: 12.0),
                Divider(),
                SizedBox(height: 12.0),
                MenuItem(
                  text: S.INVITE.tr,
                  onTap: _invite,
                  iconData: Icons.group_add_rounded,
                ),
                SizedBox(height: 12.0),
                Divider(),
                SizedBox(height: 12.0),
                MenuItem(
                  text: S.LOG_OUT.tr,
                  onTap: _signOut,
                  iconData: Icons.logout,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
