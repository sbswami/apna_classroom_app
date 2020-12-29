import 'package:apna_classroom_app/api/exam.dart';
import 'package:apna_classroom_app/components/skeletons/list_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/exam_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';

const String PER_PAGE_QUESTION = '10';

class Exams extends StatefulWidget {
  final String examTitle;

  const Exams({Key key, this.examTitle}) : super(key: key);
  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Exams>
    with AutomaticKeepAliveClientMixin<Exams> {
  bool isLoading = false;
  List<String> selectedSubjects = [];
  List<String> selectedExams = [];
  List exams = [];
  String searchTitle;

  loadQuestion() async {
    if (isLoading == true) return;
    setState(() {
      isLoading = true;
    });
    int present = exams.length;
    Map<String, String> payload = {
      C.PRESENT: present.toString(),
      C.PER_PAGE: PER_PAGE_QUESTION,
    };
    if (searchTitle != null) payload[C.TITLE] = searchTitle;
    var questionList = await listExam(payload, selectedSubjects, selectedExams);
    setState(() {
      isLoading = false;
      exams.addAll(questionList);
    });
  }

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  // Exam and Subject filters
  onSelectedSubject(String subject, bool selected) {
    setState(() {
      if (selected) {
        selectedSubjects.add(subject);
      } else {
        selectedSubjects.remove(subject);
      }
      exams.clear();
    });
    loadQuestion();
  }

  onSelectedExam(String subject, bool selected) {
    setState(() {
      if (selected) {
        selectedExams.add(subject);
      } else {
        selectedExams.remove(subject);
      }
      exams.clear();
    });
    loadQuestion();
  }

  // on Search
  @override
  void didUpdateWidget(Exams oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.examTitle != widget.examTitle) {
      onSearch(widget.examTitle);
    }
  }

  onSearch(String value) {
    setState(() {
      exams.clear();
      if (value.isEmpty)
        searchTitle = null;
      else
        searchTitle = value;
    });
    loadQuestion();
  }

  // On refresh
  Future<void> onRefresh() async {
    setState(() {
      exams.clear();
    });
    await loadQuestion();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int resultLength = exams.length;
    return Column(
      children: [
        SubjectFilter(
          subjects: RecentlyUsedController.to.subjects,
          selectedSubjects: selectedSubjects,
          onSelected: onSelectedSubject,
          exams: RecentlyUsedController.to.exams,
          selectedExams: selectedExams,
          onSelectedExam: onSelectedExam,
        ),
        if (resultLength == 0 && (isLoading ?? true)) ListSkeleton(size: 4),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if ((scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) &&
                  !isLoading) {
                loadQuestion();
              }
              return true;
            },
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: resultLength,
                itemBuilder: (context, position) {
                  return ExamCard(
                    exam: exams[position],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
