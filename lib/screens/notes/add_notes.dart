import 'dart:async';

import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/api/storage/storage_api.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/components/buttons/flat_icon_text_button.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/editor/text_editor.dart';
import 'package:apna_classroom_app/components/radio/radio_group.dart';
import 'package:apna_classroom_app/components/tags/subject_tag_input.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/media/media_picker/media_picker.dart';
import 'package:apna_classroom_app/screens/notes/widgets/note_view.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const int MAX_RECENTLY_SUBJECTS = 5;

class AddNotes extends StatefulWidget {
  final note;

  const AddNotes({Key key, this.note}) : super(key: key);
  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  // Constants
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController subjectController = TextEditingController();

  // Variables
  Map<String, dynamic> notesData;
  List<Map<String, dynamic>> notes = [];
  String subjectError;
  String noteError;

  // Initialize Stat
  @override
  void initState() {
    notesData = {
      C.PRIVACY: E.PUBLIC,
    };
    if (widget.note != null) {
      notesData = {
        C.ID: widget.note[C.ID],
        C.PRIVACY: widget.note[C.PRIVACY],
        C.TITLE: widget.note[C.TITLE],
      };
      subjects = widget.note[C.SUBJECT].cast<String>().toSet();
      notes = widget.note[C.LIST]
          .map((element) {
            if (element[C.MEDIA] != null) {
              var media = element[C.MEDIA];
              return {
                C.ID: media[C.ID],
                C.TYPE: media[C.TYPE],
                C.TITLE: media[C.TITLE],
                C.URL: media[C.URL],
              };
            }
            if (element[C.TEXT] != null) {
              var text = element[C.TEXT];
              return {
                C.ID: text[C.ID],
                C.TEXT: text[C.TEXT].cast<Map<String, dynamic>>(),
                C.TYPE: E.TEXT,
                C.TITLE: text[C.TITLE]
              };
            }
          })
          .toList()
          .cast<Map<String, dynamic>>();
    }
    super.initState();

    // Track screen
    trackScreen(ScreenNames.AddNote);
  }

  // Save
  save() async {
    if (notes.length == 0) {
      setState(() {
        noteError = S.NO_NOTES_TO_SAVE.tr;
      });
      return;
    }
    var form = formKey.currentState;
    if (form.validate()) {
      if (subjects.isEmpty) {
        setState(() {
          subjectError = S.ADD_AT_LEAST_ONE_SUBJECT.tr;
        });
        return;
      }
      if (notes.any((note) => note[C.TITLE].toString().isEmpty)) {
        setState(() {
          noteError = S.NOTE_TITLE_CAN_T_BE_EMPTY.tr;
        });
        return;
      }
      if (widget.note != null) {
        var result = await wantToEdit(() => true, S.NOTE_EDIT_NOTE.tr);
        if (!(result ?? false)) return;
      }
      setState(() {
        subjectError = null;
        noteError = null;
      });

      notesData[C.SUBJECT] = subjects.toList();
      form.save();

      showProgress();
      List notesUploaded = await Future.wait(notes.map((note) async {
        String url;
        if (note[C.ID] != null) {
          if (note[C.TYPE] == E.TEXT) {
            return {
              C.TEXT: {
                C.ID: note[C.ID],
                C.TITLE: note[C.TITLE],
                C.TEXT: note[C.TEXT],
              }
            };
          }
          return {
            C.MEDIA: {
              C.ID: note[C.ID],
              C.TITLE: note[C.TITLE],
              C.TYPE: note[C.TYPE],
              C.URL: note[C.URL],
            }
          };
        }
        switch (note[C.TYPE]) {
          case E.IMAGE:
            var storageResponse = await uploadToStorage(
                file: note[C.FILE],
                type: FileType.IMAGE,
                thumbnail: note[C.THUMBNAIL]);
            url = storageResponse[StorageConstant.PATH];
            break;
          case E.PDF:
            var storageResponse = await uploadToStorage(
                file: note[C.FILE],
                type: FileType.DOC,
                thumbnail: note[C.THUMBNAIL]);
            url = storageResponse[StorageConstant.PATH];
            break;
          case E.VIDEO:
            var storageResponse = await uploadToStorage(
                file: note[C.FILE],
                type: FileType.VIDEO,
                thumbnail: note[C.THUMBNAIL]);
            url = storageResponse[StorageConstant.PATH];
            break;
        }

        switch (note[C.TYPE]) {
          case E.IMAGE:
          case E.PDF:
          case E.VIDEO:
            return {
              C.MEDIA: {
                C.TITLE: note[C.TITLE],
                C.TYPE: note[C.TYPE],
                C.URL: url,
              }
            };
          default:
            return {
              C.TEXT: {
                C.TITLE: note[C.TITLE],
                C.TEXT: note[C.TEXT],
              }
            };
        }
      }));
      notesData[C.LIST] = notesUploaded;
      var note = await createNote(notesData);

      // Track add notes event
      track(EventName.ADD_NOTES, {
        EventProp.PRIVACY: notesData[C.PRIVACY],
        EventProp.SUBJECTS: notesData[C.SUBJECT],
        EventProp.COUNT: notes?.length,
        EventProp.EDIT: widget.note != null,
      });

      // Track single note event
      notes.forEach((element) {
        track(EventName.SINGLE_NOTE, {
          EventProp.TYPE: element[C.TYPE],
        });
      });

      RecentlyUsedController.to.setLastUsedSubjects(subjects.toList());
      Get.back();
      if (note != null) Get.back(result: true);
    }
  }

  // Common Functions

  // Title of Notes

  // Subjects of Notes
  Set<String> subjects = {};
  addSubject(String value) {
    setState(() {
      subjects.add(value);
    });
  }

  removeSubject(String value) {
    setState(() {
      subjects.remove(value);
    });
  }

  addAllLastUsed() {
    setState(() {
      subjects.addAll(RecentlyUsedController.to.lastUsedSubjects);
    });
  }

  // Privacy of the notes
  onChangePrivacy(String value) {
    notesData[C.PRIVACY] = value;
  }

  // Text Editor
  getNotesFromEditor({List<Map<String, dynamic>> list, int index}) async {
    if (list != null) Get.back();
    var data = await Get.to(TextEditor(
      data: list,
    ));
    if (data == null) return;
    setState(() {
      if (index != null) {
        notes.replaceRange(index, index + 1, [
          {C.TEXT: data, C.TYPE: E.TEXT}
        ]);
      } else {
        notes.add({C.TEXT: data, C.TYPE: E.TEXT});
      }
    });
  }

  // File Picker
  pickFile() async {
    var result = await showApnaMediaPicker(false);

    if (result == null) return;
    setState(() {
      notes.addAll(result);
    });
  }

  onNoteDelete(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  onNoteMove(int index, AxisDirection direction, bool end) {
    Get.back();
    if ((direction == AxisDirection.up && index == 0) ||
        (direction == AxisDirection.down && index == notes.length - 1)) return;
    if (direction == AxisDirection.up && end) {
      var note = notes.removeAt(index);
      notes.insert(0, note);
    } else if (direction == AxisDirection.up) {
      var note = notes.removeAt(index);
      notes.insert(index - 1, note);
    } else if (direction == AxisDirection.down && end) {
      var note = notes.removeAt(index);
      notes.add(note);
    } else if (direction == AxisDirection.down) {
      var note = notes.removeAt(index);
      notes.insert(index + 1, note);
    }
    setState(() {});
  }

  onChangeTitle(int index, String title) {
    notes[index][C.TITLE] = title;
  }

  // On Back
  Future<bool> _onBack() async {
    var result = await wantToDiscard(() => true, S.NOTE_DISCARD.tr);
    return (result ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.ADD_NOTES.tr),
          actions: [IconButton(icon: Icon(Icons.check), onPressed: save)],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title of the Notes
                  TextFormField(
                    initialValue: notesData[C.TITLE],
                    decoration:
                        InputDecoration(labelText: S.ENTER_NOTES_TITLE.tr),
                    validator: validTitle,
                    onSaved: (value) => notesData[C.TITLE] = value,
                    maxLength: 50,
                  ),
                  SizedBox(height: 8),
                  // Add Subjects list
                  SubjectTagInput(
                    subjects: subjects,
                    subjectError: subjectError,
                    subjectController: subjectController,
                    addSubject: addSubject,
                    removeSubject: removeSubject,
                    addAllLastUsed: addAllLastUsed,
                  ),
                  RadioGroup(
                    list: {
                      E.PUBLIC: S.PUBLIC.tr,
                      E.PRIVATE: S.PRIVATE.tr,
                    },
                    defaultValue: notesData[C.PRIVACY],
                    onChange: onChangePrivacy,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlatIconTextButton(
                        onPressed: getNotesFromEditor,
                        iconData: Icons.edit,
                        text: S.OPEN_EDITOR.tr,
                      ),
                      FlatIconTextButton(
                        onPressed: pickFile,
                        iconData: Icons.attach_file,
                        text: S.UPLOAD_FILE.tr,
                        note: S.ACCEPTED_FORMATS.tr,
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  if (noteError != null)
                    Text(
                      noteError,
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                  SizedBox(height: 12),
                ]..addAll(notes.asMap().map(
                    (i, e) {
                      return MapEntry(
                        i,
                        NoteView(
                          note: e,
                          onChangeTitle: (title) => onChangeTitle(i, title),
                          onDelete: () => onNoteDelete(i),
                          onNoteMove: (AxisDirection direction, bool end) =>
                              onNoteMove(i, direction, end),
                          onEdit: () =>
                              getNotesFromEditor(list: e[C.TEXT], index: i),
                        ),
                      );
                    },
                  ).values),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
