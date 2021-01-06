import 'package:apna_classroom_app/api/exam.dart';
import 'package:apna_classroom_app/components/apna_menu.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/cards/input_card.dart';
import 'package:apna_classroom_app/components/labeled_check_box.dart';
import 'package:apna_classroom_app/components/menu_item.dart';
import 'package:apna_classroom_app/components/radio/radio_group.dart';
import 'package:apna_classroom_app/components/tags/exam_tag_input.dart';
import 'package:apna_classroom_app/components/tags/subject_tag_input.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/quiz/question/question_picker.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/question_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddExam extends StatefulWidget {
  final List questions;

  const AddExam({Key key, this.questions}) : super(key: key);
  @override
  _AddExamState createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {
  // Constants
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};

  // Init State
  @override
  void initState() {
    formData[C.MINUS_MARKING] = false;
    formData[C.DIFFICULTY] = E.NORMAL;
    formData[C.PRIVACY] = E.PUBLIC;
    if (widget.questions != null) {
      questions = widget.questions;
    }
    super.initState();
  }

  // Save
  save() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();

      if (questions.length < 1) {
        return setState(() {
          questionError = S.PLEASE_ADD_AT_LEAST_1_QUESTION.tr;
        });
      }
      questionError = null;
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

      int questionsLength = questions.length;

      var questionList = questions.map((question) {
        Map<String, dynamic> _question = {
          C.QUESTION: question[C.ID],
          C.SOLVING_TIME: question[C.SOLVING_TIME],
          C.MARKS: question[C.MARKS],
        };
        if (!isSolvingTimeCalculated) {
          int solvingTime = formData[C.SOLVING_TIME] ~/ questionsLength;
          _question[C.SOLVING_TIME] = solvingTime;
        }
        if (!isMarksCalculated) {
          int marks = formData[C.MARKS] ~/ questionsLength;
          _question[C.MARKS] = marks;
        }
        return _question;
      }).toList();

      if (!isSolvingTimeCalculated) {
        formData[C.SOLVING_TIME] =
            questionList.fold(0, (previousValue, element) {
          return element[C.SOLVING_TIME] + previousValue;
        });
      }
      if (!isMarksCalculated) {
        formData[C.MARKS] = questionList.fold(0, (previousValue, element) {
          return element[C.MARKS] + previousValue;
        });
      }

      formData[C.QUESTION] = questionList;
      formData[C.EXAM] = exams.toList();
      formData[C.SUBJECT] = subjects.toList();

      var exam = await createExam(formData);
      RecentlyUsedController.to.setLastUsedSubjects(subjects.toList());
      RecentlyUsedController.to.setLastUsedExams(exams.toList());
      if (exam != null) Get.back();
    }
  }

  // Add Question
  List questions = [];
  String questionError;
  addQuestion() async {
    var result = await Get.to(
      QuestionPicker(
        selectedQuestion:
            questions.map<String>((e) => e[C.ID].toString()).toList(),
      ),
    );
    if (result == null) return;
    setState(() {
      questions = result;
      isSolvingTimeCalculated = true;
      isMarksCalculated = true;
      if (questions.length > 0) questionError = null;
    });
    setTotalSolvingTime();
    setTotalMarks();
  }

  onLongPressQuestion(BuildContext context, question) {
    showApnaMenu(context, [
      MenuItem(
        iconData: Icons.delete,
        text: S.DELETE.tr,
        onTap: () {
          Get.back();
          setState(() {
            questions.remove(question);
          });
          setTotalSolvingTime();
          setTotalMarks();
        },
      )
    ]);
  }

  // Solving Time
  final TextEditingController solvingTimeController = TextEditingController();
  bool isSolvingTimeCalculated = true;
  int solvingTimeCalculated;
  setTotalSolvingTime() {
    isSolvingTimeCalculated = true;
    setState(() {
      int totalSolvingTime = questions.fold(0, (previousValue, element) {
        if (element[C.SOLVING_TIME] == null) {
          isSolvingTimeCalculated = false;
          return previousValue;
        }
        return previousValue + element[C.SOLVING_TIME];
      });
      solvingTimeCalculated = getMinute(totalSolvingTime);
      solvingTimeController.text = getMinute(totalSolvingTime).toString();
    });
  }

  onChangeSolvingTime(String value) {
    bool isIt = int.parse(value) == solvingTimeCalculated;
    if (isSolvingTimeCalculated != isIt) {
      setState(() {
        isSolvingTimeCalculated = isIt;
      });
    }
  }

  saveSolvingTime(String value) {
    if (value.isEmpty || int.parse(value) == 0)
      return formData.remove(C.SOLVING_TIME);

    formData[C.SOLVING_TIME] = int.parse(value) * 60;
  }

  // Marks
  final TextEditingController marksController = TextEditingController();
  bool isMarksCalculated = true;
  int marksCalculated;
  setTotalMarks() {
    isMarksCalculated = true;
    int totalMarks = questions.fold(0, (previousValue, element) {
      if (element[C.MARKS] == null) {
        isMarksCalculated = false;
        return previousValue;
      }
      return previousValue + element[C.MARKS];
    });
    marksCalculated = totalMarks;
    marksController.text = totalMarks.toString();
    setState(() {});
  }

  onChangeMarks(String value) {
    bool isIt = int.parse(value) == marksCalculated;
    if (isMarksCalculated != isIt) {
      setState(() {
        isMarksCalculated = isIt;
      });
    }
  }

  saveMarks(String value) {
    if (value.isEmpty || int.parse(value) == 0) return formData.remove(C.MARKS);
    formData[C.MARKS] = int.parse(value);
  }

  // Minus marking
  onChangeMinusMarking(bool checked) {
    setState(() {
      formData[C.MINUS_MARKING] = checked;
      formData.remove(C.MINUS_MARKING_PER_QUESTION);
    });
  }

  // Difficulty Level
  onChooseDifficultyLevel(String value) {
    formData[C.DIFFICULTY] = value;
  }

  onChoosePrivacy(String value) {
    formData[C.PRIVACY] = value;
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

  // Save Optional Field
  onSaved(String key, String value) {
    if (value.isEmpty) return formData.remove(key);
    formData[key] = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.ADD_EXAM.tr),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: save)],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: S.EXAM_TITLE.tr,
                      ),
                      validator: validTitle,
                      maxLength: 100,
                      onSaved: (value) => formData[C.TITLE] = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: S.EXAM_INSTRUCTION.tr,
                      ),
                      maxLength: 1000,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onSaved: (value) => onSaved(C.INSTRUCTION, value),
                    ),
                    Row(
                      children: [
                        SecondaryButton(
                          onPress: addQuestion,
                          text: S.PLUS_QUESTION.tr,
                        ),
                      ],
                    ),
                    Text('${questions.length} ${S.QUESTION_ADDED.tr}'),
                    if (questionError != null)
                      Text(
                        questionError,
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                children: questions
                    .map(
                      (e) => QuestionCard(
                        question: e,
                        onLongPress: ({BuildContext context}) =>
                            onLongPressQuestion(context, e),
                      ),
                    )
                    .toList(),
              ),
              LabeledCheckBox(
                checked: formData[C.MINUS_MARKING],
                text: S.MINUS_MARKING.tr,
                onChanged: onChangeMinusMarking,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    if (formData[C.MINUS_MARKING])
                      TextFormField(
                        key: Key(C.MINUS_MARKING),
                        decoration: InputDecoration(
                            labelText: S.MINUS_MARKS_PER_QUESTION.tr),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter(new RegExp('[0-9]'),
                              allow: true)
                        ],
                        maxLength: 3,
                        validator: validRequired,
                        onSaved: (value) =>
                            formData[C.MINUS_MARKING_PER_QUESTION] = value,
                      ),
                    TextFormField(
                      controller: solvingTimeController,
                      decoration: InputDecoration(
                        labelText: S.EXAM_SOLVING_TIME.tr,
                        hintText: S.MINUTE.tr,
                        helperText: isSolvingTimeCalculated
                            ? null
                            : S.SOLVING_TIME_HELPER_TEXT.tr,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter(new RegExp('[0-9]'),
                            allow: true)
                      ],
                      maxLength: 3,
                      onChanged: onChangeSolvingTime,
                      validator: validRequired,
                      onSaved: saveSolvingTime,
                    ),
                    TextFormField(
                      controller: marksController,
                      decoration: InputDecoration(
                        labelText: S.EXAM_MARKS.tr,
                        helperText: isMarksCalculated
                            ? null
                            : S.EXAM_MARKS_HELPER_TEXT.tr,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter(new RegExp('[0-9]'),
                            allow: true)
                      ],
                      maxLength: 3,
                      onChanged: onChangeMarks,
                      validator: validRequired,
                      onSaved: saveMarks,
                    ),
                    // Exam Tags
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
                    InputCard(
                      title: S.EXAM_PRIVACY.tr,
                      child: RadioGroup(
                        list: {
                          E.PUBLIC: S.PUBLIC.tr,
                          E.PRIVATE: S.PRIVATE.tr,
                        },
                        isVertical: true,
                        defaultValue: formData[C.PRIVACY],
                        onChange: onChoosePrivacy,
                      ),
                    ),
                    InputCard(
                      title: S.DIFFICULTY_LEVEL.tr,
                      child: RadioGroup(
                        list: {
                          E.EASY: S.EASY.tr,
                          E.NORMAL: S.NORMAL.tr,
                          E.HARD: S.HARD.tr,
                        },
                        isVertical: true,
                        defaultValue: formData[C.DIFFICULTY],
                        onChange: onChooseDifficultyLevel,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
