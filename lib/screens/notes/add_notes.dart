import 'dart:async';

import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/api/storage.dart';
import 'package:apna_classroom_app/components/apna_file_picker.dart';
import 'package:apna_classroom_app/components/buttons/flat_icon_text_button.dart';
import 'package:apna_classroom_app/components/dialogs/upload_dialog.dart';
import 'package:apna_classroom_app/components/editor/text_editor.dart';
import 'package:apna_classroom_app/components/radio/radio_group.dart';
import 'package:apna_classroom_app/components/tags/subject_tag_input.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/notes/widgets/note_view.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const int MAX_RECENTLY_SUBJECTS = 5;

class AddNotes extends StatefulWidget {
  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  // Constants
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController subjectController = TextEditingController();

  // Variables
  Map<String, dynamic> notesData;
  bool _loading = false;
  List<Map<String, dynamic>> notes = [];
  String subjectError;
  String noteError;

  // Initialize Stat
  @override
  void initState() {
    notesData = {
      C.PRIVACY: E.PUBLIC,
    };
    super.initState();
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
      setState(() {
        subjectError = null;
        noteError = null;
      });

      notesData[C.SUBJECT] = subjects.toList();
      form.save();

      UploadController controller =
          Get.put(UploadController(notes.length, 0), tag: NOTES_CONTROLLER_TAG);
      showUploadDialog(NOTES_CONTROLLER_TAG);
      List notesUploaded = await Future.wait(notes.map((note) async {
        String url;
        String thumbnailUrl;
        switch (note[C.TYPE]) {
          case E.IMAGE:
            url = await uploadImage(note[C.FILE]);
            thumbnailUrl = await uploadImageThumbnail(note[C.THUMBNAIL]);
            break;
          case E.PDF:
            url = await uploadPdf(note[C.FILE]);
            thumbnailUrl = await uploadPdfThumbnail(note[C.THUMBNAIL]);
            break;
        }
        controller.increaseUpload();
        switch (note[C.TYPE]) {
          case E.IMAGE:
          case E.PDF:
          case E.VIDEO:
            return {
              C.MEDIA: {
                C.TITLE: note[C.TITLE],
                C.TYPE: note[C.TYPE],
                C.URL: url,
                C.THUMBNAIL_URL: thumbnailUrl,
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
      RecentlyUsedController.to.setLastUsedSubjects(subjects.toList());
      Get.back();
      if (note != null) Get.back();
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
    setState(() {
      _loading = true;
    });
    var newNotes = await showApnaFilePicker(true);
    setState(() {
      _loading = false;
      if (newNotes == null) return;
      notes.addAll(newNotes);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.ADD_NOTES.tr),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: save)],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title of the Notes
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: S.ENTER_NOTES_TITLE.tr),
                      validator: validTitle,
                      onSaved: (value) => notesData[C.TITLE] = value,
                      maxLength: 30,
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
                      defaultValue: E.PUBLIC,
                      onChange: onChangePrivacy,
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  ]..addAll(notes
                      .asMap()
                      .map(
                        (i, e) => MapEntry(
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
                        ),
                      )
                      .values),
                ),
                if (_loading) LinearProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
