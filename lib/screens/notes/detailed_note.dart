import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/cards/detailed_card.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/share/apna_share.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/notes/add_notes.dart';
import 'package:apna_classroom_app/screens/notes/widgets/notes_card.dart';
import 'package:apna_classroom_app/screens/notes/widgets/single_note.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/helper.dart';
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
  NoteStates state = NoteStates.Loading;
  Map<String, dynamic> note;

  // Load Data
  loadNote() async {
    Map<String, dynamic> _note = await getNote({
      C.ID: widget.note[C.ID],
      C.CLASSROOM: (widget.fromClassroom ?? false).toString()
    });
    if (_note == null) {
      state = NoteStates.Deleted;
    } else if (_note[C.CREATED_BY] != null) {
      state = NoteStates.Access;
    } else {
      state = NoteStates.Private;
    }
    setState(() {
      note = _note;
    });

    if (_note != null &&
        !isCreator(_note[C.CREATED_BY]) &&
        !_note[C.ACCESS_LIST].contains(getUserId()) &&
        _note[C.PRIVACY] == E.PUBLIC) {
      await addToAccessListNote({C.ID: _note[C.ID]});
    }

    // Track screen
    track(EventName.VIEWED_NOTES_DETAILS, {
      EventProp.PRIVACY: _note[C.PRIVACY],
      EventProp.SUBJECTS: _note[C.SUBJECT],
      EventProp.COUNT: _note[C.LIST]?.length,
    });
  }

  // Share Notes in classroom
  shareNote() async {
    await apnaShare(SharingContentType.Note, note);

    // Track share note
    track(EventName.SHARE_NOTE, {
      EventProp.PRIVACY: note[C.PRIVACY],
      EventProp.SUBJECTS: note[C.SUBJECT],
    });
  }

  // Delete
  _onDelete() async {
    var result = await wantToDelete(() {
      return true;
    }, S.NOTE_DELETE_NOTE.tr);
    if (!(result ?? false)) return;
    bool isDeleted = await deleteNote({
      C.ID: [widget.note[C.ID]],
    });
    if (!isDeleted)
      return ok(title: S.SOMETHING_WENT_WRONG.tr, msg: S.CAN_NOT_DELETE_NOW.tr);

    // Track delete note
    track(EventName.DELETE_NOTE, {
      EventProp.PRIVACY: note[C.PRIVACY],
      EventProp.SUBJECTS: note[C.SUBJECT],
    });

    Get.back(result: true);
  }

  // Edit
  bool isEdited = false;
  _onEdit() async {
    var result = await Get.to(() => AddNotes(note: note));

    // Track screen back
    trackScreen(ScreenNames.DetailedNotes);

    if (result ?? false) {
      setState(() {
        state = NoteStates.Loading;
        note = null;
        isEdited = true;
      });
      loadNote();
    }
  }

  @override
  void initState() {
    super.initState();

    // Track screen
    trackScreen(ScreenNames.DetailedNotes);

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
            if (note != null)
              IconButton(icon: Icon(Icons.share), onPressed: shareNote),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.note[C.TITLE] != null || state == NoteStates.Access)
              NotesCard(note: (note ?? widget.note)),
            if (state == NoteStates.Loading)
              Expanded(
                child: DetailsSkeleton(
                  type: DetailsType.CardInfo,
                ),
              )
            else if (state == NoteStates.Deleted)
              DetailedCard(
                text: S.NOTES_ARE_DELETED_BY_CREATOR.tr,
                onOkay: _onBack,
              )
            else if (state == NoteStates.Private)
              DetailedCard(
                text: S.YOU_DO_NOT_HAVE_ACCESS_NOTE.tr,
                onOkay: _onBack,
              )
            else if (state == NoteStates.Access)
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

enum NoteStates {
  Loading,
  Access,
  Deleted,
  Private,
}
