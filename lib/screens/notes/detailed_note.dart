import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/components/skeletons/list_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/notes/widgets/notes_card.dart';
import 'package:apna_classroom_app/screens/notes/widgets/single_note.dart';
import 'package:apna_classroom_app/util/c.dart';
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
                return SingleNote(note: note[C.LIST][position]);
              },
            ),
          )
        ],
      ),
    );
  }
}
