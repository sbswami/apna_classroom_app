import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/profile/profile_edit.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileDetails extends StatelessWidget {
  ProfileDetails() {
    _trackEvents();
  }

  _trackEvents() {
    trackScreen(ScreenNames.ProfileDetails);
    track(EventName.VIEWED_SELF_PROFILE, {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.PROFILE.tr)),
      body: Obx(() {
        var user = UserController.to.currentUser;
        return ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.75,
              child: UrlImage(
                url: (user[C.MEDIA] ?? {})[C.URL],
                fit: BoxFit.cover,
                borderRadius: 0.0,
                fileName: FileName.MAIN,
              ),
            ),
            SizedBox(height: 24),
            Container(
              alignment: Alignment.center,
              child: Text(
                user[C.NAME],
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  InfoCard(
                    title: S.PHONE_NUMBER.tr,
                    data: user[C.PHONE],
                  ),
                  InfoCard(
                    title: S.USERNAME.tr,
                    data: user[C.USERNAME],
                  ),
                  InfoCard(
                    title: S.HIDE_MY_PHONE_NUMBER.tr,
                    data: getBooleanSt(user[C.HIDE_MY_NUMBER]).tr,
                  ),
                ],
              ),
            )
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () async {
          await Get.to(ProfileEdit());
          _trackEvents();
        },
      ),
    );
  }
}
