import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom/widgets/person_card.dart';
import 'package:apna_classroom_app/screens/profile/person_details.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinRequestCard extends StatelessWidget {
  final joinRequest;
  final Function onDelete;
  final Function onAccept;

  const JoinRequestCard(
      {Key key, this.joinRequest, this.onDelete, this.onAccept})
      : super(key: key);

  // Open person profile
  _openProfile() async {
    await Get.to(PersonDetails(
      person: joinRequest[C.USER],
    ));

    // Track screen back
    trackScreen(ScreenNames.JoinRequests);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        PersonCard(
          person: joinRequest[C.USER],
          onTap: _openProfile,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SecondaryButton(
              text: S.DELETE.tr,
              onPress: onDelete,
            ),
            PrimaryButton(
              text: S.ACCEPT.tr,
              onPress: onAccept,
            ),
          ],
        ),
        SizedBox(height: 8),
        Divider(),
      ],
    );
  }
}
