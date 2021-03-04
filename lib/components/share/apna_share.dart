import 'package:apna_classroom_app/api/message.dart';
import 'package:apna_classroom_app/components/buttons/flat_icon_text_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom/classroom_selector.dart';
import 'package:apna_classroom_app/screens/classroom/controllers/classroom_list_controller.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApnaShare extends StatelessWidget {
  const ApnaShare({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatIconTextButton(
                iconData: Icons.share_rounded,
                text: S.SHARE_TO_CLASSROOM.tr,
                onPressed: () => Get.back(result: ShareScope.INTERNAL),
              ),
              FlatIconTextButton(
                iconData: Icons.share_rounded,
                text: S.SHARE_OUTSIDE.tr,
                onPressed: () => Get.back(result: ShareScope.EXTERNAL),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

apnaShare(SharingContentType contentType, Map sharingContent) async {
  var result = await showModalBottomSheet(
    context: Get.context,
    builder: (BuildContext context) {
      return ApnaShare();
    },
  );
  if (result == null) return;

  switch (result) {
    case ShareScope.INTERNAL:
      _internalShare(contentType, sharingContent);
      break;
    case ShareScope.EXTERNAL:
  }
}

_internalShare(SharingContentType contentType, Map sharingContent) {
  Get.to(
    ClassroomSelector(
      onSelect: (List selectedClassrooms) async {
        if (selectedClassrooms.isEmpty) return;
        // Classroom List
        switch (contentType) {
          case SharingContentType.NOTE:
            selectedClassrooms.forEach((classroom) async {
              // Message Object
              var messageObj = {
                C.TYPE: E.NOTE,
                C.NOTE: sharingContent[C.ID],
                C.CLASSROOM: classroom[C.ID],
              };

              var message = await createMessage(messageObj);

              // if message sent
              if (message != null) {
                ClassroomListController.to.addMessage(classroom[C.ID], message);
              }
              // message failed to sent
              else {
                // TODO: handle failed message
              }
            });
            break;
          case SharingContentType.EXAM:
            // TODO: Handle this case.
            break;
          case SharingContentType.QUESTION:
            // TODO: Handle this case.
            break;
        }
      },
      selectedClassroom: [],
    ),
  );
}

_externalShare(SharingContentType contentType, Map sharingContent) {}

enum SharingContentType {
  NOTE,
  EXAM,
  QUESTION,
}

enum ShareScope { INTERNAL, EXTERNAL }
