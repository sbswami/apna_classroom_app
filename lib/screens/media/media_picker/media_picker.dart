import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/storage/storage.dart';
import 'package:apna_classroom_app/components/apna_file_picker.dart';
import 'package:apna_classroom_app/components/buttons/flat_icon_text_button.dart';
import 'package:apna_classroom_app/components/images/apna_image_picker.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/media/media_picker/old_media_list.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaPicker extends StatefulWidget {
  final bool onlyImage;
  final bool deleteOption;

  const MediaPicker({Key key, @required this.onlyImage, this.deleteOption})
      : super(key: key);

  @override
  _MediaPickerState createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  // Tab State
  int selectedTab = 0;
  changeTab(int tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  // Pick File
  pickFile() async {
    var result;
    if (widget.onlyImage) {
      result = await showApnaImagePicker(Get.context);
      if (result != null) {
        String title = getFileName(filePath: result[0]);
        result = {
          C.TITLE: title.length > 20 ? S.APP_N.tr : title,
          C.THUMBNAIL: result[1],
          C.FILE: result[2],
          C.TYPE: E.IMAGE,
        };
      }
    } else {
      result = await showApnaFilePicker(true);
    }
    Get.back(result: {
      C.UPLOAD: true,
      C.RESULT: result,
    });
  }

  // Select Image
  onMediaSelect(List images) {
    if (widget.onlyImage) {
      int length = images.length;
      if (length > 0)
        return Get.back(result: {
          C.UPLOAD: false,
          C.RESULT: images.first,
        });
    }
    Get.back(result: {
      C.UPLOAD: false,
      C.RESULT: images,
    });
  }

  // Delete image
  _deleteImage() {
    Get.back(result: {
      C.UPLOAD: false,
      C.DELETE: true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          if (widget.onlyImage)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatIconTextButton(
                  iconData: Icons.upload_rounded,
                  text: S.UPLOAD.tr,
                  onPressed: pickFile,
                ),
                if (widget.deleteOption ?? false)
                  FlatIconTextButton(
                    iconData: Icons.delete,
                    text: S.DELETE.tr,
                    onPressed: _deleteImage,
                  )
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 16.0),
                FlatIconTextButton(
                  iconData: Icons.upload_file,
                  text: S.UPLOAD_FILE.tr,
                  onPressed: pickFile,
                ),
                Column(
                  children: [
                    TextButton(
                        onPressed: () => changeTab(0), child: Text(S.IMAGE.tr)),
                    Visibility(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Theme.of(context).primaryColor,
                      ),
                      visible: selectedTab == 0,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                        onPressed: () => changeTab(1), child: Text(S.PDF.tr)),
                    Visibility(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Theme.of(context).primaryColor,
                      ),
                      visible: selectedTab == 1,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                        onPressed: () => changeTab(2), child: Text(S.VIDEO.tr)),
                    Visibility(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Theme.of(context).primaryColor,
                      ),
                      visible: selectedTab == 2,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                    ),
                  ],
                ),
                Divider()
              ],
            ),
          Divider(),
          Visibility(
            key: Key(C.IMAGE),
            child: Expanded(
              child: OldMediaList(
                onMediaSelect: onMediaSelect,
                type: MediaType.Image,
                isSelectable: !widget.onlyImage,
              ),
            ),
            visible: selectedTab == 0,
          ),
          Visibility(
            key: Key(C.PDF),
            child: Expanded(
              child: OldMediaList(
                onMediaSelect: onMediaSelect,
                type: MediaType.PDF,
                isSelectable: true,
              ),
            ),
            visible: selectedTab == 1,
          ),
          Visibility(
            key: Key(C.VIDEO),
            child: Expanded(
              child: OldMediaList(
                onMediaSelect: onMediaSelect,
                type: MediaType.Video,
                isSelectable: true,
              ),
            ),
            visible: selectedTab == 2,
          ),
        ],
      ),
    );
  }
}

showApnaMediaPicker(bool onlyImage, {bool deleteOption}) async {
  var result = await showModalBottomSheet(
    context: Get.context,
    builder: (BuildContext context) {
      return MediaPicker(onlyImage: onlyImage, deleteOption: deleteOption);
    },
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
  );

  if (result == null) return;
  if (result[C.DELETE] ?? false) return {C.DELETE: true};

  if (result[C.RESULT] is Iterable) {
    int beforeSize = result[C.RESULT]?.length;

    result[C.RESULT]?.removeWhere((element) => element == null);

    int afterSize = result[C.RESULT]?.length;

    if (beforeSize != afterSize) {
      Get.snackbar(S.FILE_NOT_ALLOWED.tr, S.COMPLETE_GUIDE_LINE.tr);
    }
  }

  // Track event
  track(EventName.PICK_MEDIA, {});

  if (result[C.UPLOAD]) {
    return result[C.RESULT];
  }
  if (!result[C.UPLOAD]) {
    return result[C.RESULT];
  }
}
