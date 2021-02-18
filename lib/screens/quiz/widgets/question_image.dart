import 'package:apna_classroom_app/components/apna_menu.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/components/menu_item.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/media/image_viewer.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionImage extends StatefulWidget {
  final Map<String, dynamic> questionImage;
  final Function(String name) onChangeName;
  final Function onDelete;
  final bool isEditable;

  const QuestionImage(
      {Key key,
      this.questionImage,
      this.onChangeName,
      this.onDelete,
      this.isEditable})
      : super(key: key);

  @override
  _QuestionImageState createState() => _QuestionImageState();
}

class _QuestionImageState extends State<QuestionImage> {
  TextEditingController nameController = TextEditingController();
  String nameError;

  onChangeName(String value) {
    if (value.isEmpty) {
      setState(() {
        nameError = S.PLEASE_ENTER_IMAGE_NAME.tr;
      });
    } else if (value.isNotEmpty && nameError != null) {
      setState(() {
        nameError = null;
      });
    }
    if (widget.onChangeName != null) widget.onChangeName(value);
  }

  onLongPress() {
    if (widget.isEditable ?? false) {
      showApnaMenu(context, [
        MenuItem(
          text: S.DELETE.tr,
          iconData: Icons.delete,
          onTap: () {
            widget.onDelete();
            Get.back();
          },
        ),
      ]);
    }
  }

  @override
  void initState() {
    nameController.text = widget.questionImage[C.TITLE];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(ImageViewer(
        image: widget.questionImage[C.FILE],
        url: widget.questionImage[C.URL],
      )),
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width * 0.5 - 20,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: getThumbnailImage(),
            ),
            SizedBox(height: 4.0),
            if (widget.isEditable ?? false)
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  errorText: nameError,
                  labelText: S.IMAGE_NAME.tr,
                ),
                onChanged: onChangeName,
              ),
            if (!(widget.isEditable ?? false))
              SelectableText(widget.questionImage[C.TITLE] ?? ''),
          ],
        ),
      ),
    );
  }

  getThumbnailImage() {
    if (widget.questionImage[C.THUMBNAIL] != null) {
      return Image.file(widget.questionImage[C.THUMBNAIL]);
    }
    if (widget.questionImage[C.THUMBNAIL_URL] != null) {
      return UrlImage(
        url: widget.questionImage[C.THUMBNAIL_URL],
      );
    }
    return SizedBox();
  }
}
