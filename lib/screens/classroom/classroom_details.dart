import 'package:apna_classroom_app/api/classroom.dart';
import 'package:apna_classroom_app/components/buttons/arrow_secondary_button.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/components/skeletons/list_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/exam_conducted/schedule_exam.dart';
import 'package:apna_classroom_app/util/c.dart';
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
    print(_classroom);
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
  scheduleExam() {
    Get.to(ScheduleExam(
      classroom: widget.classroom,
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.CLASSROOM.tr),
        ),
        body: ListSkeleton(size: 3),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(S.CLASSROOM.tr),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: Offset(0, 1.0),
              ),
            ]),
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
                  onPress: () {},
                  text: S.GO_TO_CHAT.tr,
                  preIcon: Icons.message,
                ),
                SizedBox(height: 8.0),
                ArrowSecondaryButton(
                  onPress: scheduleExam,
                  text: S.SCHEDULE_EXAM.tr,
                  preIcon: Icons.school_rounded,
                ),
                SizedBox(height: 8.0),
                ArrowSecondaryButton(
                  onPress: () {},
                  text: S.CLASSROOM_NOTES.tr,
                  preIcon: Icons.book,
                ),
                SizedBox(height: 8.0),
                Text(
                  S.RUNNING_EXAM.tr,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  S.UPCOMING_EXAM.tr,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Text(
                  S.COMPLETED_EXAM.tr,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
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
          )
        ],
      ),
    );
  }
}
