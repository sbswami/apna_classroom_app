import 'package:apna_classroom_app/api/exam_conducted.dart';
import 'package:apna_classroom_app/api/fcm.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/single_input_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/exam_conducted/all_exam_conducted.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/exam_conducted_card.dart';
import 'package:apna_classroom_app/screens/running_exam/all_result.dart';
import 'package:apna_classroom_app/screens/running_exam/running_exam.dart';
import 'package:apna_classroom_app/screens/running_exam/single_result.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamConductedList extends StatelessWidget {
  final Map runningExam;
  final Map upcomingExam;
  final Map completedExam;
  final String classroomId;

  const ExamConductedList(
      {Key key,
      this.runningExam,
      this.upcomingExam,
      this.completedExam,
      this.classroomId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getWidget(context, ExamConductedState.RUNNING, runningExam),
        getWidget(context, ExamConductedState.UPCOMING, upcomingExam),
        getWidget(context, ExamConductedState.COMPLETED, completedExam),
      ],
    );
  }

  Widget getWidget(
      BuildContext context, ExamConductedState type, examConducted) {
    if (examConducted == null) return SizedBox.shrink();

    return Column(
      children: [
        SizedBox(height: 16),
        Divider(),
        Text(
          getExamConductedTitle(type),
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: 8.0),
        ExamConductedCard(
          examConducted: examConducted,
          buttons: getExamConductedButtons(type, examConducted),
        ),
        SizedBox(height: 10.0),
        PrimaryButton(
          text: getExamConductedButton(type),
          onPress: () {
            Get.to(AllExamConducted(type: type, classroomId: classroomId));
          },
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}

List<Map<String, dynamic>> getExamConductedButtons(
    ExamConductedState type, examConducted) {
  List<Map<String, dynamic>> buttons = [];
  String createdBy = examConducted[C.CREATED_BY];

  // If single exam solved by user
  if (examConducted[C.SOLVED_EXAM] != null) {
    buttons.add({
      C.NAME: S.VIEW_RESULT.tr,
      C.ON_TAP: () => openSingleResult(examConducted),
      C.PRIMARY: true,
    });
  }
  switch (type) {
    case ExamConductedState.RUNNING:
      if (!isCreator(createdBy)) {
        buttons.add({
          C.NAME: S.JOIN.tr,
          C.ON_TAP: () => onExamJoin(examConducted),
        });
      }
      if (isCreator(createdBy)) {
        buttons.addAll([
          {
            C.NAME: S.DELETE.tr,
            C.ON_TAP: () => _deleteExamConducted(type, examConducted),
            C.PRIMARY: false,
          },
          {
            C.NAME: S.VIEW_RESULT.tr,
            C.ON_TAP: () => openAllResult(examConducted),
            C.PRIMARY: true,
          }
        ]);
      }

      break;
    case ExamConductedState.UPCOMING:
      if (isCreator(createdBy)) {
        buttons.add({
          C.NAME: S.DELETE.tr,
          C.ON_TAP: () => _deleteExamConducted(type, examConducted),
          C.PRIMARY: false,
        });
      }
      break;
    case ExamConductedState.COMPLETED:
      if (isCreator(createdBy)) {
        buttons.addAll([
          {
            C.NAME: S.DELETE.tr,
            C.ON_TAP: () => _deleteExamConducted(type, examConducted),
            C.PRIMARY: false,
          },
          {
            C.NAME: S.VIEW_RESULT.tr,
            C.ON_TAP: () => openAllResult(examConducted),
            C.PRIMARY: true,
          },
        ]);
      }

      break;
  }
  return buttons;
}

String getExamConductedTitle(ExamConductedState type) {
  switch (type) {
    case ExamConductedState.RUNNING:
      return S.RUNNING_EXAM.tr;
      break;
    case ExamConductedState.UPCOMING:
      return S.UPCOMING_EXAM.tr;
      break;
    case ExamConductedState.COMPLETED:
      return S.COMPLETED_EXAM.tr;
      break;
  }
  return '';
}

String getExamConductedButton(ExamConductedState type) {
  switch (type) {
    case ExamConductedState.RUNNING:
      return S.VIEW_ALL_RUNNING_EXAMS.tr;
      break;
    case ExamConductedState.UPCOMING:
      return S.VIEW_ALL_UPCOMING_EXAMS.tr;
      break;
    case ExamConductedState.COMPLETED:
      return S.VIEW_ALL_COMPLETED_EXAMS.tr;
      break;
  }
  return '';
}

enum ExamConductedState { RUNNING, UPCOMING, COMPLETED }

onExamJoin(examConducted) {
  Get.to(RunningExam(examConducted: examConducted));
}

_deleteExamConducted(ExamConductedState type, examConducted) async {
  String deleteNote;
  switch (type) {
    case ExamConductedState.RUNNING:
      deleteNote = S.DELETE_RUNNING_EXAM_NOTE.tr;
      break;
    case ExamConductedState.UPCOMING:
      deleteNote = S.DELETE_UPCOMING_EXAM_NOTE.tr;
      break;
    case ExamConductedState.COMPLETED:
      deleteNote = S.DELETE_COMPLETED_EXAM_NOTE.tr;
      break;
  }
  var result = await wantToDelete(() {
    return true;
  }, deleteNote);
  if (!(result ?? false)) return;

  var reason = await showSingleInputDialog(
      title: S.REASON_OF_DELETION.tr, labelText: S.ENTER_REASON.tr);
  if (reason == null) return;

  bool isDeleted =
      await deleteExamConducted({C.ID: examConducted[C.ID], C.REASON: reason});
  if (isDeleted == null)
    return ok(title: S.SOMETHING_WENT_WRONG.tr, msg: S.CAN_NOT_DELETE_NOW.tr);
  backToHome();
}

openSingleResult(examConducted) {
  if (examConducted[C.SOLVED_EXAM] != null &&
      examConducted[C.SOLVED_EXAM][C.ID] != null) {
    Get.to(SingleResult(conductedExamId: examConducted[C.ID]));
  }
}

openAllResult(examConducted) {
  Get.to(AllResult(conductedExamId: examConducted[C.ID]));
}
