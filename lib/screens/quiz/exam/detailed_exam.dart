import 'package:apna_classroom_app/api/exam.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/components/skeletons/list_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/question_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedExam extends StatefulWidget {
  final exam;

  const DetailedExam({Key key, this.exam}) : super(key: key);

  @override
  _DetailedExamState createState() => _DetailedExamState();
}

class _DetailedExamState extends State<DetailedExam> {
  bool isLoading = true;
  Map<String, dynamic> exam = {};

  loadExam() async {
    Map<String, dynamic> _exam = await getExam({C.ID: widget.exam[C.ID]});
    // print(_exam);
    setState(() {
      exam = _exam;
      isLoading = false;
    });
  }

  onShare() {}

  @override
  void initState() {
    super.initState();
    loadExam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.EXAM.tr),
        actions: [IconButton(icon: Icon(Icons.share), onPressed: onShare)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  SelectableText(
                    widget.exam[C.TITLE],
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 8.0),
                  if (isLoading) ListSkeleton(size: 4),
                  if (!isLoading)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        if (exam[C.INSTRUCTION] != null)
                          SelectableText(exam[C.INSTRUCTION]),
                        SizedBox(height: 8.0),
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
                          title: S.SOLVING_TIME.tr,
                          data: getDifficulty(exam[C.DIFFICULTY]).tr,
                        ),
                        InfoCard(
                          title: S.EXAM.tr,
                          child: GroupChips(list: exam[C.EXAM].cast<String>()),
                        ),
                        InfoCard(
                          title: S.SUBJECT.tr,
                          child:
                              GroupChips(list: exam[C.SUBJECT].cast<String>()),
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
                    var question = e[C.QUESTION];
                    question[C.SOLVING_TIME] = e[C.SOLVING_TIME];
                    question[C.MARKS] = e[C.MARKS];
                    return QuestionCard(question: question);
                  },
                ).toList(),
              ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
