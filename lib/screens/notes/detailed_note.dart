import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/components/editor/text_viewer.dart';
import 'package:apna_classroom_app/components/skeletons/list_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/image_viewer/image_viewer.dart';
import 'package:apna_classroom_app/screens/notes/widgets/notes_card.dart';
import 'package:apna_classroom_app/screens/notes/widgets/single_note.dart';
import 'package:apna_classroom_app/screens/pdf_viewer/pdf_viewer.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedNote extends StatefulWidget {
  final Map<String, dynamic> note;

  const DetailedNote({Key key, this.note}) : super(key: key);

  @override
  _DetailedNoteState createState() => _DetailedNoteState();
}

class _DetailedNoteState extends State<DetailedNote> {
  // Variables
  bool isLoading = true;
  Map<String, dynamic> note = {};

  // Load Data
  loadNote() async {
    Map<String, dynamic> _note = await getNote({C.ID: widget.note[C.ID]});
    setState(() {
      note = _note;
      isLoading = false;
    });
  }

  shareNote() {}

  openNote(Map<String, dynamic> _note) {
    if (_note[C.MEDIA] != null) {
      String url = _note[C.MEDIA][C.URL];
      switch (_note[C.MEDIA][C.TYPE]) {
        case E.PDF:
          Get.to(PdfViewer(
            url: url,
          ));
          break;
        case E.IMAGE:
          Get.to(ImageViewer(
            url: url,
          ));
          break;
      }
    } else if (_note[C.TEXT] != null) {
      Get.to(TextViewer(
        text: _note[C.TEXT],
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    loadNote();
  }

  @override
  Widget build(BuildContext context) {
    int listCount = note[C.LIST]?.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.NOTES.tr),
        actions: [IconButton(icon: Icon(Icons.share), onPressed: shareNote)],
      ),
      body: Column(
        children: [
          NotesCard(note: widget.note),
          if (isLoading) ListSkeleton(size: 3),
          Expanded(
            child: ListView.builder(
              itemCount: listCount,
              itemBuilder: (BuildContext context, int position) {
                var _note = note[C.LIST][position];
                return SingleNote(
                  note: note[C.LIST][position],
                  onTap: () => openNote(_note),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
