import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/exam_conducted.dart';
import 'package:apna_classroom_app/components/buttons/arrow_secondary_button.dart';
import 'package:apna_classroom_app/components/buttons/secondary_button.dart';
import 'package:apna_classroom_app/components/cards/info_card.dart';
import 'package:apna_classroom_app/components/dialogs/info_dialog.dart';
import 'package:apna_classroom_app/components/labeled_switch.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/classroom/classroom_selector.dart';
import 'package:apna_classroom_app/screens/exam_conducted/widgets/classroom_exam_card.dart';
import 'package:apna_classroom_app/screens/quiz/exam/add_exam.dart';
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
    C.ALLOWED_DELAY: 10,
  };

  // Schedule Exam
  scheduleExam() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();

      if (formData[C.EXAM] == null) {
        return ok(
            title: S.SELECT_EXAM.tr, msg: S.PLEASE_SELECT_EXAM_TO_SCHEDULE.tr);
      }

      if (formData[C.SCHEDULE_EXAM_FOR_LATER] &&
          formData[C.START_TIME] == null) {
        return setState(() {
          startTimeError = S.PLEASE_SELECT_DATE_TIME.tr;
        });
      }
      startTimeError = null;
      if ((formData[C.CAN_EXAM_EXPIRE] ?? false) &&
          formData[C.EXPIRE_TIME] == null) {
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

      removeDependent(C.MUST_JOIN_INSTANTLY, C.ALLOWED_DELAY);
      removeDependent(C.MUST_JOIN_INSTANTLY, C.MUST_FINISH_WITHIN_TIME);

      if (formData[C.MUST_JOIN_INSTANTLY]) formData.remove(C.CAN_EXAM_EXPIRE);

      removeDependent(C.SCHEDULE_EXAM_FOR_LATER, C.START_TIME);
      removeDependent(C.CAN_EXAM_EXPIRE, C.EXPIRE_TIME);

      Map<String, dynamic> payload = Map.from(formData);

      payload[C.CLASSROOM] = classrooms.map((e) => e[C.ID]).toList();

      payload[C.START_TIME] =
          (formData[C.START_TIME] ?? DateTime.now()).toString();

      if (formData[C.EXPIRE_TIME] != null) {
        payload[C.EXPIRE_TIME] = formData[C.EXPIRE_TIME].toString();
      } else if (formData[C.MUST_JOIN_INSTANTLY]) {
        // Expire time = StartTime + AllowedDelayed + SolvingTime
        int expireIn = formData[C.EXAM][C.SOLVING_TIME] * 1000 +
            (formData[C.ALLOWED_DELAY] ?? 0) * 1000 +
            (formData[C.START_TIME] ?? DateTime.now()).millisecondsSinceEpoch;
        payload[C.EXPIRE_TIME] = DateTime.fromMillisecondsSinceEpoch(
          expireIn,
        ).toString();
        payload[C.CAN_EXAM_EXPIRE] = true;
      }

      payload[C.EXAM] = formData[C.EXAM][C.ID];
      var examConducted = await createExamConducted(payload);

      // Track Schedule Exam
      track(EventName.SCHEDULE_EXAM, {
        EventProp.CLASSROOM_COUNT: classrooms?.length,
        EventProp.MUST_JOIN_ON_START: payload[C.MUST_JOIN_INSTANTLY],
        EventProp.SHOW_SOLUTION_AND_ANSWER: payload[C.SHOW_SOLUTION_AND_ANSWER],
        EventProp.MULTIPLE_ATTEMPT: payload[C.ALLOW_ATTEND_MULTIPLE_TIME],
        EventProp.ALLOW_RESUME: payload[C.ALLOW_RESUME_EXAM],
        EventProp.CAN_EXPIRE: payload[C.CAN_EXAM_EXPIRE],
        EventProp.QUESTION_COUNT: formData[C.EXAM][C.QUESTION]?.length,
        EventProp.MINUS_MARKING: formData[C.EXAM][C.MINUS_MARKING],
        EventProp.SOLVING_TIME: formData[C.EXAM][C.SOLVING_TIME],
        EventProp.MARKS: formData[C.EXAM][C.MARKS],
        EventProp.EXAMS: formData[C.EXAM][C.EXAM],
        EventProp.SUBJECTS: formData[C.EXAM][C.SUBJECT],
        EventProp.PRIVACY: formData[C.EXAM][C.PRIVACY],
        EventProp.DIFFICULTY: formData[C.EXAM][C.DIFFICULTY],
        EventProp.HAS_INSTRUCTION: formData[C.EXAM][C.INSTRUCTION] != null,
      });

      if (examConducted != null) Get.back(result: true);
    }
  }

  removeDependent(String key, String dependent) {
    if (!(formData[key] ?? false)) formData.remove(dependent);
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
    Get.to(ClassroomSelector(
      selectedClassroom: List.from(classrooms),
      onSelect: onSelect,
    ));
  }

  onSelect(List list) {
    if (list == null || list.isEmpty) return;
    if (!list.any((element) => element[C.ID] == widget.classroom[C.ID])) {
      list.insert(0, widget.classroom);
    }
    setState(() {
      classrooms.removeWhere(
          (element) => list.any((item) => item[C.ID] == element[C.ID]));
      classrooms.insertAll(0, list);
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

  // Allowed delay
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

  // Create Exam
  _createExam() async {
    var result = await Get.to(() => AddExam(
          accessedFrom: ScreenNames.ScheduleExam,
        ));

    // Track screen back
    trackScreen(ScreenNames.ScheduleExam);

    if (result != null) {
      setState(() {
        formData[C.EXAM] = result;
      });
    }
  }

  @override
  void initState() {
    classrooms.add(widget.classroom);
    super.initState();

    // Track Screen
    trackScreen(ScreenNames.ScheduleExam);
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
                              onPress: _createExam,
                              text: S.CREATE_NEW_EXAM.tr,
                              preIcon: Icons.school_rounded,
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
                      if (!formData[C.MUST_JOIN_INSTANTLY])
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
                      SizedBox(height: 64.0),
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
