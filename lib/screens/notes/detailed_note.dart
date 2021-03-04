import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/share/apna_share.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/notes/add_notes.dart';
import 'package:apna_classroom_app/screens/notes/widgets/notes_card.dart';
import 'package:apna_classroom_app/screens/notes/widgets/single_note.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedNote extends StatefulWidget {
  final Map<String, dynamic> note;
  final bool fromClassroom;

  const DetailedNote({Key key, this.note, this.fromClassroom})
      : super(key: key);

  @override
  _DetailedNoteState createState() => _DetailedNoteState();
}

class _DetailedNoteState extends State<DetailedNote> {
  // Variables
  bool isLoading = true;
  Map<String, dynamic> note;

  // Load Data
  loadNote() async {
    Map<String, dynamic> _note = await getNote({
      C.ID: widget.note[C.ID],
      C.CLASSROOM: (widget.fromClassroom ?? false).toString()
    });
    setState(() {
      note = _note;
      isLoading = false;
    });
  }

  // Share Notes in classroom
  shareNote() {
    apnaShare(SharingContentType.NOTE, note);
  }

  // Delete
  _onDelete() async {
    var result = await wantToDelete(() {
      return true;
    }, S.NOTE_DELETE_NOTE.tr);
    if (!(result ?? false)) return;
    bool isDeleted = await deleteNote({
      C.ID: widget.note[C.ID],
    });
    if (!isDeleted)
      return ok(title: S.SOMETHING_WENT_WRONG.tr, msg: S.CAN_NOT_DELETE_NOW.tr);
    Get.back(result: true);
  }

  // Edit
  bool isEdited = false;
  _onEdit() async {
    var result = await Get.to(() => AddNotes(note: note));
    if (result ?? false) {
      setState(() {
        isLoading = true;
        note = null;
        isEdited = true;
      });
      loadNote();
    }
  }

  @override
  void initState() {
    super.initState();
    loadNote();
  }

  // On Back
  Future<bool> _onBack() async {
    Get.back(result: isEdited);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    int listCount = (note ?? {})[C.LIST]?.length ?? 0;
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.NOTES.tr),
          actions: [
            if (isCreator((note ?? {})[C.CREATED_BY]))
              IconButton(
                  icon: Icon(Icons.delete_rounded), onPressed: _onDelete),
            IconButton(icon: Icon(Icons.share), onPressed: shareNote),
          ],
        ),
        body: Column(
          children: [
            NotesCard(note: (note ?? widget.note)),
            if (isLoading)
              DetailsSkeleton(
                type: DetailsType.CardInfo,
              ),
            if (note == null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  S.NOTES_ARE_DELETED_BY_CREATOR.tr,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
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
        floatingActionButton: isCreator((note ?? {})[C.CREATED_BY])
            ? FloatingActionButton(
                onPressed: _onEdit,
                child: Icon(Icons.edit),
              )
            : null,
      ),
    );
  }
}
