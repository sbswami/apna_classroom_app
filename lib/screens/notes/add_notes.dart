import 'dart:async';
import 'dart:io';

import 'package:apna_classroom_app/api/notes.dart';
import 'package:apna_classroom_app/api/storage.dart';
import 'package:apna_classroom_app/components/buttons/flat_icon_text_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/chips/wrap_action_chips.dart';
import 'package:apna_classroom_app/components/chips/wrap_chips.dart';
import 'package:apna_classroom_app/components/dialogs/upload_dialog.dart';
import 'package:apna_classroom_app/components/editor/text_editor.dart';
import 'package:apna_classroom_app/components/editor/text_viewer.dart';
import 'package:apna_classroom_app/components/radio/radio_group.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/image_viewer/image_viewer.dart';
import 'package:apna_classroom_app/screens/notes/widgets/note_view.dart';
import 'package:apna_classroom_app/screens/pdf_viewer/pdf_viewer.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as ImageLib;

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
  Set<String> subjects = {};
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
  addSubject(String value) {
    value = value.trim();
    if (value.isNotEmpty) {
      setState(() {
        subjects.add(value);
        RecentlyUsedController.to.addSubject(value);
      });
    }
    subjectController.clear();
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
  /// Notes list can contains Text, PDF, IMAGE, MP4
  /// The Map has key
  /// 1. index -> the position in the list -> is list index
  /// 2. text
  /// 3. thumbnail
  /// 4. File pdf, image, mp4
  /// 5. type -> TEXT, PDF, IMAGE, MP4
  /// 6. title: file Names + text filt 20 latters
  ///
  getNotesFromEditor({List<Map<String, dynamic>> list, int index}) async {
    // https://github.com/neuencer/Flutter_Medium_Text_Editor
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
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg'],
        allowCompression: true,
        allowMultiple: false,
      );
      if (result == null) return;
      setState(() {
        _loading = true;
      });
      var newNotes = await Future.wait(result.files.map((single) async {
        String _filePath = single.path;
        switch (single.extension) {
          case 'pdf':
            File thumbnailImage = await getPdfCoverImage(path: _filePath);
            File pdfFile = await saveToDevice(
                path: PDF_PATH, file: File(_filePath), extension: '.pdf');
            return {
              C.TYPE: E.PDF,
              C.FILE: pdfFile,
              C.THUMBNAIL: thumbnailImage,
              C.TITLE: removeExtension(single.name)
            };
          case 'jpg':
            ImageLib.Image thumbnail = await compressImage(path: _filePath);
            File thumbnailImage = await saveToDevice(
              path: IMAGE_THUMBNAIL_PATH,
              bytes: ImageLib.encodePng(thumbnail),
              extension: '.png',
            );
            File image = await saveToDevice(
                path: IMAGE_PATH, file: File(_filePath), extension: '.jpg');
            return {
              C.TYPE: E.IMAGE,
              C.FILE: image,
              C.THUMBNAIL: thumbnailImage,
              C.TITLE: removeExtension(single.name)
            };
            break;
          case 'mp4':
            break;
        }
      }).toList());

      setState(() {
        notes.addAll(newNotes);
      });
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  onCardTap(int index, Map<String, dynamic> note) {
    switch (note[C.TYPE]) {
      case E.TEXT:
        Get.to(TextViewer(text: note));
        // getNotesFromEditor(list: note[C.TEXT], index: index);
        break;
      case E.IMAGE:
        Get.to(ImageViewer(image: note[C.FILE]));
        break;
      case E.PDF:
        Get.to(PdfViewer(pdf: note[C.FILE]));
        break;
    }
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
    Set<String> subjectSuggestions =
        RecentlyUsedController.to.subjects.toSet().difference(subjects);
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
                    ),
                    SizedBox(height: 8),
                    // Add Subjects list
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: subjectController,
                            decoration: InputDecoration(
                              labelText: S.ENTER_SUBJECT.tr,
                              errorText: subjectError,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        SecondaryButton(
                          onPress: () => addSubject(subjectController.text),
                          iconData: Icons.add,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    WrapChips(list: subjects, onDeleted: removeSubject),
                    Divider(),
                    if (RecentlyUsedController.to.lastUsedSubjects.length != 0)
                      TextButton(
                        onPressed: addAllLastUsed,
                        child: Text(S.ADD_ALL_LAST_USED.tr),
                      ),
                    WrapActionChips(
                      list: subjectSuggestions.take(5).toSet(),
                      onAction: addSubject,
                      actionIcon: Icons.add,
                    ),
                    RadioGroup(
                      margin: const EdgeInsets.all(0.0),
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
                            onTap: () => onCardTap(i, e),
                            onChangeTitle: (title) => onChangeTitle(i, title),
                            onDelete: () => onNoteDelete(i),
                            onNoteMove: (AxisDirection direction, bool end) =>
                                onNoteMove(i, direction, end),
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
