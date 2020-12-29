import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/chips/wrap_action_chips.dart';
import 'package:apna_classroom_app/components/chips/wrap_chips.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectTagInput extends StatelessWidget {
  final Set<String> subjects;
  final String subjectError;
  final TextEditingController subjectController;
  final Function(String subject) addSubject;
  final Function(String subject) removeSubject;
  final Function addAllLastUsed;
  final FocusNode focusNode;

  const SubjectTagInput(
      {Key key,
      @required this.subjects,
      this.subjectError,
      @required this.subjectController,
      @required this.addSubject,
      @required this.removeSubject,
      @required this.addAllLastUsed,
      this.focusNode})
      : super(key: key);

  addSubjectPre(String value) {
    value = value.trim();
    if (value.isEmpty) return;
    subjectController.clear();
    RecentlyUsedController.to.addSubject(value);
    addSubject(value);
  }

  @override
  Widget build(BuildContext context) {
    Set<String> subjectSuggestions =
        RecentlyUsedController.to.subjects.toSet().difference(subjects);
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
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: S.ENTER_SUBJECT.tr,
                    errorText: subjectError,
                  ),
                  focusNode: focusNode,
                ),
              ),
              SizedBox(width: 20.0),
              SecondaryButton(
                onPress: () => addSubjectPre(subjectController.text),
                // iconData: Icons.add,
                text: S.PLUS_ADD.tr,
              ),
            ],
          ),
          SizedBox(height: 8),
          WrapChips(list: subjects, onDeleted: removeSubject),
          Divider(),
          if (RecentlyUsedController.to.lastUsedSubjects.length != 0)
            TextButton(
              onPressed: addAllLastUsed,
              child: Text(S.ADD_ALL_LAST_USED.tr),
            ),
          WrapActionChips(
            list: subjectSuggestions.take(5).toSet(),
            onAction: addSubject,
            actionIcon: Icons.add,
          )
        ],
      ),
    );
  }
}
