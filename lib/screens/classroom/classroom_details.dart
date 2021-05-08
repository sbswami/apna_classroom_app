import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/classroom.dart';
import 'package:apna_classroom_app/api/join_request.dart';
import 'package:apna_classroom_app/api/report.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/buttons/arrow_secondary_button.dart';
import 'package:apna_classroom_app/components/buttons/primary_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/cards/detailed_card.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/chips/group_chips.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/single_input_dialog.dart';
import 'package:apna_classroom_app/components/dialogs/yes_no_dialog.dart';
import 'package:apna_classroom_app/components/images/UrlImage.dart';
import 'package:apna_classroom_app/components/menu/apna_menu.dart';
import 'package:apna_classroom_app/components/menu/menu_item.dart';
import 'package:apna_classroom_app/components/share/apna_share.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/chat/chat.dart';
import 'package:apna_classroom_app/screens/classroom/add_classroom.dart';
import 'package:apna_classroom_app/screens/classroom/search_person.dart';
import 'package:apna_classroom_app/screens/classroom/widgets/person_card.dart';
import 'package:apna_classroom_app/screens/classroom_notes/classroom_notes.dart';
import 'package:apna_classroom_app/screens/exam_conducted/schedule_exam.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/exam_conducted_list.dart';
import 'package:apna_classroom_app/screens/join_requests/join_requests.dart';
import 'package:apna_classroom_app/screens/profile/person_details.dart';
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
  Map<String, dynamic> classroom = {};
  ClassroomStates state = ClassroomStates.Loading;

  loadClassroom() async {
    Map<String, dynamic> _classroom =
        await getClassroom({C.ID: widget.classroom[C.ID]});

    if (_classroom == null) {
      state = ClassroomStates.Deleted;
    } else if (_classroom[C.CREATED_BY] != null) {
      state = ClassroomStates.Access;
    } else if (_classroom[C.WHO_CAN_JOIN] != null) {
      if (_classroom[C.WHO_CAN_JOIN] == E.ANYONE) {
        state = ClassroomStates.PublicJoinAllowed;
      } else {
        state = ClassroomStates.PublicSendRequest;
      }
    } else if (_classroom[C.PRIVACY] != null &&
        _classroom[C.PRIVACY] == E.PRIVATE) {
      state = ClassroomStates.Private;
    } else {
      state = ClassroomStates.Deleted;
    }

    setState(() {
      classroom = _classroom;
    });

    // Track event
    if (_classroom == null) {
      track(EventName.VIEWED_CLASSROOM_DETAILS, {
        EventProp.TYPE: state.toString(),
      });
    } else {
      track(EventName.VIEWED_CLASSROOM_DETAILS, {
        EventProp.PRIVACY: classroom[C.PRIVACY],
        EventProp.SUBJECTS: classroom[C.SUBJECT],
        EventProp.EXAMS: classroom[C.EXAM],
        EventProp.WHO_CAN_SHARE_MESSAGE: classroom[C.WHO_CAN_SEND_MESSAGES],
        EventProp.WHO_CAN_JOIN: classroom[C.WHO_CAN_JOIN],
        EventProp.TYPE: state.toString(),
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Set current screen
    trackScreen(ScreenNames.ClassroomDetails);
    loadClassroom();
  }

  // Schedule Exam
  scheduleExam() async {
    var result = await Get.to(ScheduleExam(
      classroom: (classroom ?? widget.classroom),
    ));

    // Track Back Screen
    trackScreen(ScreenNames.ClassroomDetails);

    if (result == true) loadClassroom();
  }

  // Add member
  addMember() async {
    var result = await Get.to(SearchPerson());

    // Track Back this screen
    trackScreen(ScreenNames.ClassroomDetails);

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

  // Delete Member
  _deleteMember(String id) async {
    await removeMember({
      C.ID: classroom[C.ID],
      C.USER: id,
    });
    setState(() {
      classroom[C.MEMBERS].removeWhere((element) => element[C.ID][C.ID] == id);
    });

    // Track Leave event
    track(EventName.LEAVE_CLASSROOM, {
      EventProp.PRIVACY: classroom[C.PRIVACY],
      EventProp.EXAMS: classroom[C.EXAM],
      EventProp.SUBJECTS: classroom[C.SUBJECT],
      EventProp.SELF: false,
    });

    Get.back();
  }

  makeAdmin(member) async {
    await _deleteMember(member[C.ID]);
    await addMembers({
      C.ID: classroom[C.ID],
      C.MEMBERS: [
        {
          C.ROLE: E.ADMIN,
          C.ID: member[C.ID],
        }
      ],
    });
    setState(() {
      classroom[C.MEMBERS].add({
        C.ROLE: E.ADMIN,
        C.ID: member,
      });
    });
  }

  notAdmin(member) async {
    await _deleteMember(member[C.ID]);
    await addMembers({
      C.ID: classroom[C.ID],
      C.MEMBERS: [
        {
          C.ROLE: E.MEMBER,
          C.ID: member[C.ID],
        }
      ],
    });
    setState(() {
      classroom[C.MEMBERS].add({
        C.ROLE: E.MEMBER,
        C.ID: member,
      });
    });
  }

  // Member long press
  _onLongPress(member, BuildContext context) {
    var _member = member[C.ID];

    if (classroom[C.CREATED_BY] == _member[C.ID]) return;

    bool _isAdmin = isAdmin(classroom[C.MEMBERS]);
    List<MenuItem> items = [];

    if (_isAdmin) {
      items.add(MenuItem(
        iconData: Icons.delete,
        text: S.REMOVE.tr,
        onTap: () => _deleteMember(_member[C.ID]),
      ));
      if (member[C.ROLE] == E.ADMIN) {
        items.add(MenuItem(
          iconData: Icons.person_remove_alt_1_rounded,
          text: S.NOT_ADMIN.tr,
          onTap: () => notAdmin(_member),
        ));
      } else {
        items.add(MenuItem(
          iconData: Icons.person,
          text: S.MAKE_ADMIN.tr,
          onTap: () => makeAdmin(_member),
        ));
      }
      showApnaMenu(context, items);
    }
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
    if (!isDeleted) {
      return ok(title: S.SOMETHING_WENT_WRONG.tr, msg: S.CAN_NOT_DELETE_NOW.tr);
    }

    // Track delete event
    track(EventName.DELETE_CLASSROOM, {
      EventProp.MEMBER_COUNT: classroom[C.MEMBERS]?.length,
      EventProp.PRIVACY: classroom[C.PRIVACY],
      EventProp.EXAMS: classroom[C.EXAM],
      EventProp.SUBJECTS: classroom[C.SUBJECT],
    });

    Get.back(result: true);
  }

  // on Leave Classroom
  _onLeave() async {
    var result = await wantToLeave(
        onLeave: () {
          return true;
        },
        msg: S.LEAVE_CLASSROOM_MESSAGE.tr,
        title: classroom[C.TITLE]);

    if (!(result ?? false)) return;

    bool isRemoved = await removeMember({
      C.ID: classroom[C.ID],
      C.USER: getUserId(),
    });

    if (!isRemoved) {
      return ok(
        title: S.SOMETHING_WENT_WRONG.tr,
        msg: S.THIS_SHOULD_NOT_HAPPEN.tr,
      );
    }

    // Track Leave event
    track(EventName.LEAVE_CLASSROOM, {
      EventProp.PRIVACY: classroom[C.PRIVACY],
      EventProp.EXAMS: classroom[C.EXAM],
      EventProp.SUBJECTS: classroom[C.SUBJECT],
      EventProp.SELF: true,
    });

    Get.back(result: true);
  }

  // On Report Classroom
  _onReport() async {
    var text = await showSingleInputDialog(
      maxChar: 1000,
      title: S.REPORT.tr,
      labelText: S.ENTER_YOUR_COMPLAIN.tr,
    );

    if (text == null) return;

    var report = await createReport({
      C.TEXT: text,
      C.TYPE: E.CLASSROOM,
      C.CLASSROOM: classroom[C.ID],
    });

    if (report != null) {
      // Track Report event
      track(EventName.REPORT_CLASSROOM, {
        EventProp.PRIVACY: classroom[C.PRIVACY],
        EventProp.EXAMS: classroom[C.EXAM],
        EventProp.SUBJECTS: classroom[C.SUBJECT],
        EventProp.WHO_CAN_JOIN: classroom[C.WHO_CAN_JOIN],
      });

      return ok(
        title: S.REPORT.tr,
        msg: S.REPORT_SUBMITTED_MESSAGE.tr,
      );
    }
  }

  // Edit
  bool isEdited = false;
  _onEdit() async {
    var result = await Get.to(AddClassroom(classroom: classroom));
    // Set back screen
    trackScreen(ScreenNames.ClassroomDetails);
    if (result ?? false) {
      setState(() {
        state = ClassroomStates.Loading;
        classroom = null;
        isEdited = true;
      });
      loadClassroom();
    }
  }

  // On Back
  Future<bool> _onBack() async {
    Get.back(result: isEdited);
    return false;
  }

  // Share
  _shareDeepLink() async {
    apnaShare(SharingContentType.Classroom, classroom);

    // Track Share
    track(EventName.SHARE_CLASSROOM, {
      EventProp.PRIVACY: classroom[C.PRIVACY],
      EventProp.WHO_CAN_JOIN: classroom[C.WHO_CAN_JOIN],
      EventProp.EXAMS: classroom[C.EXAM],
      EventProp.SUBJECTS: classroom[C.SUBJECT],
    });
  }

  // Join Classroom
  _join() async {
    await joinClassroom(classroom);
    _onBack();
  }

  // Send Join request
  _sendRequest() async {
    await createJoinRequest({C.CLASSROOM: widget.classroom[C.ID]});
    Get.snackbar(classroom[C.TITLE], S.YOU_HAVE_REQUESTED_TO_JOIN.tr);
    Get.back();
    Get.back();
  }

  // On Refresh
  Future<void> onRefresh() async {
    setState(() {
      state = ClassroomStates.Loading;
    });
    loadClassroom();
  }

  @override
  Widget build(BuildContext context) {
    bool updatable = isCreator((classroom ?? {})[C.CREATED_BY]);
    bool isItAdmin = isAdmin((classroom ?? {})[C.MEMBERS]);
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        appBar: AppBar(title: Text(S.CLASSROOM.tr), actions: [
          if (state == ClassroomStates.Access)
            IconButton(icon: Icon(Icons.share), onPressed: _shareDeepLink)
        ]),
        body: Builder(builder: (BuildContext context) {
          switch (state) {
            case ClassroomStates.Loading:
              return DetailsSkeleton(
                type: DetailsType.ImageButtonCard,
              );
              break;
            case ClassroomStates.Access:
              var showJoinRequests = isItAdmin &&
                  classroom[C.PRIVACY] == E.PUBLIC &&
                  classroom[C.WHO_CAN_JOIN] == E.REQUEST_BEFORE_JOIN;
              return RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    Container(
                      height: 200,
                      child: UrlImage(
                        url: (classroom[C.MEDIA] ?? {})[C.URL],
                        fit: BoxFit.cover,
                        borderRadius: 0.0,
                        fileName: FileName.MAIN,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SelectableText(
                            (classroom ?? widget.classroom)[C.TITLE],
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          SizedBox(height: 8.0),
                          ArrowSecondaryButton(
                            onPress: () async {
                              await Get.to(Chat(classroom: classroom));
                              // Track classroom back
                              trackScreen(ScreenNames.ClassroomTab);
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
                            onPress: () async {
                              await Get.to(
                                  ClassroomNotes(classroom: classroom));
                              // Track Screen Back
                              trackScreen(ScreenNames.ClassroomDetails);
                            },
                            text: S.CLASSROOM_NOTES.tr,
                            preIcon: Icons.book,
                          ),
                          SizedBox(height: 8.0),
                          if (showJoinRequests)
                            ArrowSecondaryButton(
                              onPress: () async {
                                await Get.to(() => JoinRequests(
                                      classroom: widget.classroom,
                                    ));

                                // Track Screen Back
                                trackScreen(ScreenNames.ClassroomDetails);
                              },
                              text: S.JOIN_REQUESTS.tr,
                              preIcon: Icons.nature_people_rounded,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 8.0),
                          InfoCard(
                            title: S.CLASSROOM_DESCRIPTION.tr,
                            data: classroom[C.DESCRIPTION],
                          ),
                          if (classroom[C.PRIVACY] == E.PUBLIC)
                            InfoCard(
                              title: S.WHO_CAN_JOIN.tr,
                              data: getWhoCanJoin(classroom[C.WHO_CAN_JOIN]).tr,
                            ),
                          InfoCard(
                            title: S.CLASSROOM_PRIVACY.tr,
                            data: getPrivacySt(classroom[C.PRIVACY]).tr,
                          ),
                          InfoCard(
                            title: S.WHO_CAN_SHARE_MESSAGES.tr,
                            data: getWhoCanShare(
                                    classroom[C.WHO_CAN_SEND_MESSAGES])
                                .tr,
                          ),
                          InfoCard(
                            title: S.EXAM.tr,
                            child: GroupChips(
                                list: classroom[C.EXAM].cast<String>()),
                          ),
                          InfoCard(
                            title: S.SUBJECT.tr,
                            child: GroupChips(
                                list: classroom[C.SUBJECT].cast<String>()),
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
                            onLongPress: ({BuildContext context}) =>
                                _onLongPress(e, context),
                            onTap: () async {
                              await Get.to(
                                () => PersonDetails(person: e[C.ID]),
                              );

                              // Track screen back
                              trackScreen(ScreenNames.ClassroomDetails);
                            },
                          );
                        },
                      ).toList(),
                    ),
                    SizedBox(height: 32),
                    if (updatable)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryButton(
                            destructive: true,
                            text: S.DELETE.tr,
                            onPress: _onDelete,
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          PrimaryButton(
                            destructive: true,
                            text: S.REPORT.tr,
                            onPress: _onReport,
                          ),
                          PrimaryButton(
                            destructive: true,
                            text: S.LEAVE.tr,
                            onPress: _onLeave,
                          ),
                        ],
                      ),
                    SizedBox(height: 72),
                  ],
                ),
              );
            case ClassroomStates.Private:
              return DetailedCard(
                text: S.YOU_DO_NOT_HAVE_ACCESS_CLASSROOM.tr,
                onOkay: _onBack,
              );
              break;
            case ClassroomStates.Deleted:
              return DetailedCard(
                text: S.CLASSROOM_DELETED_BY_CREATOR.tr,
                onOkay: _onBack,
              );
              break;
            case ClassroomStates.PublicJoinAllowed:
              return DetailedCard(
                text: S.WANT_TO_JOIN.trParams({
                  C.TITLE: classroom[C.TITLE],
                }),
                buttons: [
                  SecondaryButton(
                    text: S.CANCEL.tr,
                    onPress: _onBack,
                  ),
                  PrimaryButton(
                    text: S.JOIN.tr,
                    onPress: _join,
                  ),
                ],
              );
              break;
            case ClassroomStates.PublicSendRequest:
              return DetailedCard(
                text: S.DO_YOU_WANT_SEND_JOIN_REQUEST.trParams({
                  C.TITLE: classroom[C.TITLE],
                }),
                buttons: [
                  SecondaryButton(
                    text: S.CANCEL.tr,
                    onPress: _onBack,
                  ),
                  PrimaryButton(
                    text: S.SEND_REQUEST.tr,
                    onPress: _sendRequest,
                  ),
                ],
              );
              break;
          }
          return SizedBox();
        }),
        floatingActionButton: updatable
            ? FloatingActionButton(
                onPressed: _onEdit,
                child: Icon(Icons.edit),
              )
            : null,
      ),
    );
  }
}

enum ClassroomStates {
  Loading,
  Access,
  Private,
  Deleted,
  PublicJoinAllowed,
  PublicSendRequest,
}
