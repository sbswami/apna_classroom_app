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
    // Load Solved exam if any
    var _solvedExam = await getSolvedExam({
      C.EXAM_CONDUCTED: examConducted[C.ID],
    });

    // If Must join on start and user haven't started exam yet
    if (examConducted[C.MUST_JOIN_INSTANTLY] && _solvedExam == null) {
      // Current delay from start
      int currentDelay = getSecondDiff(
        firstSt: examConducted[C.START_TIME], // Start time of exam
        second: DateTime.now(), // Current time
      );

      // if delay is more then allowed delay
      if (currentDelay > (examConducted[C.ALLOWED_DELAY] ?? 60)) {
        // User is late to join exam
        return ok(
          title: S.YOU_LATE.tr,
          msg: S.YOU_ARE_LATE_CAN_NOT_JOIN_EXAM_NOW.tr,
        );
      }
    }

    // if Exam can expire and it's expired
    if ((examConducted[C.CAN_EXAM_EXPIRE] ?? false) &&
        !isFutureDate(dateSt: examConducted[C.EXPIRE_TIME])) {
      // User can't join exam, due to expire exam
      return ok(title: S.EXAM_EXPIRED.tr, msg: S.THIS_EXAM_IS_EXPIRED.tr);
    }

    /// 1. Already created the solved exam
    /// 2. Can resume the Exam?? if then start from the existing position
    /// 3. If already a completed exam, then can give again exam?? then delete old one and start new one
    int solvingTime = examConducted[C.EXAM][C.SOLVING_TIME];

    // User had started exam earlier and want to join exam again
    if (_solvedExam != null) {
      /// Already Finished?
      /// 1. Can give exam again? Yes -> delete old one and join with new exam, No -> Return with message
      ///
      /// Unfinished Exam?
      /// 1. can resume exam? NO -> Can't join exam, Yes -> Join Exam again

      // Exam Finished
      if (_solvedExam[C.FINISHED] ?? false) {
        // Exam conducted allowed to attend multiple times
        if (examConducted[C.ALLOW_ATTEND_MULTIPLE_TIME] ?? false) {
          // Yes / No want to attend
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

          // User want to give exam again
          if (again ?? false) {
            // Delete the exiting solved exam
            await deleteSolvedExam(
              {C.ID: _solvedExam[C.ID]},
            );

            // Create new Solved exam
            _solvedExam = await createSolvedExam({
              C.EXAM_CONDUCTED: examConducted[C.ID],
              C.START_TIME: DateTime.now().toString(),
            });
          } else
            return;
        } else {
          // User is not allowed to attend exam again
          return ok(
            title: S.ATTEND_AGAIN.tr,
            msg: S.YOU_CAN_NOT_GIVE_EXAM_AGAIN.tr,
          );
        }
      }

      // Unfinished Exam
      /// Remaining time of the exam should be exam solving time - Diff(Exam Started Time, Time now )
      else {
        // user is allowed to resume exam
        if (examConducted[C.ALLOW_RESUME_EXAM] ?? false) {
          // If user should finish exam with in the time
          if (examConducted[C.MUST_FINISH_WITHIN_TIME] ?? false) {
            // Time already spend
            int timeSpend = getSecondDiff(
              firstSt: _solvedExam[C.START_TIME],
              second: DateTime.now(),
            );

            // Time spend by User on exam more then total solving time
            if (timeSpend > examConducted[C.EXAM][C.SOLVING_TIME]) {
              // User is out of time
              return ok(
                title: S.RESUME_EXAM.tr,
                msg: S.YOU_CAN_NOT_RESUME_EXAM_BECAUSE_YOU_ARE_OUT_OF_TIME.tr,
              );
            }

            // Current solving time = Exam Solving time - Time spend by user
            solvingTime -= timeSpend;
          }
        } else {
          // User is not allowed to resume exam
          return ok(title: S.RESUME_EXAM.tr, msg: S.YOU_CAN_NOT_RESUME_EXAM.tr);
        }
      }
    } else {
      // User didn't started exam, new start of exam
      _solvedExam = await createSolvedExam({
        C.EXAM_CONDUCTED: examConducted[C.ID],
        C.START_TIME: DateTime.now().toString(),
      });
    }

    // Rest the controller
    RunningExamController.to.resetData(
      examConducted[C.EXAM][C.QUESTION],
      _solvedExam,
    );
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
