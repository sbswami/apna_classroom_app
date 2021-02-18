import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/exam_conducted/all_exam_conducted.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/exam_conducted_card.dart';
import 'package:apna_classroom_app/screens/running_exam/all_result.dart';
import 'package:apna_classroom_app/screens/running_exam/running_exam.dart';
import 'package:apna_classroom_app/screens/running_exam/single_result.dart';
import 'package:apna_classroom_app/util/c.dart';
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
        getWidget(context, RUNNING, runningExam),
        getWidget(context, UPCOMING, upcomingExam),
        getWidget(context, COMPLETED, completedExam),
      ],
    );
  }

  Widget getWidget(BuildContext context, String type, examConducted) {
    if (examConducted == null) return SizedBox.shrink();

    return Column(
      children: [
        Text(
          getExamConductedTitle(type),
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(height: 8.0),
        ExamConductedCard(
          examConducted: examConducted,
          buttons: getExamConductedButtons(type, examConducted),
        ),
        SizedBox(height: 4.0),
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

List<Map<String, dynamic>> getExamConductedButtons(String type, examConducted) {
  List<Map<String, dynamic>> buttons = [];
  String createdBy = examConducted[C.CREATED_BY];
  switch (type) {
    case RUNNING:
      if (examConducted[C.SOLVED_EXAM] != null) {
        buttons.add({
          C.NAME: S.VIEW_RESULT.tr,
          C.ON_TAP: () {
            print('VIEW RESULT ${examConducted[C.SOLVED_EXAM]}');
            openSingleResult(examConducted);
          },
          C.PRIMARY: true,
        });
      }
      if (createdBy != UserController.to.currentUser[C.ID]) {
        buttons.add({
          C.NAME: S.JOIN.tr,
          C.ON_TAP: () {
            print('JOIN ${examConducted[C.ID]}');
            onExamJoin(examConducted);
          },
        });
      }
      if (createdBy == UserController.to.currentUser[C.ID]) {
        buttons.addAll([
          {
            C.NAME: S.DELETE.tr,
            C.ON_TAP: () {
              print('DELETE ${examConducted[C.ID]}');
            },
            C.PRIMARY: false,
          },
          {
            C.NAME: S.VIEW_RESULT.tr,
            C.ON_TAP: () {
              print('VIEW RESULT ${examConducted[C.SOLVED_EXAM]}');
              openAllResult(examConducted);
            },
            C.PRIMARY: true,
          }
        ]);
      }

      break;
    case UPCOMING:
      if (createdBy == UserController.to.currentUser[C.ID]) {
        buttons.add({
          C.NAME: S.DELETE.tr,
          C.ON_TAP: () {
            print('DELETE ${examConducted[C.ID]}');
          },
          C.PRIMARY: false,
        });
      }
      break;
    case COMPLETED:
      // Get is admin here to check thing
      if (createdBy == UserController.to.currentUser[C.ID]) {
        buttons.add({
          C.NAME: S.VIEW_RESULT.tr,
          C.ON_TAP: () {
            print('View Result all ${examConducted[C.ID]}');
          },
          C.PRIMARY: false,
        });
      }
      if (createdBy != UserController.to.currentUser[C.ID]) {
        buttons.add({
          C.NAME: S.VIEW_RESULT.tr,
          C.ON_TAP: () {
            print('View Result ${examConducted[C.ID]}');
          },
        });
      }
      break;
  }
  return buttons;
}

String getExamConductedTitle(String type) {
  switch (type) {
    case RUNNING:
      return S.RUNNING_EXAM.tr;
      break;
    case UPCOMING:
      return S.UPCOMING_EXAM.tr;
      break;
    case COMPLETED:
      return S.COMPLETED_EXAM.tr;
      break;
  }
  return '';
}

String getExamConductedButton(String type) {
  switch (type) {
    case RUNNING:
      return S.VIEW_ALL_RUNNING_EXAMS.tr;
      break;
    case UPCOMING:
      return S.VIEW_ALL_UPCOMING_EXAMS.tr;
      break;
    case COMPLETED:
      return S.VIEW_ALL_COMPLETED_EXAMS.tr;
      break;
  }
  return '';
}

const String RUNNING = 'RUNNING';
const String UPCOMING = 'UPCOMING';
const String COMPLETED = 'COMPLETED';

onExamJoin(examConducted) {
  Get.to(RunningExam(examConducted: examConducted));
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
