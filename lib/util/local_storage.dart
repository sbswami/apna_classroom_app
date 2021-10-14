import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String RECENTLY_ADDED_SUBJECTS = 'RECENTLY_ADDED_SUBJECTS';
const String GET_LAST_ADDED_SUBJECTS = 'GET_LAST_ADDED_SUBJECTS';
const String RECENTLY_ADDED_EXAMS = 'RECENTLY_ADDED_EXAMS';
const String GET_LAST_ADDED_EXAMS = 'GET_LAST_ADDED_EXAMS';
const String LOCALE = 'LOCALE';
const String IS_DARK_MODE = 'IS_DARK_MODE';
const String SKIP_VERSION = 'SKIP_VERSION';
const String ENV = 'ENV';
const String LAST_USED_ANSWER_TYPE = 'LAST_USED_ANSWER_TYPE';

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

// Answer type
Future<String> getLastUsedAnswerType() async {
  return (await getStorage()).getString(LAST_USED_ANSWER_TYPE);
}

Future<void> setLastUsedAnswerType(String type) async {
  (await getStorage()).setString(LAST_USED_ANSWER_TYPE, type);
}

Future<void> setLocale({String localeString, Locale locale}) async {
  if (locale != null)
    localeString = '${locale.languageCode}_${locale.countryCode}';
  (await getStorage()).setString(LOCALE, localeString);
}

Future<String> getLocale() async {
  return (await getStorage()).getString(LOCALE);
}

Future<void> setDarkMode(bool isDarkMode) async {
  (await getStorage()).setBool(IS_DARK_MODE, isDarkMode);
}

Future<bool> isDarkMode() async {
  return (await getStorage()).getBool(IS_DARK_MODE);
}

// Skip Version
Future<int> getSkipVersion() async {
  return (await getStorage()).getInt(SKIP_VERSION);
}

Future<void> setSkipVersion(int versionCode) async {
  (await getStorage()).setInt(SKIP_VERSION, versionCode);
}

// Env
Future<String> getEnv() async {
  return (await getStorage()).getString(ENV);
}

/// [env] can be - PROD , DEV
Future<void> setEnv(String env) async {
  (await getStorage()).setString(ENV, env);
}

// Clear all Data
Future<void> clearAllLocalStorage() async {
  // Keep env safe
  String env = await getEnv();

  (await getStorage()).clear();

  setEnv(env);
}
