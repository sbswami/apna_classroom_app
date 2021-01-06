import 'package:apna_classroom_app/api/classroom.dart';
import 'package:apna_classroom_app/components/skeletons/list_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/screens/classroom/widgets/classroom_card.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Classroom extends StatefulWidget {
  final Function(List list) onSelect;
  final List<String> selectedClassroom;

  const Classroom({Key key, this.onSelect, this.selectedClassroom})
      : super(key: key);
  @override
  _ClassroomState createState() => _ClassroomState();
}

class _ClassroomState extends State<Classroom>
    with AutomaticKeepAliveClientMixin<Classroom> {
  bool isLoading = false;
  List<String> selectedSubjects = [];
  List<String> selectedExams = [];
  List classrooms = [];
  List<String> selectedClassroom = [];
  String searchTitle;

  @override
  void initState() {
    if (widget.selectedClassroom != null) {
      selectedClassroom = widget.selectedClassroom;
    }
    if (widget.onSelect != null) {
      isSelectable = true;
    }
    super.initState();
    loadClassroom();
  }

  // Load Classroom
  loadClassroom() async {
    if (isLoading == true) return;
    setState(() {
      isLoading = true;
    });
    int present = classrooms.length;
    Map<String, String> payload = {
      C.PRESENT: present.toString(),
      C.PER_PAGE: '10',
    };
    if (searchTitle != null) payload[C.TITLE] = searchTitle;
    var questionList =
        await listClassroom(payload, selectedSubjects, selectedExams);
    setState(() {
      isLoading = false;
      classrooms.addAll(questionList);
    });
  }

  // Exam and Subject filters
  onSelectedSubject(String subject, bool selected) {
    setState(() {
      if (selected) {
        selectedSubjects.add(subject);
      } else {
        selectedSubjects.remove(subject);
      }
      classrooms.clear();
    });
    loadClassroom();
  }

  onSelectedExam(String subject, bool selected) {
    setState(() {
      if (selected) {
        selectedExams.add(subject);
      } else {
        selectedExams.remove(subject);
      }
      classrooms.clear();
    });
    loadClassroom();
  }

  // On Search
  onSearch(String value) {
    setState(() {
      classrooms.clear();
      if (value.isEmpty)
        searchTitle = null;
      else
        searchTitle = value;
    });
    loadClassroom();
  }

  // On Select Question
  bool isSelectable = false;
  onSelectClassroom(String id, bool selected) {
    setState(() {
      if (selected)
        selectedClassroom.add(id);
      else {
        selectedClassroom.remove(id);
        if (selectedClassroom.length == 0 && widget.onSelect == null) {
          isSelectable = false;
        }
      }
    });
  }

  onSelect() {
    widget.onSelect(
      classrooms
          .where(
            (element) => selectedClassroom.contains(element[C.ID]),
          )
          .toList(),
    );
    Get.back();
  }

  onLongPress(BuildContext context, String id) {
    setState(() {
      isSelectable = true;
      selectedClassroom.add(id);
    });
  }

  // On refresh
  Future<void> onRefresh() async {
    setState(() {
      classrooms.clear();
    });
    await loadClassroom();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int resultLength = classrooms.length;
    return Scaffold(
      appBar:
          HomeAppBar(onSearch: onSearch, searchActive: widget.onSelect != null),
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
            ListSkeleton(
              size: 4,
              person: true,
            ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if ((scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) &&
                    !isLoading) {
                  loadClassroom();
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView.builder(
                  itemCount: resultLength,
                  itemBuilder: (context, position) {
                    bool isSelected;
                    if (isSelectable) {
                      isSelected = selectedClassroom.any(
                          (element) => element == classrooms[position][C.ID]);
                    }
                    return ClassroomCard(
                      classroom: classrooms[position],
                      isSelected: isSelected,
                      onChanged: (value) =>
                          onSelectClassroom(classrooms[position][C.ID], value),
                      onLongPress: ({BuildContext context}) =>
                          onLongPress(context, classrooms[position][C.ID]),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.onSelect != null
          ? FloatingActionButton(
              onPressed: onSelect,
              child: Icon(Icons.check),
            )
          : null,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
