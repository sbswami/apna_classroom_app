import 'package:flutter/material.dart';

class SubjectFilter extends StatelessWidget {
  final List<String> subjects;
  final List<String> selectedSubjects;
  final Function(String subject, bool selected) onSelected;

  const SubjectFilter(
      {Key key, this.selectedSubjects, this.onSelected, this.subjects})
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
          children: subjects
              .map(
                (subject) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
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
              .toList(),
        ),
      ),
    );
  }
}
