import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String dayDateTime(DateTime date) => DateFormat.EEEE().add_yMMMd().add_jm().format(date);
String dayDate(DateTime date) => DateFormat.EEEE().add_yMMMd().format(date);
String day(DateTime date) => DateFormat.EEEE().format(date);
String shortDate(DateTime date) => DateFormat.yMMMd().format(date);
String time(DateTime date) => DateFormat.jm().format(date);
DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);
DateTime fromDateAndTime(DateTime date, TimeOfDay time) => DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

TimeOfDay stringToTime(String s) {
  final int hour = int.parse(s.split(":")[0]);
  final int minute = int.parse(s.split(":")[1]);
  final TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
  return time;
}

int compareTimeOfDay(TimeOfDay a, TimeOfDay b) {
  final int minutesA = a.hour * 60 + a.minute;
  final int minutesB = b.hour * 60 + b.minute;
  return minutesA > minutesB ? 1 : minutesA < minutesB ? -1 : 0;
}
