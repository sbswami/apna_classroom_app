import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';

class SubjectFilter extends StatelessWidget {
  final List<String> subjects;
  final List<String> exams;
  final List<String> selectedSubjects;
  final List<String> selectedExams;
  final Function(String subject, bool selected) onSelected;
  final Function(String subject, bool selected) onSelectedExam;

  const SubjectFilter(
      {Key key,
      this.selectedSubjects,
      this.onSelected,
      this.subjects,
      this.selectedExams,
      this.onSelectedExam,
      this.exams})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.symmetric(
            horizontal:
                BorderSide(width: 1, color: Theme.of(context).dividerColor)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: getContentList(context),
        ),
      ),
    );
  }

  List<Widget> getContentList(BuildContext context) {
    if (subjects != null && exams != null) {
      return zip(getSubjectList(context), getExamList(context)).toList();
    }
    if (subjects != null) return getSubjectList(context);
    if (exams != null) return getExamList(context);
    return [];
  }

  List<Widget> getSubjectList(BuildContext context) {
    return subjects
        .map(
          (subject) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: FilterChip(
              elevation: 4.0,
              label: Text(subject),
              selected: selectedSubjects.contains(subject),
              selectedColor: Theme.of(context).cardColor,
              onSelected: (value) => onSelected(subject, value),
              checkmarkColor: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).cardColor,
            ),
          ),
        )
        .toList();
  }

  List<Widget> getExamList(BuildContext context) {
    return exams
        .map(
          (exam) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: FilterChip(
              elevation: 4.0,
              label: Text(exam),
              selected: selectedExams.contains(exam),
              selectedColor: Theme.of(context).cardColor,
              onSelected: (value) => onSelectedExam(exam, value),
              checkmarkColor: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).cardColor,
            ),
          ),
        )
        .toList();
  }
}
