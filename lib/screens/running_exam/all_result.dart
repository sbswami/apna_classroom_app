import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/solved_exam.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/quiz/exam/detailed_exam.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/exam_card.dart';
import 'package:apna_classroom_app/screens/running_exam/single_result.dart';
import 'package:apna_classroom_app/screens/running_exam/widgets/person_marks_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllResult extends StatefulWidget {
  final conductedExamId;

  const AllResult({Key key, this.conductedExamId}) : super(key: key);

  @override
  _AllResultState createState() => _AllResultState();
}

class _AllResultState extends State<AllResult> {
  var _result;
  var _examConducted;

  // load result
  loadResult() async {
    var result = await getResultAllSolvedExam({
      C.EXAM_CONDUCTED: widget.conductedExamId,
    });
    setState(() {
      _result = result[C.LIST];
      _examConducted = result[C.EXAM_CONDUCTED];
    });

    // Track Event
    track(EventName.ALL_RESULT, {
      EventProp.COUNT: _result?.length,
      EventProp.PRIVACY: _examConducted[C.EXAM][C.PRIVACY],
      EventProp.DIFFICULTY: _examConducted[C.EXAM][C.DIFFICULTY],
    });
  }

  // open Single Result
  openSingleResult(id) async {
    await Get.to(SingleResult(
      solvedExamId: id,
      accessedFrom: ScreenNames.AllResult,
    ));

    // Track screen back
    trackScreen(ScreenNames.AllResult);
  }

  @override
  void initState() {
    super.initState();

    // Track screen
    trackScreen(ScreenNames.AllResult);

    loadResult();
  }

  // On exam tap
  _onExamTap() async {
    await Get.to(
      () => DetailedExam(examConducted: _examConducted),
    );

    // Track back screen
    trackScreen(ScreenNames.AllResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.RESULT.tr),
      ),
      body: Column(
        children: [
          if (_result == null) DetailsSkeleton(type: DetailsType.CardInfo),
          if (_result != null)
            ExamCard(
              exam: _examConducted[C.EXAM],
              onTap: _onExamTap,
            ),
          if (_result != null)
            Column(
              children: _result
                  .map<Widget>(
                    (e) => PersonMarksCard(
                      person: e,
                      onTap: () => openSingleResult(e[C.ID]),
                    ),
                  )
                  .toList(),
            )
        ],
      ),
    );
  }
}
