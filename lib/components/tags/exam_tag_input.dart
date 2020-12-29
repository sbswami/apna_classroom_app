import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/chips/wrap_action_chips.dart';
import 'package:apna_classroom_app/components/chips/wrap_chips.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamTagInput extends StatelessWidget {
  final Set<String> exams;
  final String examError;
  final TextEditingController examController;
  final Function(String exam) addExam;
  final Function(String exam) removeExam;
  final Function addAllLastUsedExam;
  final FocusNode focusNode;

  const ExamTagInput(
      {Key key,
      @required this.exams,
      this.examError,
      @required this.examController,
      @required this.addExam,
      @required this.removeExam,
      @required this.addAllLastUsedExam,
      this.focusNode})
      : super(key: key);

  addExamPre(String value) {
    value = value.trim();
    if (value.isEmpty) return;
    examController.clear();
    RecentlyUsedController.to.addExam(value);
    addExam(value);
  }

  @override
  Widget build(BuildContext context) {
    Set<String> examSuggestions =
        RecentlyUsedController.to.exams.toSet().difference(exams);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: TextFormField(
                  controller: examController,
                  decoration: InputDecoration(
                    labelText: S.ENTER_EXAM.tr,
                    errorText: examError,
                  ),
                  focusNode: focusNode,
                ),
              ),
              SizedBox(width: 20.0),
              SecondaryButton(
                onPress: () => addExamPre(examController.text),
                // iconData: Icons.add,
                text: S.PLUS_ADD.tr,
              ),
            ],
          ),
          SizedBox(height: 8),
          WrapChips(list: exams, onDeleted: removeExam),
          Divider(),
          if (RecentlyUsedController.to.lastUsedExams.length != 0)
            TextButton(
              onPressed: addAllLastUsedExam,
              child: Text(S.ADD_ALL_LAST_USED.tr),
            ),
          WrapActionChips(
            list: examSuggestions.take(5).toSet(),
            onAction: addExam,
            actionIcon: Icons.add,
          )
        ],
      ),
    );
  }
}
