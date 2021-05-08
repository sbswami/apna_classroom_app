import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/classroom.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/chat/chat.dart';
import 'package:apna_classroom_app/screens/classroom/add_classroom.dart';
import 'package:apna_classroom_app/screens/classroom/classrooms_public.dart';
import 'package:apna_classroom_app/screens/classroom/controllers/classroom_list_controller.dart';
import 'package:apna_classroom_app/screens/classroom/widgets/classroom_card.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/screens/home/widgets/apna_bottom_navigation_bar.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_drawer.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

const String LIMIT = '1000';

class Classroom extends StatefulWidget {
  final PageController pageController;
  const Classroom({Key key, this.pageController}) : super(key: key);
  @override
  _ClassroomState createState() => _ClassroomState();
}

class _ClassroomState extends State<Classroom>
    with AutomaticKeepAliveClientMixin<Classroom> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List<String> selectedSubjects = [];
  List<String> selectedExams = [];
  String searchTitle;

  @override
  void initState() {
    super.initState();
    ClassroomListController.to.resetClassrooms();
    loadClassroom();
  }

  // Load Classroom
  loadClassroom() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    Map<String, String> payload = {
      C.PRESENT: ClassroomListController.to.classrooms.length.toString(),
      C.PER_PAGE: LIMIT,
    };
    if (searchTitle != null) payload[C.TITLE] = searchTitle;
    var _classroom =
        await listClassroom(payload, selectedSubjects, selectedExams);

    setState(() {
      isLoading = false;
      if (_classroom != null) {
        ClassroomListController.to.addClassrooms(_classroom[C.LIST]);
      }
    });

    // Track Viewed Classrooms Event
    track(EventName.VIEWED_CLASSROOM_TAB, {
      EventProp.SEARCH: searchTitle,
      EventProp.SUBJECTS: selectedSubjects,
      EventProp.EXAMS: selectedExams,
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
      ClassroomListController.to.resetClassrooms();
    });
    loadClassroom();
  }

  onSelectedExam(String exam, bool selected) {
    setState(() {
      if (selected) {
        selectedExams.add(exam);
      } else {
        selectedExams.remove(exam);
      }
      ClassroomListController.to.resetClassrooms();
    });
    loadClassroom();
  }

  // On Search
  onSearch(String value) {
    setState(() {
      ClassroomListController.to.resetClassrooms();
      if (value.isEmpty)
        searchTitle = null;
      else
        searchTitle = value;
    });
    loadClassroom();
  }

  // On Title Click
  onTitleClick(Map classroom, int index) async {
    await Get.to(Chat(classroom: classroom));

    // Set current back
    trackScreen(ScreenNames.ClassroomTab);
  }

  // On refresh
  Future<void> onRefresh() async {
    ClassroomListController.to.resetClassrooms();
    loadClassroom();
  }

  // Open Public Classrooms
  openPublicClassrooms() async {
    await Get.to(ClassroomPublic());
    // Set this screen back
    trackScreen(ScreenNames.ClassroomTab);
    ClassroomListController.to.resetClassrooms();
    loadClassroom();
  }

  // Clear Filter
  clearFilter() {
    setState(() {
      selectedSubjects.clear();
      selectedExams.clear();
      searchTitle = null;
      ClassroomListController.to.resetClassrooms();
      loadClassroom();
    });
  }

  // Add
  _add() async {
    var result = await Get.to(AddClassroom());
    // Set Back Classroom screen
    trackScreen(ScreenNames.ClassroomTab);
    if (result ?? false) onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: HomeAppBar(onSearch: onSearch),
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
          Expanded(
            child: Obx(() {
              int classroomLength =
                  ClassroomListController.to.classrooms?.length;
              if (classroomLength == 0 && (isLoading ?? true)) {
                return DetailsSkeleton(
                  type: DetailsType.PersonList,
                );
              } else if (classroomLength == 0) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      EmptyList(
                        onClearFilter: clearFilter,
                      ),
                      _PublicClassroomButton(
                        openPublicClassrooms: openPublicClassrooms,
                      ),
                    ],
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
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
                    itemCount: classroomLength + 1,
                    itemBuilder: (context, position) {
                      if (position == classroomLength) {
                        return _PublicClassroomButton(
                          openPublicClassrooms: openPublicClassrooms,
                        );
                      }
                      var classroom =
                          ClassroomListController.to.classrooms[position];

                      return ClassroomCard(
                        classroom: classroom,
                        onTitleTap: () => onTitleClick(classroom, position),
                        onRefresh: onRefresh,
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      drawer: HomeDrawer(),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: _add,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: ApnaBottomNavigationBar(
        pageController: widget.pageController,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _PublicClassroomButton extends StatelessWidget {
  final openPublicClassrooms;

  const _PublicClassroomButton({Key key, this.openPublicClassrooms})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 24.0),
      child: SecondaryButton(
        iconData: Icons.public_rounded,
        text: S.SEE_PUBLIC_CLASSROOMS.tr,
        onPress: openPublicClassrooms,
      ),
    );
  }
}
