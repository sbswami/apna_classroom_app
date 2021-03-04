import 'package:apna_classroom_app/api/classroom.dart';
import 'package:apna_classroom_app/components/buttons/arrow_secondary_button.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/chat/chat.dart';
import 'package:apna_classroom_app/screens/classroom/search_person.dart';
import 'package:apna_classroom_app/screens/classroom/widgets/person_card.dart';
import 'package:apna_classroom_app/screens/classroom_notes/classroom_notes.dart';
import 'package:apna_classroom_app/screens/exam_conducted/schedule_exam.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/exam_conducted_list.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double IMAGE_HEIGHT = 150;

class ClassroomDetails extends StatefulWidget {
  final Map classroom;

  const ClassroomDetails({Key key, this.classroom}) : super(key: key);

  @override
  _ClassroomDetailsState createState() => _ClassroomDetailsState();
}

class _ClassroomDetailsState extends State<ClassroomDetails> {
  bool isLoading = true;
  Map<String, dynamic> classroom = {};

  loadClassroom() async {
    Map<String, dynamic> _classroom =
        await getClassroom({C.ID: widget.classroom[C.ID]});
    setState(() {
      classroom = _classroom;
      isLoading = false;
    });
  }

  onShare() {}

  @override
  void initState() {
    super.initState();
    loadClassroom();
  }

  // Schedule Exam
  scheduleExam() async {
    var result = await Get.to(ScheduleExam(
      classroom: widget.classroom,
    ));
    if (result == true) loadClassroom();
  }

  // Add member
  addMember() async {
    var result = await Get.to(SearchPerson());
    if (result == null) return;

    result.removeWhere((element) {
      bool value =
          classroom[C.MEMBERS].any((e) => e[C.ID][C.ID] == element[C.ID]);
      return value;
    });

    if (result.isEmpty) return;

    List membersAll = result
        .map((e) => {
              C.ROLE: E.MEMBER,
              C.ID: e,
            })
        .toList();

    List members = result
        .map((e) => {
              C.ROLE: E.MEMBER,
              C.ID: e[C.ID],
            })
        .toList();

    await addMembers({
      C.ID: classroom[C.ID],
      C.MEMBERS: members,
    });
    setState(() {
      classroom[C.MEMBERS].addAll(membersAll);
    });
  }

  // Delete Classroom
  _onDelete() async {
    var result = await wantToDelete(() {
      return true;
    }, S.CLASSROOM_DELETE_NOTE.tr);
    if (!(result ?? false)) return;
    bool isDeleted = await deleteClassroom({
      C.ID: widget.classroom[C.ID],
    });
    if (!isDeleted)
      return ok(title: S.SOMETHING_WENT_WRONG.tr, msg: S.CAN_NOT_DELETE_NOW.tr);
    Get.back(result: true);
  }

  // Import from excel via
  importViaExcel() {}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.CLASSROOM.tr),
        ),
        body: DetailsSkeleton(
          type: DetailsType.ImageButtonCard,
        ),
      );
    }

    if (classroom == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.CLASSROOM.tr),
        ),
        body: Container(
          margin: const EdgeInsets.all(16.0),
          child: Text(
            S.CLASSROOM_DELETED_BY_CREATOR.tr,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      );
    }

    bool isItAdmin = isAdmin((classroom ?? {})[C.MEMBERS]);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.CLASSROOM.tr),
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0.3,
                  blurRadius: 5,
                ),
              ],
              color: Theme.of(context).cardColor,
            ),
            height: 200,
            child: UrlImage(
              url: classroom[C.PHOTO_URL],
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  widget.classroom[C.TITLE],
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(height: 8.0),
                if (classroom[C.DESCRIPTION] != null)
                  SelectableText(classroom[C.DESCRIPTION]),
                SizedBox(height: 8.0),
                ArrowSecondaryButton(
                  onPress: () {
                    Get.to(Chat(classroom: classroom));
                  },
                  text: S.GO_TO_CHAT.tr,
                  preIcon: Icons.message,
                ),
                SizedBox(height: 8.0),
                if (isItAdmin)
                  ArrowSecondaryButton(
                    onPress: scheduleExam,
                    text: S.SCHEDULE_EXAM.tr,
                    preIcon: Icons.school_rounded,
                  ),
                SizedBox(height: 8.0),
                ArrowSecondaryButton(
                  onPress: () {
                    Get.to(ClassroomNotes(classroom: classroom));
                  },
                  text: S.CLASSROOM_NOTES.tr,
                  preIcon: Icons.book,
                ),
              ],
            ),
          ),
          ExamConductedList(
            runningExam: classroom[C.RUNNING_EXAM],
            upcomingExam: classroom[C.UPCOMING_EXAM],
            completedExam: classroom[C.COMPLETED_EXAM],
            classroomId: classroom[C.ID],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: [
                SizedBox(height: 8.0),
                InfoCard(
                  title: S.WHO_CAN_JOIN.tr,
                  data: getWhoCanJoin(classroom[C.WHO_CAN_JOIN]).tr,
                ),
                InfoCard(
                  title: S.CLASSROOM_PRIVACY.tr,
                  data: getPrivacySt(classroom[C.PRIVACY]).tr,
                ),
                InfoCard(
                  title: S.WHO_CAN_SHARE_NOTES.tr,
                  data: getWhoCanShare(classroom[C.WHO_CAN_SHARE_NOTES]).tr,
                ),
                InfoCard(
                  title: S.WHO_CAN_SHARE_MESSAGES.tr,
                  data: getWhoCanShare(classroom[C.WHO_CAN_SEND_MESSAGES]).tr,
                ),
                InfoCard(
                  title: S.EXAM.tr,
                  child: GroupChips(list: classroom[C.EXAM].cast<String>()),
                ),
                InfoCard(
                  title: S.SUBJECT.tr,
                  child: GroupChips(list: classroom[C.SUBJECT].cast<String>()),
                ),
              ],
            ),
          ),
          if (isItAdmin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SecondaryButton(
                    text: S.ADD_MEMBER.tr,
                    onPress: addMember,
                  ),
                  SecondaryButton(
                    text: S.IMPORT_VIA_EXCEL.tr,
                    onPress: importViaExcel,
                    iconData: Icons.download_rounded,
                  ),
                ],
              ),
            ),
          SizedBox(height: 8.0),
          Column(
            children: classroom[C.MEMBERS].map<Widget>(
              (e) {
                return PersonCard(
                  person: e[C.ID],
                  isAdmin: e[C.ROLE] == E.ADMIN,
                );
              },
            ).toList(),
          ),
          SizedBox(height: 16),
          if (isCreator(classroom[C.CREATED_BY]))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  destructive: true,
                  text: S.DELETE.tr,
                  onPress: _onDelete,
                ),
              ],
            ),
          SizedBox(height: 64),
        ],
      ),
    );
  }
}
