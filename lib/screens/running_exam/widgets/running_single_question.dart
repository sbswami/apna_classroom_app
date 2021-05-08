import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/solved_exam.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/editor/text_viewer.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/media/media_helper.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/option_check_box.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/question_image.dart';
import 'package:apna_classroom_app/screens/running_exam/controller/running_exam_controller.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RunningSingleQuestion extends StatefulWidget {
  final bool showOnly;
  final int questionsLength;
  final Function onNext;
  final Function onPrev;
  final answerObj;
  final int index;
  final bool showSolutionAndAnswer;

  const RunningSingleQuestion({
    Key key,
    this.questionsLength,
    this.onNext,
    this.onPrev,
    this.answerObj,
    this.index,
    this.showOnly,
    this.showSolutionAndAnswer,
  }) : super(key: key);

  // On Submit update the question in controller in answer list
  // Call updateOneAnswer(index, answer);
  // On submit send a api request to add answer in solved exam object

  @override
  _RunningSingleQuestionState createState() => _RunningSingleQuestionState();
}

class _RunningSingleQuestionState extends State<RunningSingleQuestion>
    with AutomaticKeepAliveClientMixin<RunningSingleQuestion> {
  var _question;
  int correctOptionRadioValue;
  List<int> correctOptions = [];
  final TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    _question = widget.answerObj[C.QUESTION];
    correctOptionRadioValue =
        _question[C.OPTION].indexWhere((element) => element[C.CORRECT] == true);
    _question[C.OPTION].asMap().forEach((key, value) {
      if (value[C.CORRECT]) {
        correctOptions.add(key);
      }
    });
    if (widget.answerObj[C.CORRECT] != null) {
      answerSubmitted = true;
      isCorrectAnswer = widget.answerObj[C.CORRECT];
      switch (_question[C.ANSWER_TYPE]) {
        case E.SINGLE_CHOICE:
          if (widget.answerObj[C.ANSWER].take(1).isNotEmpty) {
            optionGroupValue = _question[C.OPTION].indexWhere(
                (element) => element[C.ID] == widget.answerObj[C.ANSWER].first);
          }
          break;
        case E.MULTI_CHOICE:
          widget.answerObj[C.ANSWER].forEach((element) {
            selectedOptions.add(_question[C.OPTION]
                .indexWhere((option) => option[C.ID] == element));
          });
          break;
        case E.DIRECT_ANSWER:
          answerController.text = widget.answerObj[C.ANSWER];
          break;
      }
    }
    super.initState();
  }

  // Submit Answer
  bool answerSubmitted = false;
  bool isCorrectAnswer = false;
  submit() async {
    if (answerSubmitted) return;
    var _answer;
    switch (_question[C.ANSWER_TYPE]) {
      case E.SINGLE_CHOICE:
        if (optionGroupValue == null) {
          return ok(
              title: S.SUBMIT.tr,
              msg: S.PLEASE_SELECT_ANSWER_AND_THEN_SUBMIT.tr);
        }
        isCorrectAnswer = correctOptionRadioValue == optionGroupValue;
        _answer = [];
        _answer.add(_question[C.OPTION][optionGroupValue][C.ID]);
        break;
      case E.MULTI_CHOICE:
        if (selectedOptions.isEmpty) {
          return ok(
              title: S.SUBMIT.tr,
              msg: S.PLEASE_SELECT_ANSWER_AND_THEN_SUBMIT.tr);
        }
        isCorrectAnswer = correctOptions
                .every((element) => selectedOptions.contains(element)) &&
            correctOptions.length == selectedOptions.length;
        _answer = [];
        selectedOptions.forEach((element) {
          _answer.add(_question[C.OPTION][element][C.ID]);
        });
        break;
      case E.DIRECT_ANSWER:
        if (answerController.text.isEmpty) {
          return ok(
              title: S.SUBMIT.tr,
              msg: S.PLEASE_ENTER_ANSWER_AND_THEN_SUBMIT.tr);
        }
        isCorrectAnswer =
            answerController.text.toLowerCase().replaceAll(' ', '') ==
                _question[C.ANSWER].toLowerCase().replaceAll(' ', '');
        _answer = answerController.text;
        break;
    }
    await addAnswerSolvedExam({
      C.ID: RunningExamController.to.solvedExam[C.ID],
      C.ANSWER: {
        ...widget.answerObj,
        C.CORRECT: isCorrectAnswer,
        C.MARKS: isCorrectAnswer ? widget.answerObj[C.QUESTION][C.MARKS] : 0,
        C.ANSWER: _answer,
      }
    });

    setState(() {
      answerSubmitted = true;
    });
  }

  // Clear the clicks
  clear() {
    if (answerSubmitted) return;
    setState(() {
      selectedOptions = [];
      optionGroupValue = null;
      answerController.clear();
      answerSubmitted = false;
    });
  }

  // Show solution
  showSolution() async {
    if (_question[C.SOLUTION][C.MEDIA] != null) {
      showMedia(_question[C.SOLUTION][C.MEDIA]);
    } else if (_question[C.SOLUTION][C.TEXT] != null) {
      Get.to(TextViewer(text: _question[C.SOLUTION][C.TEXT]));
    }

    // Track event
    track(EventName.SHOW_SOLUTION, {EventProp.TYPE: _question[C.ANSWER_TYPE]});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            getHeaderContent(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 16.0, bottom: 128),
              child: Column(
                children: [
                  Text(
                    _question[C.TITLE],
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 16.0),
                  Wrap(
                    children: _question[C.MEDIA]
                        .map<Widget>(
                            (media) => QuestionImage(questionImage: media))
                        .toList(),
                  ),
                  SizedBox(height: 16.0),
                  getOptionList(),
                  if (_question[C.ANSWER_TYPE] == E.DIRECT_ANSWER)
                    TextField(
                      controller: answerController,
                      decoration: InputDecoration(
                        labelText: S.ENTER_ANSWER.tr,
                        hintText: _question[C.ANSWER_FORMAT],
                      ),
                      enabled: !answerSubmitted,
                    ),
                  getCorrectAnswer(),
                  if (answerSubmitted &&
                      (_question[C.SOLUTION] != null) &&
                      widget.showSolutionAndAnswer)
                    SecondaryButton(
                      text: S.SHOW_SOLUTION.tr,
                      onPress: showSolution,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(0, 7),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_question[C.ANSWER_HINT] != null)
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  ),
                  SizedBox(width: 8.0),
                  SelectableText(
                    _question[C.ANSWER_HINT],
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            if (_question[C.ANSWER_HINT] != null) Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.index != 0)
                  IconButton(
                    icon: Icon(Icons.navigate_before_rounded),
                    onPressed: widget.onPrev,
                    iconSize: 32.0,
                    color: Theme.of(context).primaryColor,
                  )
                else
                  SizedBox(width: 48),
                if (!(widget.showOnly ?? false))
                  SecondaryButton(
                    destructive: true,
                    text: S.CLEAR.tr,
                    onPress: clear,
                  )
                else if (widget.questionsLength > 1)
                  Text(S.SWITCH_QUESTIONS.tr),
                if (!(widget.showOnly ?? false))
                  PrimaryButton(
                    text: S.SUBMIT.tr,
                    onPress: submit,
                  ),
                if (widget.questionsLength - 1 != widget.index)
                  IconButton(
                    icon: Icon(Icons.navigate_next_rounded),
                    onPressed: widget.onNext,
                    iconSize: 32.0,
                    color: Theme.of(context).primaryColor,
                  )
                else
                  SizedBox(width: 48),
              ],
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  // Options Game
  List<int> selectedOptions = [];
  int optionGroupValue;

  onCheckOption(key, bool checked) {
    setState(() {
      if (checked) {
        selectedOptions.add(key);
      } else {
        selectedOptions.remove(key);
      }
    });
  }

  onChangeRadioOption(int value) {
    setState(() {
      optionGroupValue = value;
    });
  }

  Widget getOptionList() {
    if (_question[C.ANSWER_TYPE] == E.SINGLE_CHOICE ||
        _question[C.ANSWER_TYPE] == E.MULTI_CHOICE) {
      var children = _question[C.OPTION]
          .asMap()
          .map(
            (key, option) {
              int groupValue = optionGroupValue;
              Color color;
              bool checked = selectedOptions.contains(key);

              if (answerSubmitted && widget.showSolutionAndAnswer) {
                if (_question[C.ANSWER_TYPE] == E.SINGLE_CHOICE) {
                  if (key == correctOptionRadioValue) {
                    color = Colors.green;
                  } else if (optionGroupValue == key) {
                    color = Colors.red;
                  }
                  if (correctOptionRadioValue != null &&
                      key == correctOptionRadioValue) {
                    groupValue = correctOptionRadioValue;
                  }
                } else if (_question[C.ANSWER_TYPE] == E.MULTI_CHOICE) {
                  if (correctOptions.contains(key)) {
                    color = Colors.green;
                    checked = true;
                  } else if (selectedOptions.contains(key)) {
                    color = Colors.red;
                    checked = true;
                  }
                }
              }
              return MapEntry(
                key,
                OptionCheckBox(
                  checked: checked,
                  onChanged: (checked) => onCheckOption(key, checked),
                  groupValue: groupValue,
                  valueRadio: key,
                  onChangeRadio: (int radio) => onChangeRadioOption(radio),
                  text: option[C.TEXT],
                  isCheckBox: _question[C.ANSWER_TYPE] == E.MULTI_CHOICE,
                  url: (option[C.MEDIA] ?? {})[C.URL],
                  color: color,
                  isEditable: !answerSubmitted,
                ),
              );
            },
          )
          .values
          .toList();
      return Column(
        children: children.cast<Widget>(),
      );
    }
    return SizedBox.shrink();
  }

  Widget getCorrectAnswer() {
    if (_question[C.ANSWER_TYPE] == E.DIRECT_ANSWER &&
        answerSubmitted &&
        widget.showSolutionAndAnswer) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Text(
              '${S.CORRECT_ANSWER_IS.tr}: ',
            ),
            SelectableText(
              _question[C.ANSWER] ?? '',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget getHeaderContent() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            spreadRadius: 0.1,
            offset: Offset(0, 0.2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${S.MARKS.tr}: ${widget.answerObj[C.QUESTION][C.MARKS]}'),
              Text(getMinuteSt(widget.answerObj[C.QUESTION][C.SOLVING_TIME]))
            ],
          ),
          if (answerSubmitted && widget.showSolutionAndAnswer) Divider(),
          if (answerSubmitted && widget.showSolutionAndAnswer)
            Text(
              isCorrectAnswer
                  ? S.YOU_SUBMITTED_CORRECT_ANSWER.tr
                  : S.YOU_SUBMITTED_WRONG_ANSWER.tr,
              style: TextStyle(
                color: isCorrectAnswer ? Colors.green : Colors.red,
              ),
            )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
