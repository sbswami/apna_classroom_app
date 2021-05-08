import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/question.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/screens/quiz/exam/add_exam.dart';
import 'package:apna_classroom_app/screens/quiz/quiz_provider.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/question_card.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/questions_speed_dial.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

const String PER_PAGE_QUESTION = '10';

class Questions extends StatefulWidget {
  final String questionTitle;
  final Function(List list) onSelect;
  final List selectedQuestion;

  const Questions({
    Key key,
    this.questionTitle,
    this.onSelect,
    this.selectedQuestion,
  }) : super(key: key);
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions>
    with AutomaticKeepAliveClientMixin<Questions> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List<String> selectedSubjects = [];
  List<String> selectedExams = [];
  List questions = [];
  List selectedQuestions = [];
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

    if (widget.onSelect == null) {
      // Track Viewed Question Event
      track(EventName.VIEWED_QUESTION_TAB, {
        EventProp.SEARCH: searchTitle,
        EventProp.SUBJECTS: selectedSubjects,
        EventProp.EXAMS: selectedExams,
      });
    }
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
    // if (widget.updateQuestion ?? false) {
    //   onRefresh();
    //   widget.setUpdateQuestion();
    // }
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
      selectedQuestions.clear();
    });
    await loadQuestion();
  }

  // On Select Question
  bool isSelectable = false;
  onSelectQuestion(question, bool selected) {
    setState(() {
      if (selected)
        selectedQuestions.add(question);
      else {
        selectedQuestions
            .removeWhere((element) => question[C.ID] == element[C.ID]);
        if (selectedQuestions.length == 0 && widget.onSelect == null) {
          isSelectable = false;
        }
      }
    });
  }

  onSelect() {
    widget.onSelect(selectedQuestions);
  }

  onLongPress(BuildContext context, question) {
    setState(() {
      isSelectable = true;
      selectedQuestions.add(question);
    });
  }

  // Create Exam
  createExam() async {
    var questionList = selectedQuestions;
    var result = await Get.to(AddExam(
      questions: questionList,
      accessedFrom: ScreenNames.QuestionsTab,
    ));

    // Track screen back
    trackScreen(ScreenNames.QuestionsTab);

    final update = Provider.of<QuizProvider>(context, listen: false);
    update.updateExam = (result != null);
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

  _update(QuizProvider update) async {
    await Future.delayed(Duration(microseconds: 500));
    update.updateQuestion = false;
  }

  // Delete multiple questions
  _delete() async {
    var result = await wantToDelete(() {
      return true;
    }, S.QUESTION_DELETE_NOTE.tr);
    if (!(result ?? false)) return;
    bool isDeleted = await deleteQuestion({
      C.ID: selectedQuestions.map((e) => e[C.ID]).toList(),
    });
    if (!isDeleted)
      return ok(title: S.SOMETHING_WENT_WRONG.tr, msg: S.CAN_NOT_DELETE_NOW.tr);

    // Track delete event
    selectedQuestions?.forEach((question) {
      track(EventName.DELETE_QUESTION, {
        EventProp.TYPE: question[C.ANSWER_TYPE],
        EventProp.SUBJECTS: question[C.SUBJECT],
        EventProp.EXAMS: question[C.EXAM],
        EventProp.ACCESSED_FROM: ScreenNames.QuestionsTab,
      });
    });
    onRefresh();
  }

  // Floating action button
  _actionButton() {
    if (widget.onSelect != null)
      return FloatingActionButton(
        onPressed: onSelect,
        child: Icon(Icons.check),
      );

    if (isSelectable && selectedQuestions.length > 0)
      return ApnaSpeedDial(
        list: [
          ActionButtonType(
            title: S.DELETE.tr,
            iconData: Icons.delete,
            onPressed: _delete,
          ),
          ActionButtonType(
            title: S.CREATE_EXAM.tr,
            iconData: Icons.add,
            onPressed: createExam,
          ),
        ],
      );
  }

  _actionPosition() {
    if (widget.onSelect != null) return;
    return FloatingActionButtonLocation.startFloat;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.onSelect == null) {
      final update = Provider.of<QuizProvider>(context);
      if (update.updateQuestion) {
        onRefresh();
        _update(update);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int resultLength = questions.length;

    return Scaffold(
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
            )
          else
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
                      final question = questions[position];
                      if (isSelectable) {
                        isSelected = selectedQuestions
                            .any((element) => element[C.ID] == question[C.ID]);
                      }
                      return QuestionCard(
                        question: question,
                        isSelected: isSelected,
                        isEditable: true,
                        onChanged: (value) => onSelectQuestion(question, value),
                        onLongPress: ({BuildContext context}) =>
                            onLongPress(context, question),
                        onRefresh: onRefresh,
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _actionButton(),
      floatingActionButtonLocation: _actionPosition(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
