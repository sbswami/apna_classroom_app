import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/question.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/images/labeled_image.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/notes/widgets/single_note.dart';
import 'package:apna_classroom_app/screens/quiz/question/add_question.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/option_check_box.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedQuestion extends StatefulWidget {
  final Map<String, dynamic> question;
  final bool isFromExam;
  final bool isEditable;

  const DetailedQuestion(
      {Key key, this.question, this.isFromExam, this.isEditable})
      : super(key: key);

  @override
  _DetailedQuestionState createState() => _DetailedQuestionState();
}

class _DetailedQuestionState extends State<DetailedQuestion> {
  bool isLoading = true;
  Map<String, dynamic> question;

  loadQuestion() async {
    Map<String, dynamic> _question;
    if (widget.isFromExam ?? false) {
      _question = widget.question;
    } else {
      _question = await getQuestion({C.ID: widget.question[C.ID]});
      if (_question == null) {
        _question = widget.question;
      }
    }
    setState(() {
      question = _question;
      isLoading = false;
    });

    // Track Event
    track(EventName.VIEWED_QUESTION_DETAILS, {
      EventProp.TYPE: question[C.ANSWER_TYPE],
      EventProp.IMAGE: question[C.MEDIA]?.length,
      EventProp.SUBJECTS: question[C.SUBJECT],
      EventProp.EXAMS: question[C.EXAM],
      EventProp.MARKS: question[C.MARKS],
      EventProp.SOLVING_TIME: question[C.SOLVING_TIME],
      EventProp.IS_HINT: question[C.ANSWER_HINT] != null,
      EventProp.IS_SOLUTION: question[C.SOLUTION] != null,
      EventProp.ACCESSED_FROM: (widget.isFromExam ?? false)
          ? ScreenNames.DetailedExam
          : ScreenNames.QuestionsTab,
    });
  }

  // Delete
  _onDelete() async {
    var result = await wantToDelete(() {
      return true;
    }, S.QUESTION_DELETE_NOTE.tr);
    if (!(result ?? false)) return;
    bool isDeleted = await deleteQuestion({
      C.ID: [widget.question[C.ID]], // list of ids
    });
    if (!isDeleted)
      return ok(title: S.SOMETHING_WENT_WRONG.tr, msg: S.CAN_NOT_DELETE_NOW.tr);

    // Track delete event
    track(EventName.DELETE_QUESTION, {
      EventProp.TYPE: question[C.ANSWER_TYPE],
      EventProp.SUBJECTS: question[C.SUBJECT],
      EventProp.EXAMS: question[C.EXAM],
      EventProp.ACCESSED_FROM: ScreenNames.DetailedQuestion,
    });

    Get.back(result: true);
  }

  // Edit
  bool isEdited = false;
  _onEdit() async {
    var result = await Get.to(() => AddQuestion(question: question));

    // Track screen back
    trackScreen(ScreenNames.DetailedQuestion);

    if (result != null) {
      setState(() {
        isLoading = true;
        question = null;
        isEdited = true;
      });
      loadQuestion();
    }
  }

  // On Back
  Future<bool> _onBack() async {
    Get.back(result: isEdited);
    return false;
  }

  @override
  void initState() {
    super.initState();

    // Track Screen
    trackScreen(ScreenNames.DetailedQuestion);

    loadQuestion();
  }

  @override
  Widget build(BuildContext context) {
    bool updatable = isCreator((question ?? {})[C.CREATED_BY]) &&
        (widget.isEditable ?? false);
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.QUESTION.tr),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                SelectableText(
                  (question ?? widget.question)[C.TITLE],
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(height: 8.0),
                if (isLoading)
                  DetailsSkeleton(
                    type: DetailsType.CardInfo,
                  ),
                if (!isLoading)
                  Column(
                    children: [
                      Wrap(
                        children: question[C.MEDIA]
                                ?.map<Widget>(
                                  (e) => LabeledImage(
                                    url: e[C.URL],
                                    label: e[C.TITLE],
                                  ),
                                )
                                ?.toList() ??
                            [],
                      ),
                      if (question[C.ANSWER_TYPE] == E.MULTI_CHOICE ||
                          question[C.ANSWER_TYPE] == E.SINGLE_CHOICE)
                        getOptionList(),
                      InfoCard(
                        title: S.ANSWER.tr,
                        data: question[C.ANSWER],
                      ),
                      InfoCard(
                        title: S.ANSWER_FORMAT.tr,
                        data: question[C.ANSWER_FORMAT],
                      ),
                      InfoCard(
                        title: S.ANSWER_HINT.tr,
                        data: question[C.ANSWER_HINT],
                      ),
                      if (question[C.SOLVING_TIME] != null)
                        InfoCard(
                          title: S.SOLVING_TIME.tr,
                          data: getMinuteSt(question[C.SOLVING_TIME]),
                        ),
                      InfoCard(
                        title: S.MARKS.tr,
                        data: question[C.MARKS],
                      ),
                      InfoCard(
                        title: S.EXAM.tr,
                        child:
                            GroupChips(list: question[C.EXAM].cast<String>()),
                      ),
                      InfoCard(
                        title: S.SUBJECT.tr,
                        child: GroupChips(
                            list: question[C.SUBJECT].cast<String>()),
                      ),
                      if (question[C.SOLUTION] != null)
                        SingleNote(note: question[C.SOLUTION])
                    ],
                  ),
                SizedBox(height: 16),
                if (updatable)
                  PrimaryButton(
                    destructive: true,
                    text: S.DELETE.tr,
                    onPress: _onDelete,
                  ),
                SizedBox(height: 64),
              ],
            ),
          ),
        ),
        floatingActionButton: updatable
            ? FloatingActionButton(
                onPressed: _onEdit,
                child: Icon(Icons.edit),
              )
            : null,
      ),
    );
  }

  // Designs
  Widget getOptionList() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: question[C.OPTION]
            .asMap()
            .map(
              (index, option) {
                return MapEntry(
                  index,
                  OptionCheckBox(
                    checked: option[C.CORRECT],
                    text: option[C.TEXT],
                    url: (option[C.MEDIA] ?? {})[C.URL],
                    isCheckBox: question[C.ANSWER_TYPE] == E.MULTI_CHOICE,
                    valueRadio: index,
                    groupValue: question[C.OPTION]
                        .indexWhere((element) => element[C.CORRECT] == true),
                    isEditable: false,
                  ),
                );
              },
            )
            .values
            .toList()
            .cast<Widget>(),
      ),
    );
  }
}
