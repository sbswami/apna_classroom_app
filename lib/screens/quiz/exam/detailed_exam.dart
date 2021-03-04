import 'package:apna_classroom_app/api/exam.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/quiz/exam/add_exam.dart';
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
  Map<String, dynamic> exam;

  loadExam() async {
    Map<String, dynamic> _exam = await getExam({C.ID: widget.exam[C.ID]});

    setState(() {
      exam = _exam;
      isLoading = false;
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
    Get.back(result: true);
  }

  // Edit
  bool isEdited = false;
  _onEdit() async {
    var result = await Get.to(() => AddExam(exam: exam));
    if (result ?? false) {
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
    loadExam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.EXAM.tr),
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
                    (exam ?? widget.exam)[C.TITLE],
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 8.0),
                  if (isLoading)
                    DetailsSkeleton(
                      type: DetailsType.CardInfo,
                    ),
                  if (!isLoading)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
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
                    return QuestionCard(question: e, isFromExam: true);
                  },
                ).toList(),
              ),
            SizedBox(height: 16.0),
            if (isCreator((exam ?? widget.exam)[C.CREATED_BY]))
              PrimaryButton(
                destructive: true,
                text: S.DELETE.tr,
                onPress: _onDelete,
              ),
            SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButton: isCreator((exam ?? {})[C.CREATED_BY])
          ? FloatingActionButton(
              onPressed: _onEdit,
              child: Icon(Icons.edit),
            )
          : null,
    );
  }
}
