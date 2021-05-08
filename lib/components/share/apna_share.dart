import 'dart:io';
import 'dart:typed_data';

import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/message.dart';
import 'package:apna_classroom_app/api/storage/storage.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/buttons/flat_icon_text_button.dart';
import 'package:apna_classroom_app/deeplinks/deeplink.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/chat/chat.dart';
import 'package:apna_classroom_app/screens/classroom/classroom_selector.dart';
import 'package:apna_classroom_app/screens/classroom/controllers/classroom_list_controller.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share/share.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
                iconData: Icons.phone_android_rounded,
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
      internalShare(contentType, sharingContent);
      break;
    case ShareScope.EXTERNAL:
      externalShare(contentType, sharingContent);
  }
}

internalShare(SharingContentType contentType, Map sharingContent) {
  Get.to(
    ClassroomSelector(
      onSelect: (List selectedClassrooms) async {
        if (selectedClassrooms.isEmpty) return;

        // Track Sharing event
        track(EventName.INTERNAL_SHARE, {
          EventProp.TYPE: contentType.toString(),
        });

        // Message Object
        Map<String, dynamic> messageObj = {};
        List<Map<String, dynamic>> messageList;

        switch (contentType) {
          case SharingContentType.Text:
            messageObj = {
              C.TYPE: E.MESSAGE,
              C.MESSAGE: sharingContent[C.TEXT],
            };
            break;
          case SharingContentType.Note:
            messageObj = {
              C.TYPE: E.NOTE,
              C.NOTE: sharingContent[C.ID],
            };
            break;
          case SharingContentType.Classroom:
            messageObj = {
              C.TYPE: E.CLASSROOM,
              C.CLASSROOM_ID: sharingContent[C.ID],
            };
            break;
          case SharingContentType.Exam:
            // Not required to share exam internally, Can make confusion in exam and conducted exam
            break;
          case SharingContentType.QUESTION:
            // TODO: Handle this case.
            break;
          case SharingContentType.Media:
            // Handled in the loop
            break;
          case SharingContentType.NoteList:
            messageList = sharingContent[C.LIST]
                .map((note) {
                  return {
                    C.TYPE: E.NOTE,
                    C.NOTE: note,
                  };
                })
                .toList()
                .cast<Map<String, dynamic>>();
            break;
          case SharingContentType.Message:
            messageObj = {...sharingContent};
            messageObj.remove(C.ID);
            messageObj.remove(C.CLASSROOM);
            break;
        }

        // Classroom List
        List alreadyUploadedMediaList;
        for (var classroom in selectedClassrooms) {
          // user is admin or anyone can share message
          if (!(classroom[C.IS_ADMIN] ||
              classroom[C.WHO_CAN_SEND_MESSAGES] == E.ALL)) {
            continue;
          }
          if (messageList != null) {
            messageList = messageList
                .map((message) => {
                      ...message,
                      C.CLASSROOM: classroom[C.ID],
                    })
                .toList();
            var list = await createMessageList({C.LIST: messageList});
            // if message sent
            if (list != null && list.length > 0) {
              ClassroomListController.to.addMessage(classroom[C.ID], list.last);
            }
            // message failed to sent
            else {
              // TODO: handle failed message
            }
            continue;
          }

          if (contentType == SharingContentType.Media) {
            alreadyUploadedMediaList = await sendMediaToChat(
              alreadyUploadedMediaList ?? sharingContent[C.MEDIA],
              classroom[C.ID],
            );
            continue;
          }

          // Message Object
          messageObj[C.CLASSROOM] = classroom[C.ID];

          var message = await createMessage(messageObj);

          // if message sent
          if (message != null) {
            ClassroomListController.to.addMessage(classroom[C.ID], message);
          }
          // message failed to sent
          else {
            // TODO: handle failed message
          }
        }
      },
      selectedClassroom: [],
    ),
  );
}

externalShare(SharingContentType contentType, Map sharingContent) async {
  // Track Sharing event
  track(EventName.EXTERNAL_SHARE, {
    EventProp.TYPE: contentType.toString(),
  });

  switch (contentType) {
    case SharingContentType.Text:
      Share.share(sharingContent[C.TEXT], subject: S.APP_NAME.tr);
      break;
    case SharingContentType.Classroom:
      var link = await getDeepLink(Path.CLASSROOM_DETAILS,
          payload: {C.ID: sharingContent[C.ID]});
      String text = S.CLASSROOM_DETAILS_SHARING_TEXT.trParams({
        'title': sharingContent[C.TITLE],
        'user': UserController.to.currentUser[C.NAME],
        'link': link.toString(),
      });
      Share.share(text);
      break;
    case SharingContentType.Exam:
      shareSingleExam(sharingContent);
      break;
    case SharingContentType.QUESTION:
      // TODO: Handle this case.
      break;
    case SharingContentType.Media:
      // TODO: Handle this case.
      break;
    case SharingContentType.NoteList:
      // This is not reachable
      break;
    case SharingContentType.Note:
      await shareSingleNote(sharingContent);
      break;
    case SharingContentType.Message:
      // TODO: Handle this case.
      break;
  }
}

enum SharingContentType {
  Message,
  Classroom,
  Text,
  Media,
  Note,
  NoteList,
  Exam,
  QUESTION,
}

enum ShareScope { INTERNAL, EXTERNAL }

// Other Apps shared media to Apna Classroom sharable media
shareMediaToMedia(List<SharedMediaFile> list) async {
  List<Map<String, dynamic>> newList = [];

  for (var element in list) {
    String path = element.path;

    switch (element.type) {
      case SharedMediaType.IMAGE:
        Uint8List thumbnail = await compressImage(path: path, thumbnail: true);

        Uint8List compressedFile = await compressImage(path: path);

        Map file = await saveToDevice(
          bytes: compressedFile,
          extension: getExtension(path),
          type: FileType.IMAGE,
          name: FileName.MAIN,
        );
        File image = file[C.FILE];

        Map thumbnailFile = await saveToDevice(
          bytes: thumbnail,
          extension: '.jpg',
          type: FileType.IMAGE,
          name: FileName.THUMBNAIL,
          filename: file[C.NAME],
        );

        var thumbnailImage = thumbnailFile[C.FILE];

        newList.add({
          C.TYPE: E.IMAGE,
          C.FILE: image,
          C.THUMBNAIL: thumbnailImage,
          C.TITLE: getFileName(filePath: path)
        });
        break;

      case SharedMediaType.VIDEO:
        final thumbnail = await VideoThumbnail.thumbnailData(
          video: path,
          imageFormat: ImageFormat.PNG,
          maxWidth: 200,
          quality: 25,
        );

        // Save thumbnail to local
        Map thumbnailFile = await saveToDevice(
          bytes: thumbnail,
          extension: '.png',
          type: FileType.VIDEO,
          name: FileName.THUMBNAIL,
          filename: getFileName(filePath: path),
        );

        var thumbnailImage = thumbnailFile[C.FILE];

        newList.add({
          C.TYPE: E.VIDEO,
          C.FILE: File(path),
          C.THUMBNAIL: thumbnailImage,
          C.TITLE: getFileName(filePath: path)
        });
        break;
      case SharedMediaType.FILE:
        Map file = await saveToDevice(
          file: File(path),
          extension: getExtension(path),
          type: FileType.DOC,
          name: FileName.MAIN,
        );

        var pdfFile = file[C.FILE];

        File thumbnailImage =
            await getPdfCoverImage(path: path, filename: file[C.NAME]);

        newList.add({
          C.TYPE: E.PDF,
          C.FILE: pdfFile,
          C.THUMBNAIL: thumbnailImage,
          C.TITLE: getFileName(filePath: path),
        });
        break;
    }
  }

  return newList;
}

// Share Note to external apps
shareSingleNote(note) async {
  var link = await getDeepLink(Path.NOTE_DETAILS, payload: {C.ID: note[C.ID]});
  String text = S.NOTE_DETAILS_SHARING_TEXT.trParams({
    'title': note[C.TITLE],
    'user': UserController.to.currentUser[C.NAME],
    'link': link.toString(),
  });
  Share.share(text);
}

// Share Exam to external apps
shareSingleExam(exam) async {
  var link = await getDeepLink(Path.EXAM_DETAILS, payload: {C.ID: exam[C.ID]});
  String text = S.NOTE_DETAILS_SHARING_TEXT.trParams({
    'title': exam[C.TITLE],
    'user': UserController.to.currentUser[C.NAME],
    'link': link.toString(),
  });
  Share.share(text);
}
