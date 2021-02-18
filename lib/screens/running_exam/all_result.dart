import 'package:apna_classroom_app/api/solved_exam.dart';
import 'package:apna_classroom_app/components/skeletons/list_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
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
  }

  // open Single Result
  openSingleResult(id) {
    Get.to(SingleResult(
      solvedExamId: id,
    ));
  }

  @override
  void initState() {
    super.initState();
    loadResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.RESULT.tr),
      ),
      body: Column(
        children: [
          if (_result == null) ListSkeleton(size: 4),
          if (_result != null) ExamCard(exam: _examConducted[C.EXAM]),
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
