import 'package:apna_classroom_app/api/classroom.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/screens/classroom/widgets/classroom_card.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ClassroomSelector extends StatefulWidget {
  final Function(List list) onSelect;
  final List<String> selectedClassroom;

  const ClassroomSelector({
    Key key,
    @required this.onSelect,
    @required this.selectedClassroom,
  }) : super(key: key);
  @override
  _ClassroomSelectorState createState() => _ClassroomSelectorState();
}

class _ClassroomSelectorState extends State<ClassroomSelector> {
  ScrollController _scrollController = ScrollController();
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
    super.initState();
    loadClassroom();
  }

  // Load Classroom
  loadClassroom() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    Map<String, String> payload = {
      C.PRESENT: classrooms.length.toString(),
      C.PER_PAGE: '10',
    };
    if (searchTitle != null) payload[C.TITLE] = searchTitle;
    var _classroom =
        await listClassroom(payload, selectedSubjects, selectedExams);

    setState(() {
      isLoading = false;
      classrooms.addAll(_classroom[C.LIST]);
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
  onSelectClassroom(String id, bool selected) {
    setState(() {
      if (selected)
        selectedClassroom.add(id);
      else {
        selectedClassroom.remove(id);
      }
    });
  }

  onSelect() async {
    await widget.onSelect(
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

  // Clear Filter
  clearFilter() {
    setState(() {
      selectedSubjects.clear();
      selectedExams.clear();
      searchTitle = null;
      classrooms.clear();
      loadClassroom();
    });
  }

  @override
  Widget build(BuildContext context) {
    int resultLength = classrooms.length;
    return Scaffold(
      appBar: HomeAppBar(onSearch: onSearch, searchActive: true),
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
              type: DetailsType.PersonList,
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
                  loadClassroom();
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
                    var classroom = classrooms[position];
                    bool isSelected = selectedClassroom
                        .any((element) => element == classroom[C.ID]);

                    return ClassroomCard(
                      classroom: classroom,
                      isSelected: isSelected,
                      onChanged: (value) =>
                          onSelectClassroom(classroom[C.ID], value),
                      onLongPress: ({BuildContext context}) =>
                          onLongPress(context, classroom[C.ID]),
                      onTitleTap: () =>
                          onSelectClassroom(classroom[C.ID], !isSelected),
                      onIconClick: () =>
                          onSelectClassroom(classroom[C.ID], !isSelected),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onSelect,
        child: Icon(Icons.check),
      ),
    );
  }
}
