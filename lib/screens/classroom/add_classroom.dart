import 'package:apna_classroom_app/api/classroom.dart';
import 'package:apna_classroom_app/api/storage.dart';
import 'package:apna_classroom_app/auth/user_controller.dart';
import 'package:apna_classroom_app/components/apna_menu.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/cards/input_card.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/components/images/apna_image_picker.dart';
import 'package:apna_classroom_app/components/images/person_image.dart';
import 'package:apna_classroom_app/components/menu_item.dart';
import 'package:apna_classroom_app/components/radio/radio_group.dart';
import 'package:apna_classroom_app/components/tags/exam_tag_input.dart';
import 'package:apna_classroom_app/components/tags/subject_tag_input.dart';
import 'package:apna_classroom_app/controllers/subjects_controller.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom/person_card.dart';
import 'package:apna_classroom_app/screens/classroom/search_person.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/constants.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddClassroom extends StatefulWidget {
  @override
  _AddClassroomState createState() => _AddClassroomState();
}

class _AddClassroomState extends State<AddClassroom> {
  // Constants
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {
    C.PRIVACY: E.PRIVATE,
    C.WHO_CAN_JOIN: E.REQUEST_BEFORE_JOIN,
    C.WHO_CAN_SHARE_NOTES: E.ADMIN_ONLY,
    C.WHO_CAN_SEND_MESSAGES: E.ADMIN_ONLY,
  };

  // Variables

  // Init
  @override
  void initState() {
    super.initState();
  }

  // On Save
  save() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();

      // Exam Error
      if (exams.isEmpty) {
        setState(() {
          examError = S.ADD_AT_LEAST_ONE_EXAM.tr;
        });
        return examFocusNode.requestFocus();
      }
      examError = null;
      // Subject Error
      if (subjects.isEmpty) {
        setState(() {
          subjectError = S.ADD_AT_LEAST_ONE_SUBJECT.tr;
        });
        return subjectFocusNode.requestFocus();
      }
      setState(() {
        subjectError = null;
      });

      formData[C.EXAM] = exams.toList();
      formData[C.SUBJECT] = subjects.toList();

      if (formData[C.PRIVACY] == E.PRIVATE) {
        formData.remove(C.WHO_CAN_JOIN);
      }

      // Members
      formData[C.MEMBERS] = members.map((e) {
        Map member = {C.ID: e[C.ID], C.ROLE: E.MEMBER};
        if (admins.any((element) => element == e[C.ID])) {
          member[C.ROLE] = E.ADMIN;
        }
        return member;
      }).toList();
      formData[C.MEMBERS].insert(0, {
        C.ID: UserController.to.currentUser[C.ID],
        C.ROLE: E.ADMIN,
      });
      showProgress();
      if (formData[C.IMAGE] != null && formData[C.THUMBNAIL] != null) {
        formData[C.PHOTO_URL] = await uploadImage(formData[C.IMAGE]);
        formData[C.THUMBNAIL_URL] =
            await uploadImageThumbnail(formData[C.THUMBNAIL]);
        formData.remove(C.IMAGE);
        formData.remove(C.THUMBNAIL);
      } else {
        formData.remove(C.THUMBNAIL_URL);
        formData.remove(C.PHOTO_URL);
      }

      RecentlyUsedController.to.setLastUsedSubjects(subjects.toList());
      RecentlyUsedController.to.setLastUsedExams(exams.toList());
      var classroom = await createClassroom(formData);
      Get.back();
      if (classroom != null) Get.back();
    }
  }

  // Save Optional Field
  onSaved(String key, String value) {
    if (value.isEmpty) return formData.remove(key);
    formData[key] = value;
  }

  // Image Picker
  pickImage() async {
    var result = await showApnaImagePicker(context, showDelete: true);
    if (result == null) return;

    if (result[3]) {
      return setState(() {
        formData[C.IMAGE] = null;
        formData[C.THUMBNAIL] = null;
      });
    }

    setState(() {
      formData[C.THUMBNAIL] = result[1];
      formData[C.IMAGE] = result[2];
    });
  }

  // On Pick Option
  onPickOption(String key, String value) {
    setState(() {
      formData[key] = value;
    });
  }

  // Subjects Tag
  Set<String> subjects = {};
  String subjectError;
  TextEditingController subjectController = TextEditingController();
  FocusNode subjectFocusNode = FocusNode();
  addSubject(String value) {
    setState(() {
      subjects.add(value);
    });
  }

  removeSubject(String value) {
    setState(() {
      subjects.remove(value);
    });
  }

  addAllLastUsed() {
    setState(() {
      subjects.addAll(RecentlyUsedController.to.lastUsedSubjects);
    });
  }

  // Exams Tag
  Set<String> exams = {};
  String examError;
  TextEditingController examController = TextEditingController();
  FocusNode examFocusNode = FocusNode();
  addExam(String value) {
    setState(() {
      exams.add(value);
    });
  }

  removeExam(String value) {
    setState(() {
      exams.remove(value);
    });
  }

  addAllLastUsedExam() {
    setState(() {
      exams.addAll(RecentlyUsedController.to.lastUsedExams);
    });
  }

  // Add Member
  List members = [];
  List admins = [];
  addMember() async {
    var result = await Get.to(SearchPerson());
    if (result == null) return;
    members.removeWhere(
      (element) => result.any((item) => element[C.ID] == item[C.ID]),
    );
    setState(() {
      members.insertAll(0, result);
    });
  }

  onLongPress(String id, BuildContext context) {
    List<MenuItem> items = [
      MenuItem(
        iconData: Icons.delete,
        text: S.REMOVE.tr,
        onTap: () => deleteMember(id),
      ),
    ];
    if (admins.any((element) => element == id)) {
      items.add(MenuItem(
        iconData: Icons.person_remove_alt_1_rounded,
        text: S.NOT_ADMIN.tr,
        onTap: () => notAdmin(id),
      ));
    } else {
      items.add(MenuItem(
        iconData: Icons.person,
        text: S.MAKE_ADMIN.tr,
        onTap: () => makeAdmin(id),
      ));
    }
    showApnaMenu(context, items);
  }

  makeAdmin(String id) {
    setState(() {
      admins.add(id);
    });
    Get.back();
  }

  notAdmin(String id) {
    setState(() {
      admins.remove(id);
    });
    Get.back();
  }

  deleteMember(String _id) {
    setState(() {
      members.removeWhere((element) => element[C.ID] == _id);
      admins.remove(_id);
    });
    Get.back();
  }

  // Import via Excel
  importViaExcel() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.ADD_CLASSROOM.tr),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: save)],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      PersonImage(
                        editMode: true,
                        onPhotoSelect: pickImage,
                        thumbnailImage: formData[C.THUMBNAIL],
                        image: formData[C.IMAGE],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: S.CLASSROOM_TITLE.tr,
                        ),
                        validator: validTitle,
                        onSaved: (value) => formData[C.TITLE] = value,
                        maxLength: 100,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: S.CLASSROOM_DESCRIPTION.tr,
                        ),
                        onSaved: (value) => onSaved(C.DESCRIPTION, value),
                        maxLength: 1000,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                      InputCard(
                        key: Key(S.CLASSROOM_PRIVACY),
                        title: S.CLASSROOM_PRIVACY.tr,
                        child: RadioGroup(
                          list: {
                            E.PRIVATE: S.PRIVATE.tr,
                            E.PUBLIC: S.PUBLIC.tr,
                          },
                          isVertical: true,
                          defaultValue: formData[C.PRIVACY],
                          onChange: (value) => onPickOption(C.PRIVACY, value),
                        ),
                      ),
                      if (formData[C.PRIVACY] == E.PUBLIC)
                        InputCard(
                          key: Key(S.WHO_CAN_JOIN),
                          title: S.WHO_CAN_JOIN.tr,
                          child: RadioGroup(
                            list: {
                              E.ANYONE: S.ANYONE_CAN_JOIN.tr,
                              E.REQUEST_BEFORE_JOIN: S.ACCEPT_JOIN_REQUESTS.tr,
                            },
                            isVertical: true,
                            defaultValue: formData[C.WHO_CAN_JOIN],
                            onChange: (value) =>
                                onPickOption(C.WHO_CAN_JOIN, value),
                          ),
                        ),
                      InputCard(
                        key: Key(S.WHO_CAN_SHARE_NOTES),
                        title: S.WHO_CAN_SHARE_NOTES.tr,
                        child: RadioGroup(
                          list: {
                            E.ADMIN_ONLY: S.ADMIN_ONLY.tr,
                            E.ALL: S.ALL.tr,
                          },
                          isVertical: true,
                          defaultValue: formData[C.WHO_CAN_SHARE_NOTES],
                          onChange: (value) =>
                              onPickOption(C.WHO_CAN_SHARE_NOTES, value),
                        ),
                      ),
                      InputCard(
                        key: Key(S.WHO_CAN_SHARE_MESSAGES),
                        title: S.WHO_CAN_SHARE_MESSAGES.tr,
                        child: RadioGroup(
                          list: {
                            E.ADMIN_ONLY: S.ADMIN_ONLY.tr,
                            E.ALL: S.ALL.tr,
                          },
                          isVertical: true,
                          defaultValue: formData[C.WHO_CAN_SEND_MESSAGES],
                          onChange: (value) =>
                              onPickOption(C.WHO_CAN_SEND_MESSAGES, value),
                        ),
                      ),
                      // Exam Tags
                      ExamTagInput(
                        exams: exams,
                        examError: examError,
                        examController: examController,
                        addExam: addExam,
                        removeExam: removeExam,
                        addAllLastUsedExam: addAllLastUsedExam,
                        focusNode: examFocusNode,
                      ),
                      // Subject Tag
                      SubjectTagInput(
                        subjects: subjects,
                        subjectError: subjectError,
                        subjectController: subjectController,
                        addSubject: addSubject,
                        removeSubject: removeSubject,
                        addAllLastUsed: addAllLastUsed,
                        focusNode: subjectFocusNode,
                      ),
                      Row(
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
                          )
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Text('${members.length + 1} ${S.MEMBERS.tr}'),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
                PersonCard(
                  person: UserController.to.currentUser,
                  isAdmin: true,
                ),
                Column(
                  children: members.map<Widget>(
                    (e) {
                      bool isAdmin =
                          admins.any((element) => element == e[C.ID]);
                      return PersonCard(
                        person: e,
                        onLongPress: ({BuildContext context}) =>
                            onLongPress(e[C.ID], context),
                        isAdmin: isAdmin,
                      );
                    },
                  ).toList(),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
