import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/auth/auth.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/dialogs/update_dialog.dart';
import 'package:apna_classroom_app/components/images/person_image.dart';
import 'package:apna_classroom_app/components/menu/apna_menu.dart';
import 'package:apna_classroom_app/components/menu/menu_item.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/about/about.dart';
import 'package:apna_classroom_app/screens/profile/change_language.dart';
import 'package:apna_classroom_app/screens/profile/profile_details.dart';
import 'package:apna_classroom_app/theme/app_theme.dart';
import 'package:apna_classroom_app/util/assets.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/helper.dart';
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

    // Track Change theme
    track(EventName.CHANGE_THEME, {EventProp.IS_DARK: Get.isDarkMode});
  }

  // Open Profile
  _openProfile() {
    Get.to(ProfileDetails());
  }

  // Sign out
  _signOut() {
    // Track Logout event
    track(EventName.LOGOUT, {});
    signOut();
  }

  // Invite
  _invite() async {
    await Share.share(
      S.SHARING_NOTE.trParams({'link': getAppLink()}),
      subject: S.APP_NAME.tr,
    );

    // Track Invite
    track(EventName.INVITE, {});
  }

  _openSocialMedia(String link) {
    openUrl(link);

    // Track Social media clicks
    track(EventName.NEED_HELP, {EventProp.SOCIAL_MEDIA: link});
  }

  // Need Help
  _needHelp() async {
    List<MenuItem> items = [
      MenuItem(
        text: S.TWITTER.tr,
        asset: A.TWITTER,
        onTap: () => _openSocialMedia(Constants.TWITTER_LINK),
      ),
      MenuItem(
        text: S.INSTAGRAM.tr,
        asset: A.INSTAGRAM,
        onTap: () => _openSocialMedia(Constants.INSTAGRAM_LINK),
      ),
      MenuItem(
        text: S.FACEBOOK.tr,
        asset: A.FACEBOOK,
        onTap: () => _openSocialMedia(Constants.FACEBOOK_LINK),
      ),
      MenuItem(
        text: S.YOUTUBE.tr,
        asset: A.YOUTUBE,
        onTap: () => _openSocialMedia(Constants.YOUTUBE_LINK),
      ),
    ];
    await showApnaMenu(Get.context, items, type: MenuType.BottomSheet);
  }

  // Rate us
  _rateUs() {
    openStore(popApp: false);

    // Track Rate us click
    track(EventName.RATE_US, {});
  }

  // About
  _about() async {
    await Get.to(() => AboutScreen());

    // Track About clicks
    track(EventName.ABOUT, {});
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
                      url: (user[C.MEDIA] ?? {})[C.URL],
                      size: 70,
                      stopPreview: true,
                    ),
                    SizedBox(width: 16.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user[C.NAME] ?? '',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            user[C.USERNAME] ?? '',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
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
                Divider(),
                MenuItem(
                  text: Get.isDarkMode ? S.LIGHT_MODE.tr : S.DARK_MODE.tr,
                  iconData: Get.isDarkMode
                      ? Icons.brightness_7_rounded
                      : Icons.brightness_2_rounded,
                  onTap: switchTheme,
                ),
                Divider(),
                MenuItem(
                  text: S.INVITE.tr,
                  onTap: _invite,
                  iconData: Icons.group_add_rounded,
                ),
                Divider(),
                MenuItem(
                  text: S.NEED_HELP.tr,
                  onTap: _needHelp,
                  iconData: Icons.help,
                ),
                Divider(),
                MenuItem(
                  text: S.RATE_US.tr,
                  onTap: _rateUs,
                  iconData: Icons.star_border_rounded,
                ),
                Divider(),
                MenuItem(
                  text: S.ABOUT.tr,
                  onTap: _about,
                  iconData: Icons.info,
                ),
                Divider(),
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
