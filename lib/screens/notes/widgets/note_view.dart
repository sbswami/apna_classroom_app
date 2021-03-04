import 'package:apna_classroom_app/components/apna_menu.dart';
import 'package:apna_classroom_app/components/editor/text_field.dart';
import 'package:apna_classroom_app/components/editor/text_viewer.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/components/menu_item.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/media/image_viewer.dart';
import 'package:apna_classroom_app/screens/media/pdf_viewer.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteView extends StatefulWidget {
  final Map<String, dynamic> note;
  final Function(String value) onChangeTitle;
  final Function onDelete;
  final Function(AxisDirection direction, bool end) onNoteMove;
  final Function onEdit;
  final bool isQuestion;

  NoteView(
      {Key key,
      this.note,
      this.onChangeTitle,
      this.onDelete,
      this.onNoteMove,
      this.isQuestion,
      this.onEdit})
      : super(key: key);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  TextEditingController titleController = TextEditingController();
  String titleError;

  @override
  void initState() {
    if (widget.note[C.TYPE] == E.TEXT) {
      String title = getTitleOfTextNote();
      titleController.text = title;
      onChangeTitle(title);
    } else {
      titleController.text = widget.note[C.TITLE] ?? '';
    }
    super.initState();
  }

  // Get title of text data
  String getTitleOfTextNote() {
    String firstLine = widget.note[C.TEXT].first[C.DATA];
    int firstLineLength = firstLine.length;
    String title = firstLine.substring(
        0,
        firstLineLength < MAX_NOTE_TITLE_LENGTH
            ? firstLineLength
            : MAX_NOTE_TITLE_LENGTH);
    return title;
  }

  onChangeTitle(String value) {
    if (value.isEmpty) {
      setState(() {
        titleError = S.PLEASE_ENTER_THE_NOTE_TITLE.tr;
      });
    } else if (value.isNotEmpty && titleError != null) {
      setState(() {
        titleError = null;
      });
    }
    if (widget.onChangeTitle != null) widget.onChangeTitle(value);
  }

  onLongPress() {
    List<MenuItem> items = [
      MenuItem(
        text: S.DELETE.tr,
        iconData: Icons.delete,
        onTap: () {
          Get.back();
          widget.onDelete();
        },
      )
    ];

    if (widget.note[C.TYPE] == E.TEXT) {
      items.add(MenuItem(
        text: S.EDIT.tr,
        iconData: Icons.edit,
        onTap: () => widget.onEdit(),
      ));
    }

    if (!(widget.isQuestion ?? false)) {
      items.addAll([
        MenuItem(
          text: S.MOVE_UP.tr,
          iconData: Icons.arrow_upward,
          onTap: () => widget.onNoteMove(AxisDirection.up, false),
        ),
        MenuItem(
          text: S.MOVE_DOWN.tr,
          iconData: Icons.arrow_downward,
          onTap: () => widget.onNoteMove(AxisDirection.down, false),
        ),
        MenuItem(
          text: S.MOVE_TO_TOP.tr,
          iconData: Icons.arrow_circle_up,
          onTap: () => widget.onNoteMove(AxisDirection.up, true),
        ),
        MenuItem(
          text: S.MOVE_TO_BOTTOM.tr,
          iconData: Icons.arrow_circle_down,
          onTap: () => widget.onNoteMove(AxisDirection.down, true),
        )
      ]);
    }
    showApnaMenu(context, items);
  }

  onTap() {
    switch (widget.note[C.TYPE]) {
      case E.TEXT:
        Get.to(TextViewer(text: widget.note));
        break;
      case E.IMAGE:
        Get.to(ImageViewer(
          image: widget.note[C.FILE],
          url: widget.note[C.URL],
        ));
        break;
      case E.PDF:
        Get.to(PdfViewer(
          pdf: widget.note[C.FILE],
          url: widget.note[C.URL],
        ));
        break;
    }
  }

  @override
  void didUpdateWidget(covariant NoteView oldWidget) {
    if (widget.note[C.TYPE] == E.TEXT) {
      String title = getTitleOfTextNote();
      titleController.text = title;
      onChangeTitle(title);
    } else if (oldWidget.note[C.TITLE] != widget.note[C.TITLE]) {
      titleController.text = widget.note[C.TITLE];
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!(widget.isQuestion ?? false))
                  TextField(
                    // textAlign: TextAlign.center,
                    controller: titleController,
                    decoration: InputDecoration(
                      errorText: titleError,
                      labelText: S.NOTE_TITLE.tr,
                    ),
                    onChanged: onChangeTitle,
                  ),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: getContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getContent() {
    switch (widget.note[C.TYPE]) {
      case E.TEXT:
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: widget.note[C.TEXT]
                .take(2)
                .map<Widget>(
                  (e) => Row(
                    children: [
                      Flexible(
                        child: Text(
                          e[C.DATA],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: getSmartTextTypeFromString(e[C.DATA_TYPE])
                              .textStyle,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        );
      case E.PDF:
      case E.IMAGE:
        return ClipRRect(
          child: widget.note[C.THUMBNAIL_URL] != null
              ? UrlImage(url: widget.note[C.THUMBNAIL_URL])
              : Image.file(widget.note[C.THUMBNAIL]),
          borderRadius: BorderRadius.circular(10),
        );
    }
    return SizedBox();
  }
}
