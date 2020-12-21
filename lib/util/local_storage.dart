import 'package:shared_preferences/shared_preferences.dart';

const String RECENTLY_ADDED_SUBJECTS = 'RECENTLY_ADDED_SUBJECTS';
const String GET_LAST_ADDED_SUBJECTS = 'GET_LAST_ADDED_SUBJECTS';

Future<SharedPreferences> getStorage() {
  return SharedPreferences.getInstance();
}

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

// Clear all Data
Future<void> clearAllLocalStorage() async {
  (await getStorage()).clear();
}
