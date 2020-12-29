import 'package:shared_preferences/shared_preferences.dart';

const String RECENTLY_ADDED_SUBJECTS = 'RECENTLY_ADDED_SUBJECTS';
const String GET_LAST_ADDED_SUBJECTS = 'GET_LAST_ADDED_SUBJECTS';
const String RECENTLY_ADDED_EXAMS = 'RECENTLY_ADDED_EXAMS';
const String GET_LAST_ADDED_EXAMS = 'GET_LAST_ADDED_EXAMS';

Future<SharedPreferences> getStorage() {
  return SharedPreferences.getInstance();
}

// SUBJECTS
Future<List<String>> getRecentlyAddedSubjects() async {
  return (await getStorage()).getStringList(RECENTLY_ADDED_SUBJECTS) ?? [];
}

Future<void> addRecentlyAddedSubjects(List<String> list) async {
  (await getStorage()).setStringList(RECENTLY_ADDED_SUBJECTS, list);
}

Future<List<String>> getLastAddedSubjects() async {
  return (await getStorage()).getStringList(GET_LAST_ADDED_SUBJECTS) ?? [];
}

Future<void> setLastAddedSubjects(List<String> list) async {
  (await getStorage()).setStringList(GET_LAST_ADDED_SUBJECTS, list);
}

// EXAMS

Future<List<String>> getRecentlyAddedExams() async {
  return (await getStorage()).getStringList(RECENTLY_ADDED_EXAMS) ?? [];
}

Future<void> addRecentlyAddedExams(List<String> list) async {
  (await getStorage()).setStringList(RECENTLY_ADDED_EXAMS, list);
}

Future<List<String>> getLastAddedExams() async {
  return (await getStorage()).getStringList(GET_LAST_ADDED_EXAMS) ?? [];
}

Future<void> setLastAddedExams(List<String> list) async {
  (await getStorage()).setStringList(GET_LAST_ADDED_EXAMS, list);
}

// Clear all Data
Future<void> clearAllLocalStorage() async {
  (await getStorage()).clear();
}
