import 'dart:io';

import 'package:apna_classroom_app/components/editor/text_field.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:flutter/material.dart';

class SingleNote extends StatefulWidget {
  final Map<String, dynamic> note;
  final Function onTap;

  const SingleNote({Key key, this.onTap, this.note}) : super(key: key);

  @override
  _SingleNoteState createState() => _SingleNoteState();
}

class _SingleNoteState extends State<SingleNote> {
  bool isLoading = false;
  File thumbnail;

  @override
  void initState() {
    if (widget.note[C.MEDIA] != null) {
      isLoading = true;
    }
    super.initState();
    loadThumbnail();
  }

  void loadThumbnail() async {
    if (widget.note[C.MEDIA] != null) {
      File _thumbnail = await getFile(widget.note[C.MEDIA][C.THUMBNAIL_URL]);
      setState(() {
        thumbnail = _thumbnail;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.all(16.0),
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
                SelectableText(
                    (widget.note[C.TEXT] ?? widget.note[C.MEDIA])[C.TITLE]),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      );
    }
    if (widget.note[C.TEXT] != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: widget.note[C.TEXT][C.TEXT]
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
    } else if (widget.note[C.MEDIA] != null) {
      return ClipRRect(
        child: Image.file(thumbnail),
        borderRadius: BorderRadius.circular(10),
      );
    }
    return SizedBox();
  }
}
