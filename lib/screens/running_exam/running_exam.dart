import 'package:apna_classroom_app/api/exam_conducted.dart';
import 'package:apna_classroom_app/api/solved_exam.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/running_exam/controller/running_exam_controller.dart';
import 'package:apna_classroom_app/screens/running_exam/running_exam_question.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/date_time.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RunningExam extends StatefulWidget {
  final examConducted;

  const RunningExam({Key key, this.examConducted}) : super(key: key);

  @override
  _RunningExamState createState() => _RunningExamState();
}

class _RunningExamState extends State<RunningExam> {
  bool isLoading = true;
  Map<String, dynamic> examConducted = {};

  loadExamConducted() async {
    Map<String, dynamic> _examConducted =
        await getExamConducted({C.ID: widget.examConducted[C.ID]});
    setState(() {
      examConducted = _examConducted;
      isLoading = false;
    });
  }

  @override
  void initState() {
    Get.put(RunningExamController());
    super.initState();
    loadExamConducted();
  }

  startExam() async {
    var _solvedExam = await getSolvedExam({
      C.EXAM_CONDUCTED: examConducted[C.ID],
    });

    if (examConducted[C.MUST_JOIN_INSTANTLY] && _solvedExam == null) {
      int currentDelay = getSecondDiff(
          firstSt: examConducted[C.START_TIME], second: DateTime.now());
      if (currentDelay > examConducted[C.ALLOWED_DELAY]) {
        return ok(
            title: S.YOU_LATE.tr, msg: S.YOU_ARE_LATE_CAN_NOT_JOIN_EXAM_NOW.tr);
      }
    }

    if ((examConducted[C.CAN_EXAM_EXPIRE] ?? false) &&
        !isFutureDate(dateSt: examConducted[C.EXPIRE_TIME])) {
      return ok(title: S.EXAM_EXPIRED.tr, msg: S.THIS_EXAM_IS_EXPIRED.tr);
    }

    /// 1. Already created the solved exam
    /// 2. Can resume the Exam?? if then start from the existing position
    /// 3. If already a completed exam, then can give again exam?? then delete old one and start new one
    ///
    ///

    int solvingTime = examConducted[C.EXAM][C.SOLVING_TIME];
    if (_solvedExam != null) {
      /// Already Finished?
      /// 1. Can give exam again? Yes -> delete old one and join with new exam, No -> Return with message
      ///
      /// Unfinished Exam?
      ///
      /// 1. can resume exam? NO -> Can't join exam, Yes -> Join Exam again
      ///

      // Exam Finished
      if (_solvedExam[C.FINISHED] ?? false) {
        if (examConducted[C.ALLOW_ATTEND_MULTIPLE_TIME] ?? false) {
          var again = await yesOrNo(
              title: S.ATTEND_AGAIN.tr,
              msg: S.WOULD_YOU_GIVE_EXAM_AGAIN_OLD_EXAM_DELETED.tr,
              noName: S.NO.tr,
              yesName: S.YES.tr,
              yes: () {
                return true;
              },
              no: () {
                return false;
              });
          if (again ?? false) {
            await deleteSolvedExam({C.ID: _solvedExam[C.ID]});
            _solvedExam = await createSolvedExam({
              C.EXAM_CONDUCTED: examConducted[C.ID],
              C.START_TIME: DateTime.now().toString(),
            });
          } else {
            return;
          }
        } else {
          return ok(
            title: S.ATTEND_AGAIN.tr,
            msg: S.YOU_CAN_NOT_GIVE_EXAM_AGAIN.tr,
          );
        }
      }

      // Unfinished Exam

      /// Remaining time of the exam should be exam solving time - Diff(Exam Started Time, Time now )
      else {
        if (examConducted[C.ALLOW_RESUME_EXAM] ?? false) {
          if (examConducted[C.MUST_FINISH_WITHIN_TIME] ?? false) {
            int timeSpend = getSecondDiff(
                firstSt: _solvedExam[C.START_TIME], second: DateTime.now());
            if ((getSecondDiff(
                    firstSt: _solvedExam[C.START_TIME],
                    second: DateTime.now()) >
                examConducted[C.EXAM][C.SOLVING_TIME])) {
              return ok(
                  title: S.RESUME_EXAM.tr,
                  msg:
                      S.YOU_CAN_NOT_RESUME_EXAM_BECAUSE_YOU_ARE_OUT_OF_TIME.tr);
            }
            solvingTime -= timeSpend;
          }
          // await ok(title: 'Resume Exam', msg: 'Resuming your pending exam.');
        } else {
          return ok(title: S.RESUME_EXAM.tr, msg: S.YOU_CAN_NOT_RESUME_EXAM.tr);
        }
      }
    } else {
      _solvedExam = await createSolvedExam({
        C.EXAM_CONDUCTED: examConducted[C.ID],
        C.START_TIME: DateTime.now().toString(),
      });
    }
    RunningExamController.to
        .resetData(examConducted[C.EXAM][C.QUESTION], _solvedExam);
    Get.to(RunningExamQuestion(
      examConducted: examConducted,
      remainingSolvingTime: solvingTime,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getMinuteSt(widget.examConducted[C.EXAM][C.SOLVING_TIME])),
      ),
      body: Column(
        children: [
          if (isLoading)
            DetailsSkeleton(
              type: DetailsType.Info,
            ),
          if (!isLoading)
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  children: [
                    Text(
                      examConducted[C.EXAM][C.TITLE],
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(height: 16),
                    InfoCard(
                      title: S.MARKS.tr,
                      data: examConducted[C.EXAM][C.MARKS],
                    ),
                    SizedBox(height: 16),
                    InfoCard(
                      title: S.EXAM_INSTRUCTION.tr,
                      data: examConducted[C.EXAM][C.INSTRUCTION],
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PrimaryButton(
                text: S.START.tr,
                onPress: startExam,
              ),
              SizedBox(width: 32),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
