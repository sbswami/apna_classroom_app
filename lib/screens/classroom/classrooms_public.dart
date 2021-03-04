import 'package:apna_classroom_app/api/classroom.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
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
    joinRequest(classroom, index);
  }

  joinRequest(Map classroom, int index) {
    if (classroom[C.WHO_CAN_JOIN] == E.ANYONE) {
      return yesOrNo(
        title: S.JOIN.tr,
        msg: '"${classroom[C.TITLE]}", want to join',
        yesName: S.JOIN.tr,
        yes: () => join(classroom, index),
        noName: S.CANCEL.tr,
      );
    }
    if (classroom[C.WHO_CAN_JOIN] == E.REQUEST_BEFORE_JOIN) {
      return yesOrNo(
        title: S.JOIN.tr,
        msg: '"${classroom[C.TITLE]}", do you want send join request?',
        yesName: S.SEND_REQUEST.tr,
        yes: () => sendRequest(classroom, index),
        noName: S.CANCEL.tr,
      );
    }
  }

  join(Map classroom, int index) async {
    await addMembers({
      C.ID: classroom[C.ID],
      C.MEMBERS: [
        {
          C.ID: getUserId(),
          C.ROLE: E.MEMBER,
        }
      ]
    });
    setState(() {
      classrooms.removeAt(index);
    });
  }

  sendRequest(Map classroom, int index) {}

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
