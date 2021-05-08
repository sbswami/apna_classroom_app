import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/exam.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/screens/quiz/exam/detailed_exam.dart';
import 'package:apna_classroom_app/screens/quiz/quiz_provider.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/exam_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

const String PER_PAGE_EXAMS = '10';

class Exams extends StatefulWidget {
  final String examTitle;
  final Function(Map exam) onSelect;

  const Exams({Key key, this.examTitle, this.onSelect}) : super(key: key);
  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Exams>
    with AutomaticKeepAliveClientMixin<Exams> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List<String> selectedSubjects = [];
  List<String> selectedExams = [];
  List exams = [];
  String searchTitle;

  @override
  void initState() {
    super.initState();
    loadExams();
  }

  loadExams() async {
    if (isLoading == true) return;

    setState(() {
      isLoading = true;
    });
    int present = exams.length;

    Map<String, String> payload = {
      C.PRESENT: present.toString(),
      C.PER_PAGE: PER_PAGE_EXAMS,
    };
    if (searchTitle != null) payload[C.TITLE] = searchTitle;
    var examsList = await listExam(payload, selectedSubjects, selectedExams);
    setState(() {
      isLoading = false;
      exams.addAll(examsList);
    });

    if (widget.onSelect == null) {
      // Track Viewed Exam Event
      track(EventName.VIEWED_EXAM_TAB, {
        EventProp.SEARCH: searchTitle,
        EventProp.SUBJECTS: selectedSubjects,
        EventProp.EXAMS: selectedExams,
      });
    }
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
    loadExams();
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
    loadExams();
  }

  // on Search
  @override
  void didUpdateWidget(Exams oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.examTitle != widget.examTitle) {
      onSearch(widget.examTitle);
    }
    // Update list on coming from add exam
    // if (widget.updateExam ?? false) {
    //   onRefresh();
    //   widget.setUpdateExam();
    // }
  }

  onSearch(String value) {
    setState(() {
      exams.clear();
      if (value.isEmpty)
        searchTitle = null;
      else
        searchTitle = value;
    });
    loadExams();
  }

  // On refresh
  Future<void> onRefresh() async {
    setState(() {
      exams.clear();
      loadExams();
    });
  }

  onSelect(exam) async {
    if (widget.onSelect != null) return widget.onSelect(exam);
    var result = await Get.to(() => DetailedExam(
          exam: exam,
          isEditable: true,
        ));

    // Track home screen
    trackScreen(ScreenNames.ExamsTab);

    if (result ?? false) onRefresh();
  }

  // Clear Filter
  clearFilter() {
    setState(() {
      selectedSubjects.clear();
      selectedExams.clear();
      searchTitle = null;
      exams.clear();
      loadExams();
    });
  }

  _update(QuizProvider update) async {
    await Future.delayed(Duration(microseconds: 500));
    update.updateExam = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.onSelect == null) {
      final update = Provider.of<QuizProvider>(context);
      if (update.updateExam) {
        onRefresh();
        _update(update);
      }
    }
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
        if (resultLength == 0 && (isLoading ?? true))
          DetailsSkeleton(
            type: DetailsType.List,
          )
        else if (resultLength == 0)
          EmptyList(onClearFilter: clearFilter)
        else
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if ((scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) &&
                    !isLoading &&
                    _scrollController.position.userScrollDirection ==
                        ScrollDirection.reverse) {
                  loadExams();
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: resultLength,
                  itemBuilder: (context, position) {
                    return ExamCard(
                      exam: exams[position],
                      onTap: () => onSelect(exams[position]),
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
