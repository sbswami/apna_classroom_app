import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/classroom.dart';
import 'package:apna_classroom_app/api/join_request.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom/widgets/classroom_card.dart';
import 'package:apna_classroom_app/screens/empty/empty_list.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ClassroomPublic extends StatefulWidget {
  const ClassroomPublic({Key key}) : super(key: key);
  @override
  _ClassroomPublicState createState() => _ClassroomPublicState();
}

class _ClassroomPublicState extends State<ClassroomPublic> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List<String> selectedSubjects = [];
  List<String> selectedExams = [];
  String searchTitle;
  List classrooms = [];

  @override
  void initState() {
    super.initState();

    // Set Screen
    trackScreen(ScreenNames.ClassroomsPublic);

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
      C.PUBLIC: 'true',
    };
    if (searchTitle != null) payload[C.TITLE] = searchTitle;
    var _classroom =
        await listClassroom(payload, selectedSubjects, selectedExams);

    setState(() {
      isLoading = false;
      classrooms.addAll(_classroom[C.LIST]);
    });

    // Track Public classroom event
    track(EventName.SEE_PUBLIC_CLASSROOMS, {
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
      classrooms.clear();
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

  // On Title Click
  onTitleClick(Map classroom, int index) {
    if (classroom[C.JOIN_REQUEST] != null) {
      return wantToDelete(
        () => _deleteJoinRequest(classroom, index),
        S.DELETE_JOIN_REQUEST.tr,
      );
    }
    joinRequest(classroom, index);
  }

  joinRequest(Map classroom, int index) {
    if (classroom[C.WHO_CAN_JOIN] == E.ANYONE) {
      return yesOrNo(
        title: S.JOIN.tr,
        msg: S.WANT_TO_JOIN.trParams({
          C.TITLE: classroom[C.TITLE],
        }),
        yesName: S.JOIN.tr,
        yes: () => join(classroom, index),
        noName: S.CANCEL.tr,
      );
    }
    if (classroom[C.WHO_CAN_JOIN] == E.REQUEST_BEFORE_JOIN) {
      return yesOrNo(
        title: S.JOIN.tr,
        msg: S.DO_YOU_WANT_SEND_JOIN_REQUEST
            .trParams({C.TITLE: classroom[C.TITLE]}),
        yesName: S.SEND_REQUEST.tr,
        yes: () => sendRequest(classroom, index),
        noName: S.CANCEL.tr,
      );
    }
  }

  // Join
  join(Map classroom, int index) async {
    await joinClassroom(classroom);
    setState(() {
      classrooms.removeAt(index);
    });
    // Track event Joined event
    track(EventName.JOIN_CLASSROOM, {EventProp.TYPE: 'Joined'});
  }

  // Send Join request
  sendRequest(Map classroom, int index) async {
    var joinRequest = await createJoinRequest({C.CLASSROOM: classroom[C.ID]});
    Get.snackbar(classroom[C.TITLE], S.YOU_HAVE_REQUESTED_TO_JOIN.tr);
    setState(() {
      classroom[C.JOIN_REQUEST] = joinRequest;
      classrooms[index] = classroom;
    });

    // Track event Requested event
    track(EventName.JOIN_CLASSROOM, {EventProp.TYPE: 'Requested'});
  }

  // Delete join request
  _deleteJoinRequest(Map classroom, int index) async {
    await deleteJoinRequest({C.ID: classroom[C.JOIN_REQUEST][C.ID]});
    setState(() {
      classroom.remove(C.JOIN_REQUEST);
      classrooms[index] = classroom;
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
      appBar: HomeAppBar(
        onSearch: onSearch,
        searchActive: true,
      ),
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
            EmptyList(onClearFilter: clearFilter),
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
                    return ClassroomCard(
                      classroom: classroom,
                      isPublic: true,
                      onTitleTap: () => onTitleClick(classroom, position),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
