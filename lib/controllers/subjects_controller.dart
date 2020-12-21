import 'package:apna_classroom_app/util/local_storage.dart';
import 'package:get/get.dart';

class RecentlyUsedController extends GetxController {
  List<String> subjects = [];
  List<String> exams = [];

  List<String> lastUsedSubjects = [];
  List<String> lastUsedExams = [];

  static RecentlyUsedController get to => Get.find<RecentlyUsedController>();

  RecentlyUsedController() {
    getRecentlyAddedSubjects().then((value) => subjects = value);
    getLastAddedSubjects().then((value) => lastUsedSubjects = value);
  }

  void setSubjects(List<String> list) {
    subjects = list;
  }

  void addSubject(String subject) {
    subjects.remove(subject);
    subjects.insert(0, subject);
    addRecentlyAddedSubjects(subjects);
  }

  Future addAllSubject(List<String> subjects) async {
    subjects.removeWhere((element) => subjects.contains(element));
    subjects.insertAll(0, subjects);
    await addRecentlyAddedSubjects(subjects);
  }

  void setExams(List<String> list) {
    exams = list;
  }

  void addExam(String exam) {
    subjects.insert(0, exam);
  }

  void addAllExam(List<String> exams) {
    subjects.insertAll(0, exams);
  }

  void setLastUsedSubjects(List<String> list) {
    lastUsedSubjects = list;
    setLastAddedSubjects(list);
  }

  void setLastUsedExams(List<String> list) {
    lastUsedExams = list;
  }
}
