import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/question.dart';
import 'package:apna_classroom_app/api/storage/storage_api.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/components/buttons/flat_icon_text_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/cards/input_card.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/editor/text_editor.dart';
import 'package:apna_classroom_app/components/radio/radio_group.dart';
import 'package:apna_classroom_app/components/tags/exam_tag_input.dart';
import 'package:apna_classroom_app/components/tags/subject_tag_input.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/media/media_picker/media_picker.dart';
import 'package:apna_classroom_app/screens/notes/widgets/note_view.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/enter_option_bar.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/option_check_box.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/question_image.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddQuestion extends StatefulWidget {
  final question;

  const AddQuestion({Key key, this.question}) : super(key: key);
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  // Constants
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};

  @override
  void initState() {
    formData[C.ANSWER_TYPE] = E.SINGLE_CHOICE;
    if (widget.question != null) {
      formData = {
        C.ID: widget.question[C.ID],
        C.TITLE: widget.question[C.TITLE],
        C.ANSWER_TYPE: widget.question[C.ANSWER_TYPE],
        C.ANSWER: widget.question[C.ANSWER],
        C.ANSWER_FORMAT: widget.question[C.ANSWER_FORMAT],
        C.ANSWER_HINT: widget.question[C.ANSWER_HINT],
        C.SOLVING_TIME: widget.question[C.SOLVING_TIME],
        C.MARKS: widget.question[C.MARKS],
        C.DIFFICULTY: widget.question[C.DIFFICULTY],
      };

      subjects = widget.question[C.SUBJECT].cast<String>().toSet();
      exams = widget.question[C.EXAM].cast<String>().toSet();
      images = widget.question[C.MEDIA].cast<Map<String, dynamic>>() ?? [];
      options = widget.question[C.OPTION].cast<Map<String, dynamic>>();
      optionGroupValue =
          options.indexWhere((element) => element[C.CORRECT] == true);
      if (widget.question[C.SOLUTION] != null) {
        showAddSolution = true;
        var _solution = widget.question[C.SOLUTION];
        if (_solution[C.MEDIA] != null) {
          var media = _solution[C.MEDIA];
          solution = {
            C.ID: media[C.ID],
            C.TYPE: media[C.TYPE],
            C.TITLE: media[C.TITLE],
            C.URL: media[C.URL],
          };
        }
        if (_solution[C.TEXT] != null) {
          var text = _solution[C.TEXT];
          solution = {
            C.ID: text[C.ID],
            C.TEXT: text[C.TEXT].cast<Map<String, dynamic>>(),
            C.TYPE: E.TEXT,
            C.TITLE: text[C.TITLE]
          };
        }
      }
    }
    super.initState();

    // Track Screen
    trackScreen(ScreenNames.AddQuestion);
  }

  // Save
  save() async {
    var form = formKey.currentState;
    if (form.validate()) {
      if (images.any((element) => element[C.TITLE].toString().isEmpty)) return;
      if (formData[C.ANSWER_TYPE] == E.SINGLE_CHOICE ||
          formData[C.ANSWER_TYPE] == E.MULTI_CHOICE) {
        if (options.length < 2) {
          setState(() {
            optionError = S.PLEASE_ADD_AT_LEAST_OPTIONS.tr;
          });
          return optionFocusNode.requestFocus();
        }
        if (!options.any((element) => element[C.CORRECT])) {
          return setState(() {
            optionError = S.PLEASE_SELECT_CORRECT_ANSWER.tr;
          });
        }
      }
      optionError = null;
      if (exams.isEmpty) {
        setState(() {
          examError = S.ADD_AT_LEAST_ONE_EXAM.tr;
        });
        return examFocusNode.requestFocus();
      }
      examError = null;
      if (subjects.isEmpty) {
        setState(() {
          subjectError = S.ADD_AT_LEAST_ONE_SUBJECT.tr;
        });
        return subjectFocusNode.requestFocus();
      }
      setState(() {
        subjectError = null;
      });

      if (widget.question != null) {
        var result = await wantToEdit(() => true, S.QUESTION_EDIT_NOTE.tr);
        if (!(result ?? false)) return;
      }

      formData[C.EXAM] = exams.toList();
      formData[C.SUBJECT] = subjects.toList();

      form.save();

      int totalUploads = images.length +
          options.where((element) => element[C.MEDIA] != null).length;
      if (solution != null && solution[C.TYPE] != E.TEXT) {
        totalUploads++;
      }

      showProgress();
      List media = await Future.wait(images.map((image) async {
        if (image[C.ID] != null) {
          return {
            C.ID: image[C.ID],
            C.TYPE: image[C.TYPE],
            C.TITLE: image[C.TITLE],
            C.URL: image[C.URL],
          };
        }

        var storageResponse = await uploadToStorage(
          file: image[C.FILE],
          type: FileType.IMAGE,
          thumbnail: image[C.THUMBNAIL],
        );
        String url = storageResponse[StorageConstant.PATH];

        return {
          C.TYPE: image[C.TYPE],
          C.TITLE: image[C.TITLE],
          C.URL: url,
        };
      }));
      formData[C.MEDIA] = media;
      List optionList = await Future.wait(options.map((option) async {
        if (option[C.TEXT] != null) return option;
        if (option[C.ID] != null || option[C.MEDIA][C.ID] != null) {
          return {
            C.MEDIA: {
              C.ID: option[C.MEDIA][C.ID],
              C.TYPE: option[C.MEDIA][C.TYPE],
              C.TITLE: option[C.MEDIA][C.TITLE],
              C.URL: option[C.MEDIA][C.URL],
            },
            C.CORRECT: option[C.CORRECT],
          };
        }
        var storageResponse = await uploadToStorage(
          file: option[C.MEDIA][C.FILE],
          type: FileType.IMAGE,
          thumbnail: option[C.MEDIA][C.THUMBNAIL],
        );
        String url = storageResponse[StorageConstant.PATH];

        return {
          C.MEDIA: {
            C.TYPE: option[C.MEDIA][C.TYPE],
            C.TITLE: option[C.MEDIA][C.TITLE],
            C.URL: url,
          },
          C.CORRECT: option[C.CORRECT],
        };
      }));
      formData[C.OPTION] = optionList;

      if (solution != null) {
        if (solution[C.ID] != null) {
          if (solution[C.TYPE] == E.TEXT) {
            formData[C.SOLUTION] = {
              C.TEXT: {
                C.ID: solution[C.ID],
                C.TITLE: solution[C.TITLE],
                C.TEXT: solution[C.TEXT],
              }
            };
          }

          formData[C.SOLUTION] = {
            C.MEDIA: {
              C.ID: solution[C.ID],
              C.TITLE: solution[C.TITLE],
              C.TYPE: solution[C.TYPE],
              C.URL: solution[C.URL],
            }
          };
        } else {
          if (solution[C.TYPE] == E.TEXT) {
            formData[C.SOLUTION] = {
              C.TEXT: {C.TEXT: solution[C.TEXT], C.TITLE: solution[C.TITLE]},
            };
          } else {
            String url;
            switch (solution[C.TYPE]) {
              case E.IMAGE:
                var storageResponse = await uploadToStorage(
                  file: solution[C.FILE],
                  type: FileType.IMAGE,
                  thumbnail: solution[C.THUMBNAIL],
                );
                url = storageResponse[StorageConstant.PATH];
                break;
              case E.PDF:
                var storageResponse = await uploadToStorage(
                  file: solution[C.FILE],
                  type: FileType.DOC,
                  thumbnail: solution[C.THUMBNAIL],
                );
                url = storageResponse[StorageConstant.PATH];
                break;
              case E.VIDEO:
                var storageResponse = await uploadToStorage(
                  file: solution[C.FILE],
                  type: FileType.VIDEO,
                  thumbnail: solution[C.THUMBNAIL],
                );
                url = storageResponse[StorageConstant.PATH];
                break;
            }

            formData[C.SOLUTION] = {
              C.MEDIA: {
                C.TITLE: solution[C.TITLE],
                C.TYPE: solution[C.TYPE],
                C.URL: url,
              }
            };
          }
        }
      }

      var question = await createQuestion(formData);

      // Track Event add question
      track(EventName.ADD_QUESTION, {
        EventProp.TYPE: formData[C.ANSWER_TYPE],
        EventProp.IMAGE: images?.length,
        EventProp.SUBJECTS: subjects,
        EventProp.EXAMS: exams,
        EventProp.MARKS: formData[C.MARKS],
        EventProp.SOLVING_TIME: formData[C.SOLVING_TIME],
        EventProp.IS_HINT: formData[C.ANSWER_HINT] != null,
        EventProp.IS_SOLUTION: solution != null,
        EventProp.SOLUTION_TYPE: (solution ?? {})[C.TYPE],
        EventProp.EDIT: widget.question != null,
      });

      RecentlyUsedController.to.setLastUsedSubjects(subjects.toList());
      RecentlyUsedController.to.setLastUsedExams(exams.toList());
      Get.back();
      if (question != null) Get.back(result: true);
    }
  }

  // Add Image to question
  List<Map<String, dynamic>> images = [];
  addImageToQuestion() async {
    var result = await showApnaMediaPicker(true);
    if (result == null) return;
    setState(() {
      images.add(result);
    });
  }

  onImageTitleChange(int index, String value) {
    images[index][C.TITLE] = value;
  }

  onRemoveImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  // On choose answer type
  onChooseAnswerType(String value) {
    setState(() {
      formData[C.ANSWER_TYPE] = value;
      optionGroupValue = null;
      options = options.map((e) {
        e[C.CORRECT] = false;
        return e;
      }).toList();
      formData.remove(C.ANSWER);
      formData.remove(C.ANSWER_FORMAT);
    });
  }

  // Option List
  List<Map<String, dynamic>> options = [];
  String optionError;
  TextEditingController optionTextController = TextEditingController();
  FocusNode optionFocusNode = FocusNode();
  int optionGroupValue;
  addNewOption({Map<String, dynamic> media, String text}) {
    Map<String, dynamic> option = {C.CORRECT: false};
    if (text != null) option[C.TEXT] = text;
    if (media != null) option[C.MEDIA] = media;
    setState(() {
      options.add(option);
      if (optionError != null) optionError = null;
    });
  }

  addOptionImage() async {
    var result = await showApnaMediaPicker(true);
    if (result == null) return;
    setState(() {
      addNewOption(media: result);
    });
  }

  addTextOption() {
    String option = optionTextController.text;
    if (option.isEmpty) return;
    addNewOption(text: option);
    optionTextController.clear();
  }

  onCheckOption(int index, bool value) {
    setState(() {
      options[index][C.CORRECT] = value;
      optionError = null;
    });
  }

  onDelete(int index) {
    setState(() {
      options.removeAt(index);
    });
  }

  onChangeRadioOption(int value) {
    setState(() {
      options = options.map((e) {
        e[C.CORRECT] = false;
        return e;
      }).toList();
      options[value][C.CORRECT] = true;
      optionGroupValue = value;
      optionError = null;
    });
  }

  // Save Optional Field
  onSaved(String key, String value) {
    if (value.isEmpty) return formData.remove(key);
    formData[key] = value;
  }

  // Solving Time
  saveSolvingTime(String value) {
    if (value.isEmpty || int.parse(value) == 0)
      return formData.remove(C.SOLVING_TIME);

    formData[C.SOLVING_TIME] = int.parse(value) * 60;
  }

  // Marks
  saveMarks(String value) {
    if (value.isEmpty || int.parse(value) == 0) return formData.remove(C.MARKS);
    formData[C.MARKS] = int.parse(value);
  }

  // Subjects Tag
  Set<String> subjects = {};
  String subjectError;
  TextEditingController subjectController = TextEditingController();
  FocusNode subjectFocusNode = FocusNode();
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

  // Exams Tag
  Set<String> exams = {};
  String examError;
  TextEditingController examController = TextEditingController();
  FocusNode examFocusNode = FocusNode();
  addExam(String value) {
    setState(() {
      exams.add(value);
    });
  }

  removeExam(String value) {
    setState(() {
      exams.remove(value);
    });
  }

  addAllLastUsedExam() {
    setState(() {
      exams.addAll(RecentlyUsedController.to.lastUsedExams);
    });
  }

  // Add Solution
  bool showAddSolution = false;
  Map<String, dynamic> solution;
  getSolutionFromEditor({List<Map<String, dynamic>> list}) async {
    var data = await Get.to(TextEditor(
      data: list,
    ));
    if (data == null) return;
    setState(() {
      solution = {C.TEXT: data, C.TYPE: E.TEXT};
    });
  }

  getSolutionFromFile() async {
    var result = await showApnaMediaPicker(false);
    if (result == null) return;
    setState(() {
      solution = result.first;
    });
  }

  // On Back
  Future<bool> _onBack() async {
    var result = await wantToDiscard(() => true, S.QUESTION_DISCARD.tr);
    return (result ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.ADD_QUESTION.tr),
          actions: [IconButton(icon: Icon(Icons.check), onPressed: save)],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    key: Key('Hi'),
                    initialValue: formData[C.TITLE],
                    decoration: InputDecoration(labelText: S.QUESTION.tr),
                    validator: validQuestion,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onSaved: (String value) => formData[C.TITLE] = value,
                    maxLength: 500,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: SecondaryButton(
                      text: S.ADD_IMAGE.tr,
                      onPress: addImageToQuestion,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Wrap(
                    children: images
                        .asMap()
                        .map(
                          (index, value) => MapEntry(
                            index,
                            QuestionImage(
                              questionImage: value,
                              onChangeName: (title) =>
                                  onImageTitleChange(index, title),
                              onDelete: () => onRemoveImage(index),
                              isEditable: true,
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  ),
                  SizedBox(height: 8.0),
                  InputCard(
                    title: S.ANSWER_TYPE.tr,
                    child: RadioGroup(
                      list: {
                        E.MULTI_CHOICE: S.MULTI_CHOICE.tr,
                        E.SINGLE_CHOICE: S.SINGLE_CHOICE.tr,
                        E.DIRECT_ANSWER: S.DIRECT_ANSWER.tr,
                      },
                      isVertical: true,
                      defaultValue: formData[C.ANSWER_TYPE],
                      onChange: onChooseAnswerType,
                    ),
                  ),
                  if (formData[C.ANSWER_TYPE] == E.MULTI_CHOICE ||
                      formData[C.ANSWER_TYPE] == E.SINGLE_CHOICE)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          EnterOptionBar(
                            addOptionImage: addOptionImage,
                            optionTextController: optionTextController,
                            addTextOption: addTextOption,
                            focusNode: optionFocusNode,
                          ),
                          if (optionError != null)
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    optionError,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 16.0),
                        ]..addAll(options.asMap().map(
                            (key, value) {
                              var media = value[C.MEDIA] ?? {};
                              return MapEntry(
                                key,
                                OptionCheckBox(
                                  checked: value[C.CORRECT],
                                  onChanged: (checked) =>
                                      onCheckOption(key, checked),
                                  groupValue: optionGroupValue,
                                  valueRadio: key,
                                  onChangeRadio: (int value) =>
                                      onChangeRadioOption(value),
                                  text: value[C.TEXT],
                                  url: media[C.URL],
                                  image: media[C.FILE],
                                  thumbnailImage: media[C.THUMBNAIL],
                                  onDelete: () => onDelete(key),
                                  isCheckBox:
                                      formData[C.ANSWER_TYPE] == E.MULTI_CHOICE,
                                  isEditable: true,
                                ),
                              );
                            },
                          ).values),
                      ),
                    ),
                  if (formData[C.ANSWER_TYPE] == E.DIRECT_ANSWER)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            onSaved: (String value) =>
                                formData[C.ANSWER] = value,
                            initialValue: formData[C.ANSWER],
                            validator: validAnswer,
                            decoration: InputDecoration(
                              labelText: S.ENTER_ANSWER.tr,
                            ),
                            maxLength: 500,
                          ),
                          TextFormField(
                            onSaved: (value) => onSaved(C.ANSWER_FORMAT, value),
                            initialValue: formData[C.ANSWER_FORMAT],
                            decoration: InputDecoration(
                              labelText: S.ANSWER_FORMAT.tr,
                              hintText: S.ANSWER_FORMAT_HINT.tr,
                            ),
                            maxLength: 30,
                          ),
                        ],
                      ),
                    ),
                  // Exam Tag
                  ExamTagInput(
                    exams: exams,
                    examError: examError,
                    examController: examController,
                    addExam: addExam,
                    removeExam: removeExam,
                    addAllLastUsedExam: addAllLastUsedExam,
                    focusNode: examFocusNode,
                  ),
                  // Subject Tag
                  SubjectTagInput(
                    subjects: subjects,
                    subjectError: subjectError,
                    subjectController: subjectController,
                    addSubject: addSubject,
                    removeSubject: removeSubject,
                    addAllLastUsed: addAllLastUsed,
                    focusNode: subjectFocusNode,
                  ),
                  TextFormField(
                    onSaved: (String value) => onSaved(C.ANSWER_HINT, value),
                    initialValue: formData[C.ANSWER_HINT],
                    decoration: InputDecoration(
                      labelText: S.ANSWER_HINT.tr,
                    ),
                    maxLength: 100,
                  ),
                  TextFormField(
                    initialValue:
                        '${getMinute(formData[C.SOLVING_TIME]) ?? ''}',
                    decoration: InputDecoration(
                        labelText: S.SOLVING_TIME.tr, hintText: S.MINUTE.tr),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter(new RegExp('[0-9]'),
                          allow: true)
                    ],
                    maxLength: 3,
                    onSaved: saveSolvingTime,
                  ),
                  TextFormField(
                    initialValue: '${formData[C.MARKS] ?? ''}',
                    decoration: InputDecoration(labelText: S.ENTER_MARKS.tr),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter(new RegExp('[0-9]'),
                          allow: true)
                    ],
                    maxLength: 4,
                    onSaved: saveMarks,
                  ),
                  SizedBox(height: 16.0),
                  if (!showAddSolution)
                    Row(
                      children: [
                        SecondaryButton(
                          text: S.ADD_SOLUTION.tr,
                          onPress: () {
                            setState(() {
                              showAddSolution = true;
                            });
                          },
                        ),
                      ],
                    ),
                  if (showAddSolution && solution == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FlatIconTextButton(
                          onPressed: getSolutionFromEditor,
                          iconData: Icons.edit,
                          text: S.OPEN_EDITOR.tr,
                        ),
                        FlatIconTextButton(
                          onPressed: getSolutionFromFile,
                          iconData: Icons.attach_file,
                          text: S.UPLOAD_FILE.tr,
                          note: S.ACCEPTED_FORMATS.tr,
                        )
                      ],
                    ),
                  SizedBox(height: 16),
                  Visibility(
                    child: NoteView(
                      note: solution,
                      onDelete: () {
                        setState(() {
                          solution = null;
                        });
                      },
                      onChangeTitle: (value) => solution[C.TITLE] = value,
                      onEdit: () =>
                          getSolutionFromEditor(list: solution[C.TEXT]),
                      isQuestion: true,
                    ),
                    visible: solution != null,
                  ),
                  SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
