import 'package:apna_classroom_app/api/solved_exam.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/running_exam/answer_view.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/date_time.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleResult extends StatefulWidget {
  final solvedExam;
  final conductedExamId;
  final String attenderId;
  final String solvedExamId;

  const SingleResult(
      {Key key,
      this.solvedExam,
      this.conductedExamId,
      this.attenderId,
      this.solvedExamId})
      : super(key: key);

  @override
  _SingleResultState createState() => _SingleResultState();
}

class _SingleResultState extends State<SingleResult> {
  Map _solvedExam;

  showAnswer() {
    Get.to(AnswerView(solvedExam: _solvedExam));
  }

  _loadSolvedExam() async {
    if (widget.solvedExam != null) {
      _solvedExam = widget.solvedExam;
    } else {
      var solvedExam = await getResultOneSolvedExam({
        C.ID: widget.solvedExamId,
        C.EXAM_CONDUCTED: widget.conductedExamId,
        C.ATTENDER: widget.attenderId
      });
      setState(() {
        _solvedExam = solvedExam;
      });
    }
  }

  @override
  void initState() {
    _loadSolvedExam();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.RESULT.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_solvedExam == null) LinearProgressIndicator(),
            if (_solvedExam != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      _solvedExam[C.ATTENDER][C.NAME],
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    InfoCard(
                      title: S.STARTED_AT.tr,
                      data: getFormattedDateTime(
                        dateString: _solvedExam[C.START_TIME],
                      ),
                    ),
                    InfoCard(
                      title: S.EXAM_COMPLETED_IN.tr,
                      data: getMinuteSt(getSecondDiff(
                          firstSt: _solvedExam[C.START_TIME],
                          secondSt: _solvedExam[C.FINISHED_TIME])),
                    ),
                    InfoCard(
                      title: S.MARKS.tr,
                      child: Text(
                        '${_solvedExam[C.MARKS] ?? 0}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    InfoCard(
                      title: S.MAXIMUM_MARKS.tr,
                      data: _solvedExam[C.EXAM_CONDUCTED][C.EXAM][C.MARKS],
                    ),
                    InfoCard(
                      title: S.PERCENTAGE.tr,
                      data: getPercentage(_solvedExam[C.MARKS],
                          _solvedExam[C.EXAM_CONDUCTED][C.EXAM][C.MARKS]),
                    ),
                    InfoCard(
                      title: S.MINUS_MARKS.tr,
                      data: _solvedExam[C.MINUS_MARKS],
                    ),
                    InfoCard(
                      title: S.WITHOUT_MINUS_MARKS.tr,
                      data: (_solvedExam[C.MARKS_GAINED] ?? 0),
                    ),
                    SizedBox(height: 16),
                    SecondaryButton(
                      text: S.SHOW_ANSWERS.tr,
                      onPress: showAnswer,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
