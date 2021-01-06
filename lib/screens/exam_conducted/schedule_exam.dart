import 'package:apna_classroom_app/api/exam_conducted.dart';
import 'package:apna_classroom_app/components/buttons/arrow_secondary_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/dialogs/progress_dialog.dart';
import 'package:apna_classroom_app/components/labeled_switch.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom/classroom.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/classroom_exam_card.dart';
import 'package:apna_classroom_app/screens/quiz/exam/exam_picker.dart';
import 'package:apna_classroom_app/screens/quiz/widgets/exam_card.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:apna_classroom_app/util/date_time.dart';
import 'package:apna_classroom_app/util/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ScheduleExam extends StatefulWidget {
  final Map classroom;

  const ScheduleExam({Key key, this.classroom}) : super(key: key);

  @override
  _ScheduleExamState createState() => _ScheduleExamState();
}

class _ScheduleExamState extends State<ScheduleExam> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {
    C.MUST_JOIN_INSTANTLY: false,
    C.MUST_FINISH_WITHIN_TIME: true,
    C.ALLOW_RESUME_EXAM: true,
    C.ALLOW_ATTEND_MULTIPLE_TIME: false,
    C.SCHEDULE_EXAM_FOR_LATER: false,
    C.CAN_EXAM_EXPIRE: false,
    C.SHOW_SOLUTION_AND_ANSWER: true,
    C.CAN_ASK_DOUBT: false,
    C.ALLOWED_DELAY: 10,
  };

  // Schedule Exam
  scheduleExam() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();

      if (formData[C.SCHEDULE_EXAM_FOR_LATER] &&
          formData[C.START_TIME] == null) {
        return setState(() {
          startTimeError = S.PLEASE_SELECT_DATE_TIME.tr;
        });
      }
      startTimeError = null;
      if (formData[C.CAN_EXAM_EXPIRE] && formData[C.EXPIRE_TIME] == null) {
        return setState(() {
          expireTimeError = S.PLEASE_SELECT_DATE_TIME.tr;
        });
      }

      if (formData[C.START_TIME] != null &&
          formData[C.EXPIRE_TIME] != null &&
          formData[C.START_TIME].millisecondsSinceEpoch >
              formData[C.EXPIRE_TIME].millisecondsSinceEpoch) {
        return setState(() {
          expireTimeError = S.PLEASE_EXPIRE_TIME_AFTER_START_TIME.tr;
        });
      }

      setState(() {
        expireTimeError = null;
      });
      Map payload = formData;

      payload[C.CLASSROOM] = classrooms.map((e) => e[C.ID]).toList();

      removeDependent(C.MUST_JOIN_INSTANTLY, C.ALLOWED_DELAY);
      removeDependent(C.MUST_JOIN_INSTANTLY, C.MUST_FINISH_WITHIN_TIME);

      removeDependent(C.SCHEDULE_EXAM_FOR_LATER, C.START_TIME);
      removeDependent(C.CAN_EXAM_EXPIRE, C.EXPIRE_TIME);

      payload[C.START_TIME] =
          (formData[C.START_TIME] ?? DateTime.now()).toString();

      if (formData[C.EXPIRE_TIME] != null) {
        payload[C.EXPIRE_TIME] = formData[C.EXPIRE_TIME].toString();
      }
      showProgress();

      payload[C.EXAM] = formData[C.EXAM][C.ID];
      var examConducted = await createExamConducted(formData);
      Get.back();
      if (examConducted != null) Get.back();
    }
  }

  removeDependent(String key, String dependent) {
    if (!formData[key]) formData.remove(dependent);
  }

  // Select Exam
  selectExam() async {
    var exam = await Get.to(ExamPicker());
    if (exam == null) return;
    setState(() {
      formData[C.EXAM] = exam;
    });
  }

  removeExam() {
    setState(() {
      formData.remove(C.EXAM);
    });
  }

  // add classroom
  List classrooms = [];
  addClassroom() {
    Get.to(Classroom(
      selectedClassroom: classrooms.map<String>((e) => e[C.ID]).toList(),
      onSelect: onSelect,
    ));
  }

  onSelect(List list) {
    if (list == null || list.isEmpty) return;
    if (!list.any((element) => element[C.ID] == widget.classroom[C.ID])) {
      list.insert(0, widget.classroom);
    }
    setState(() {
      classrooms = list;
    });
  }

  closeClassroom(classroom) {
    setState(() {
      classrooms.remove(classroom);
    });
  }

  // On switch
  onSwitch(String key, bool value) {
    setState(() {
      formData[key] = value;
    });
  }

  // Solving Time
  saveAllowedDelay(String value) {
    if (value.isEmpty || int.parse(value) == 0)
      return formData.remove(C.ALLOWED_DELAY);

    formData[C.ALLOWED_DELAY] = int.parse(value) * 60;
  }

  // Exam Start time
  String startTimeError;
  examStartTime() async {
    DateTime dateTime = await showDateTimePicker();
    if (dateTime == null) return;
    setState(() {
      formData[C.START_TIME] = dateTime;
    });
  }

  // Exam expire time
  String expireTimeError;
  examExpireTime() async {
    DateTime dateTime = await showDateTimePicker();
    if (dateTime == null) return;
    setState(() {
      formData[C.EXPIRE_TIME] = dateTime;
    });
  }

  @override
  void initState() {
    classrooms.add(widget.classroom);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.SCHEDULE_EXAM.tr),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: scheduleExam)],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              children: [
                if (formData[C.EXAM] != null)
                  Column(
                    children: [
                      ExamCard(exam: formData[C.EXAM]),
                      SizedBox(height: 8.0),
                      SecondaryButton(
                        text: S.REMOVE.tr,
                        onPress: removeExam,
                        destructive: true,
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      if (formData[C.EXAM] == null)
                        Column(
                          children: [
                            SizedBox(height: 16.0),
                            ArrowSecondaryButton(
                              onPress: selectExam,
                              text: S.SELECT_EXAM.tr,
                              preIcon: Icons.receipt_rounded,
                            ),
                            SizedBox(height: 8.0),
                            ArrowSecondaryButton(
                              onPress: () {},
                              text: S.CREATE_NEW_EXAM.tr,
                              preIcon: Icons.school_rounded,
                            ),
                            SizedBox(height: 8.0),
                            ArrowSecondaryButton(
                              onPress: () {},
                              text: S.RANDOM_QUESTION_EXAM.tr,
                              preIcon: Icons.all_inclusive_rounded,
                            ),
                          ],
                        ),
                      Divider(),
                      Row(
                        children: [
                          SecondaryButton(
                            text: S.ADD_CLASSROOM.tr,
                            onPress: addClassroom,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.0),
                Column(
                  children: classrooms.map<Widget>(
                    (e) {
                      return ClassroomExamCard(
                        classroom: e,
                        onClose: e[C.ID] == widget.classroom[C.ID]
                            ? null
                            : () => closeClassroom(e),
                      );
                    },
                  ).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 8.0),
                      LabeledSwitch(
                        value: formData[C.MUST_JOIN_INSTANTLY],
                        onChanged: (value) =>
                            onSwitch(C.MUST_JOIN_INSTANTLY, value),
                        title: S.MUST_JOIN_ON_START.tr,
                      ),
                      SizedBox(height: 8.0),
                      if (formData[C.MUST_JOIN_INSTANTLY])
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: S.DELAY_ALLOWED.tr,
                              hintText: S.MINUTE.tr),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter(new RegExp('[0-9]'),
                                allow: true)
                          ],
                          maxLength: 3,
                          onSaved: saveAllowedDelay,
                          validator: validRequired,
                          initialValue: formData[C.ALLOWED_DELAY].toString(),
                        ),
                      if (formData[C.MUST_JOIN_INSTANTLY])
                        LabeledSwitch(
                          value: formData[C.MUST_FINISH_WITHIN_TIME],
                          onChanged: (value) =>
                              onSwitch(C.MUST_FINISH_WITHIN_TIME, value),
                          title: S.MUST_FINISH_WITHIN_TIME.tr,
                        ),
                      Divider(),
                      SizedBox(height: 8.0),
                      LabeledSwitch(
                        value: formData[C.ALLOW_RESUME_EXAM],
                        onChanged: (value) =>
                            onSwitch(C.ALLOW_RESUME_EXAM, value),
                        title: S.ALLOW_RESUME_EXAM.tr,
                      ),
                      SizedBox(height: 8.0),
                      LabeledSwitch(
                        value: formData[C.ALLOW_ATTEND_MULTIPLE_TIME],
                        onChanged: (value) =>
                            onSwitch(C.ALLOW_ATTEND_MULTIPLE_TIME, value),
                        title: S.ALLOW_TO_ATTEND_MULTIPLE_TIME.tr,
                      ),
                      SizedBox(height: 8.0),
                      LabeledSwitch(
                        value: formData[C.SCHEDULE_EXAM_FOR_LATER],
                        onChanged: (value) =>
                            onSwitch(C.SCHEDULE_EXAM_FOR_LATER, value),
                        title: S.SCHEDULE_EXAM_FOR_LATER.tr,
                      ),
                      SizedBox(height: 8.0),
                      if (formData[C.SCHEDULE_EXAM_FOR_LATER] ?? false)
                        Column(
                          children: [
                            InfoCard(
                              title: S.EXAM_START_TIME.tr,
                              child: TextButton(
                                child: Text(formData[C.START_TIME] != null
                                    ? getFormattedDateTime(
                                        dateTime: formData[C.START_TIME])
                                    : S.SELECT_START_TIME.tr),
                                onPressed: examStartTime,
                              ),
                            ),
                            if (startTimeError != null)
                              Text(
                                startTimeError,
                                style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      SizedBox(height: 8.0),
                      LabeledSwitch(
                        value: formData[C.CAN_EXAM_EXPIRE],
                        onChanged: (value) =>
                            onSwitch(C.CAN_EXAM_EXPIRE, value),
                        title: S.CAN_EXAM_EXPIRE.tr,
                      ),
                      SizedBox(height: 8.0),
                      if (formData[C.CAN_EXAM_EXPIRE] ?? false)
                        Column(
                          children: [
                            InfoCard(
                              title: S.EXAM_EXPIRE_TIME.tr,
                              child: TextButton(
                                child: Text(formData[C.EXPIRE_TIME] != null
                                    ? getFormattedDateTime(
                                        dateTime: formData[C.EXPIRE_TIME])
                                    : S.SELECT_EXPIRE_TIME.tr),
                                onPressed: examExpireTime,
                              ),
                            ),
                            if (expireTimeError != null)
                              Text(
                                expireTimeError,
                                style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                  fontSize: 12,
                                ),
                              )
                          ],
                        ),
                      SizedBox(height: 8.0),
                      LabeledSwitch(
                        value: formData[C.SHOW_SOLUTION_AND_ANSWER],
                        onChanged: (value) =>
                            onSwitch(C.SHOW_SOLUTION_AND_ANSWER, value),
                        title: S.SHOW_SOLUTION_AND_ANSWER.tr,
                      ),
                      SizedBox(height: 8.0),
                      LabeledSwitch(
                        value: formData[C.CAN_ASK_DOUBT],
                        onChanged: (value) => onSwitch(C.CAN_ASK_DOUBT, value),
                        title: S.CAN_ASK_DOUBT.tr,
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}