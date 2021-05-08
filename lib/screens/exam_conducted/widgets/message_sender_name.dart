import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/screens/profile/person_details.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageSenderName extends StatelessWidget {
  final creator;

  const MessageSenderName({Key key, this.creator}) : super(key: key);
  _onTapSender() async {
    await Get.to(() => PersonDetails(person: creator));

    // Track screen back
    trackScreen(ScreenNames.Chat);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _onTapSender,
          child: Container(
            padding: const EdgeInsets.only(
              bottom: 20,
              top: 4,
              left: 8,
              right: 8,
            ),
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              creator[C.NAME],
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Theme.of(context).cardColor,
                  ),
            ),
            alignment: Alignment.topLeft,
          ),
        ),
      ],
    );
  }
}
