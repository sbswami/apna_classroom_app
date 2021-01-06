import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

getFormattedTime({DateTime dateTime, String dateString}) {
  if (dateString != null) dateTime = DateTime.parse(dateString);
  final DateFormat formatter = DateFormat('h:mm a');
  return formatter.format(dateTime);
}

getFormattedDateTime({DateTime dateTime, String dateString}) {
  if (dateString != null) dateTime = DateTime.parse(dateString);
  final DateFormat formatter = DateFormat('d MMM yyyy h:mm a');
  return formatter.format(dateTime);
}

Future<DateTime> showDateTimePicker() async {
  DateTime now = DateTime.now();
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
