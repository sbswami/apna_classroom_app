import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/exam.dart';
import 'package:apna_classroom_app/api/exam_conducted.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/share/apna_share.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/quiz/exam/add_exam.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/question_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedExam extends StatefulWidget {
  final exam;
  final isEditable;
  final examConducted;

  const DetailedExam({Key key, this.exam, this.isEditable, this.examConducted})
      : super(key: key);

  @override
  _DetailedExamState createState() => _DetailedExamState();
}

class _DetailedExamState extends State<DetailedExam> {
  bool isLoading = true;
  Map<String, dynamic> exam;

  loadExam() async {
    Map<String, dynamic> _exam;
    if (widget.examConducted != null)
      _exam = ((await getExamConducted({C.ID: widget.examConducted[C.ID]})) ??
          {})[C.EXAM];
    else
      _exam = await getExam({C.ID: widget.exam[C.ID]});

    setState(() {
      exam = _exam;
      isLoading = false;
    });
    if (_exam != null &&
        !isCreator(_exam[C.CREATED_BY]) &&
        !_exam[C.ACCESS_LIST].contains(getUserId()) &&
        _exam[C.PRIVACY] == E.PUBLIC) {
      await addToAccessListExam({C.ID: _exam[C.ID]});
    }

    // Track viewed event
    track(EventName.VIEWED_EXAM_DETAILS, {
      EventProp.QUESTION_COUNT: _exam[C.QUESTION]?.length,
      EventProp.MINUS_MARKING: _exam[C.MINUS_MARKING],
      EventProp.SOLVING_TIME: _exam[C.SOLVING_TIME],
      EventProp.MARKS: _exam[C.MARKS],
      EventProp.EXAMS: _exam[C.EXAM],
      EventProp.SUBJECTS: _exam[C.SUBJECT],
      EventProp.PRIVACY: _exam[C.PRIVACY],
      EventProp.DIFFICULTY: _exam[C.DIFFICULTY],
      EventProp.HAS_INSTRUCTION: _exam[C.INSTRUCTION] != null,
      EventProp.ACCESSED_FROM:
          widget.examConducted == null ? ScreenNames.ExamsTab : 'ExamConducted',
    });
  }

  // Delete
  _onDelete() async {
    var result = await wantToDelete(() {
      return true;
    }, S.EXAM_DELETE_NOTE.tr);
    if (!(result ?? false)) return;
    bool isDeleted = await deleteExam({
      C.ID: widget.exam[C.ID],
    });
    if (!isDeleted)
      return ok(title: S.SOMETHING_WENT_WRONG.tr, msg: S.CAN_NOT_DELETE_NOW.tr);

    // Track Delete exam
    track(EventName.DELETE_EXAM, {
      EventProp.QUESTION_COUNT: exam[C.QUESTION]?.length,
      EventProp.EXAMS: exam[C.EXAM],
      EventProp.SUBJECTS: exam[C.SUBJECT],
      EventProp.PRIVACY: exam[C.PRIVACY],
      EventProp.DIFFICULTY: exam[C.DIFFICULTY],
    });

    Get.back(result: true);
  }

  // Edit
  bool isEdited = false;
  _onEdit() async {
    var result = await Get.to(() => AddExam(
          exam: exam,
          accessedFrom: ScreenNames.DetailedExam,
        ));

    // Track screen back
    trackScreen(ScreenNames.DetailedExam);

    if (result != null) {
      setState(() {
        isLoading = true;
        exam = null;
        isEdited = true;
      });
      loadExam();
    }
  }

  @override
  void initState() {
    super.initState();

    // Track Screen
    trackScreen(ScreenNames.DetailedExam);

    loadExam();
  }

  // On Back
  Future<bool> _onBack() async {
    Get.back(result: isEdited);
    return false;
  }

  // Share exam
  _share() async {
    await externalShare(SharingContentType.Exam, exam);

    // Track share exam
    track(EventName.SHARE_EXAM, {
      EventProp.QUESTION_COUNT: exam[C.QUESTION]?.length,
      EventProp.EXAMS: exam[C.EXAM],
      EventProp.SUBJECTS: exam[C.SUBJECT],
      EventProp.PRIVACY: exam[C.PRIVACY],
    });
  }

  @override
  Widget build(BuildContext context) {
    bool updatable =
        (isCreator((exam ?? {})[C.CREATED_BY]) && (widget.isEditable ?? false));
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.EXAM.tr),
          actions: [IconButton(icon: Icon(Icons.share), onPressed: _share)],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    if (isLoading)
                      DetailsSkeleton(
                        type: DetailsType.CardInfo,
                      ),
                    if (!isLoading)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 16.0),
                          SelectableText(
                            exam[C.TITLE] ?? '',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          SizedBox(height: 16.0),
                          InfoCard(
                            title: S.EXAM_INSTRUCTION.tr,
                            data: exam[C.INSTRUCTION],
                          ),
                          InfoCard(
                            title: S.MARKS.tr,
                            data: exam[C.MARKS],
                          ),
                          if (exam[C.MINUS_MARKING])
                            InfoCard(
                              title: S.MINUS_MARKS_PER_QUESTION.tr,
                              data: exam[C.MINUS_MARKING_PER_QUESTION],
                            ),
                          InfoCard(
                            title: S.SOLVING_TIME.tr,
                            data: getMinuteSt(exam[C.SOLVING_TIME]),
                          ),
                          InfoCard(
                            title: S.EXAM_PRIVACY.tr,
                            data: getPrivacySt(exam[C.PRIVACY]).tr,
                          ),
                          InfoCard(
                            title: S.DIFFICULTY_LEVEL.tr,
                            data: getDifficulty(exam[C.DIFFICULTY]).tr,
                          ),
                          InfoCard(
                            title: S.EXAM.tr,
                            child:
                                GroupChips(list: exam[C.EXAM].cast<String>()),
                          ),
                          InfoCard(
                            title: S.SUBJECT.tr,
                            child: GroupChips(
                                list: exam[C.SUBJECT].cast<String>()),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              if (!isLoading)
                Column(
                  children: exam[C.QUESTION].map<Widget>(
                    (e) {
                      return QuestionCard(question: e, isFromExam: true);
                    },
                  ).toList(),
                ),
              SizedBox(height: 16.0),
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
        floatingActionButton: updatable
            ? FloatingActionButton(
                onPressed: _onEdit,
                child: Icon(Icons.edit),
              )
            : null,
      ),
    );
  }
}
