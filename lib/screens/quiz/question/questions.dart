import 'package:apna_classroom_app/api/question.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/screens/quiz/exam/add_exam.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/question_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

const String PER_PAGE_QUESTION = '10';

class Questions extends StatefulWidget {
  final String questionTitle;
  final Function(List list) onSelect;
  final List<String> selectedQuestion;
  final bool updateQuestion;

  const Questions(
      {Key key,
      this.questionTitle,
      this.onSelect,
      this.selectedQuestion,
      this.updateQuestion})
      : super(key: key);
  @override
  _QuestionsState createState() => _QuestionsState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('updateQuestion', updateQuestion));
  }
}

class _QuestionsState extends State<Questions>
    with AutomaticKeepAliveClientMixin<Questions> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List<String> selectedSubjects = [];
  List<String> selectedExams = [];
  List questions = [];
  List<String> selectedQuestions = [];
  String searchTitle;

  loadQuestion() async {
    if (isLoading == true) return;
    setState(() {
      isLoading = true;
    });
    int present = questions.length;
    Map<String, String> payload = {
      C.PRESENT: present.toString(),
      C.PER_PAGE: PER_PAGE_QUESTION,
    };
    if (searchTitle != null) payload[C.TITLE] = searchTitle;
    var questionList =
        await listQuestion(payload, selectedSubjects, selectedExams);
    setState(() {
      isLoading = false;
      questions.addAll(questionList);
    });
  }

  @override
  void initState() {
    if (widget.selectedQuestion != null) {
      selectedQuestions = widget.selectedQuestion;
    }
    if (widget.onSelect != null) {
      isSelectable = true;
    }
    super.initState();
    loadQuestion();
  }

  // Exam and Subject filters
  bool showFilter = false;
  onSelectedSubject(String subject, bool selected) {
    setState(() {
      if (selected) {
        selectedSubjects.add(subject);
      } else {
        selectedSubjects.remove(subject);
      }
      questions.clear();
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
      questions.clear();
    });
    loadQuestion();
  }

  // On Search
  @override
  void didUpdateWidget(Questions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionTitle != widget.questionTitle) {
      onSearch(widget.questionTitle);
    }

    // Update list on coming from add question
    if (widget.updateQuestion ?? false) {
      onRefresh();
    }
  }

  onSearch(String value) {
    setState(() {
      questions.clear();
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
      questions.clear();
    });
    await loadQuestion();
  }

  // On Select Question
  bool isSelectable = false;
  onSelectQuestion(String id, bool selected) {
    setState(() {
      if (selected)
        selectedQuestions.add(id);
      else {
        selectedQuestions.remove(id);
        if (selectedQuestions.length == 0 && widget.onSelect == null) {
          isSelectable = false;
        }
      }
    });
  }

  onSelect() {
    widget.onSelect(
      questions
          .where(
            (element) => selectedQuestions.contains(element[C.ID]),
          )
          .toList(),
    );
  }

  onLongPress(BuildContext context, String id) {
    setState(() {
      isSelectable = true;
      selectedQuestions.add(id);
    });
  }

  // Create Exam
  createExam() {
    Get.to(AddExam(
      questions: questions
          .where(
            (element) => selectedQuestions.contains(element[C.ID]),
          )
          .toList(),
    ));
  }

  // Clear Filter
  clearFilter() {
    setState(() {
      selectedSubjects.clear();
      selectedExams.clear();
      searchTitle = null;
      questions.clear();
      loadQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int resultLength = questions.length;
    bool showCreateExam =
        isSelectable && widget.onSelect == null && selectedQuestions.length > 0;
    return Scaffold(
      floatingActionButton: widget.onSelect != null
          ? FloatingActionButton(
              onPressed: onSelect,
              child: Icon(Icons.check),
            )
          : null,
      body: Column(
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
            EmptyList(
              onClearFilter: clearFilter,
            ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if ((scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) &&
                    !isLoading &&
                    _scrollController.position.userScrollDirection ==
                        ScrollDirection.reverse) {
                  loadQuestion();
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
                    bool isSelected;
                    if (isSelectable) {
                      isSelected = selectedQuestions.any(
                          (element) => element == questions[position][C.ID]);
                    }
                    return QuestionCard(
                      question: questions[position],
                      isSelected: isSelected,
                      isEditable: true,
                      onChanged: (value) =>
                          onSelectQuestion(questions[position][C.ID], value),
                      onLongPress: ({BuildContext context}) =>
                          onLongPress(context, questions[position][C.ID]),
                      onRefresh: onRefresh,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: showCreateExam
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  text: S.CREATE_EXAM.tr,
                  onPress: createExam,
                ),
              ],
            )
          : null,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
