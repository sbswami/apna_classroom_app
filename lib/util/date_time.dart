import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

getFormattedTime({DateTime dateTime, String dateString}) {
  if (dateString != null) dateTime = DateTime.parse(dateString);
  final DateFormat formatter = DateFormat('h:mm a');
  return formatter.format(dateTime.toLocal());
}

getFormattedDateTime({DateTime dateTime, String dateString}) {
  if (dateString != null) dateTime = DateTime.parse(dateString);
  final DateFormat formatter = DateFormat('d MMM yyyy h:mm a');
  return formatter.format((dateTime ?? DateTime.now()).toLocal());
}

getUpdateTime({DateTime dateTime, String dateString}) {
  if (dateString != null) dateTime = DateTime.parse(dateString);
  int diff =
      DateTime.now().millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;
  int sec = diff ~/ 1000;
  int min = sec ~/ 60;
  int hour = min ~/ 60;
  if (diff < 1000) {
    return S.JUST_NOW.tr;
  } else if (sec < 60) {
    return '$sec ${S.SECONDS_AGO.tr}';
  } else if (min < 60) {
    return '$min ${S.MINUTES_AGO.tr}';
  } else if (hour < 24) {
    return '$hour ${S.HOURS_AGO.tr}';
  }
  final DateFormat formatter = DateFormat('d MMM yyyy');
  return formatter.format(dateTime.toLocal());
}

Future<DateTime> showDateTimePicker() async {
  DateTime now = DateTime.now().toLocal();
  var date = await showDatePicker(
      context: Get.context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 10));
  if (date == null) return null;
  var time =
      await showTimePicker(context: Get.context, initialTime: TimeOfDay.now());
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

int getMinuteDiff(
    {DateTime first, String firstSt, DateTime second, String secondSt}) {
  if (firstSt != null) first = DateTime.parse(firstSt).toLocal();
  if (secondSt != null) second = DateTime.parse(secondSt).toLocal();
  return second.difference(first).inMinutes;
}

int getSecondDiff(
    {DateTime first, String firstSt, DateTime second, String secondSt}) {
  if (firstSt != null) first = DateTime.parse(firstSt).toLocal();
  if (secondSt != null) second = DateTime.parse(secondSt).toLocal();
  return second?.difference(first)?.inSeconds;
}

bool isFutureDate({DateTime date, String dateSt}) {
  if (!(dateSt == null || dateSt == '')) date = DateTime.parse(dateSt);
  return date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch;
}

String getReadableDuration(Duration duration) {
  if (duration == null) return '';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
