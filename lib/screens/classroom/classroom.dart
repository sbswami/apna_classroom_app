import 'package:apna_classroom_app/api/classroom.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/skeletons/list_skeleton.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/chat/chat.dart';
import 'package:apna_classroom_app/screens/classroom/controllers/classroom_list_controller.dart';
import 'package:apna_classroom_app/screens/classroom/widgets/classroom_card.dart';
import 'package:apna_classroom_app/screens/home/widgets/home_app_bar.dart';
import 'package:apna_classroom_app/screens/notes/widgets/subject_filter.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
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

  int present = 0;
  bool isPublic = false;

  @override
  void initState() {
    if (widget.selectedClassroom != null) {
      selectedClassroom = widget.selectedClassroom;
    }
    if (widget.onSelect != null) {
      isSelectable = true;
    }
    super.initState();
    ClassroomListController.to.resetClassrooms();
    // The issue is, this screen also used to select classrooms
    loadClassroom();
  }

  // Load Classroom
  loadClassroom() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    Map<String, String> payload = {
      C.PRESENT: present.toString(),
      C.PER_PAGE: '10',
      C.PUBLIC: isPublic.toString(),
    };
    if (searchTitle != null) payload[C.TITLE] = searchTitle;
    var _classroom =
        await listClassroom(payload, selectedSubjects, selectedExams);

    if (_classroom[C.PUBLIC] && !isPublic) {
      isPublic = true;
      _classroom[C.LIST].add({C.PUBLIC: true});
      present = 0;
    } else {
      present += _classroom[C.LIST].length;
    }
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

  // On Title Click
  onTitleClick(Map classroom, bool _public, int index) {
    if (_public) return joinRequest(classroom, index);
    Get.to(Chat(classroom: classroom));
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
        yes: () => join(classroom, index),
        noName: S.CANCEL.tr,
      );
    }
  }

  join(Map classroom, int index) async {
    await addMembers({
      C.ID: classroom[C.ID],
      C.MEMBERS: [
        {
          C.ID: UserController.to.currentUser[C.ID],
          C.ROLE: E.MEMBER,
        }
      ]
    });
    setState(() {
      classrooms.removeAt(index);
      classrooms.insert(0, classroom);
      --present;
    });
  }

  // On refresh
  Future<void> onRefresh() async {
    setState(() {
      classrooms.clear();
      present = 0;
      isPublic = false;
    });
    await loadClassroom();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int resultLength = classrooms.length;
    fromNowPublic = false;
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
                    var classroom = classrooms[position];
                    if (classroom[C.PUBLIC] ?? false) {
                      fromNowPublic = true;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          S.PUBLIC_CLASSROOMS.tr,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    bool isSelected;
                    if (isSelectable) {
                      isSelected = selectedClassroom.any(
                          (element) => element == classrooms[position][C.ID]);
                    }
                    return ClassroomCard(
                      classroom: classroom,
                      isSelected: isSelected,
                      onChanged: (value) =>
                          onSelectClassroom(classroom[C.ID], value),
                      onLongPress: ({BuildContext context}) =>
                          onLongPress(context, classroom[C.ID]),
                      isPublic: fromNowPublic,
                      onTitleTap: (_public) =>
                          onTitleClick(classroom, _public, position),
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

bool fromNowPublic = false;
