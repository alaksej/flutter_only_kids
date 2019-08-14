import 'package:flutter/material.dart';

class TimeSlot {
  TimeSlot({this.dateTime, this.availability});

  final DateTime dateTime;
  int availability;
  bool get isSelectable => hasAvailability && dateTime.isAfter(DateTime.now());

  TimeOfDay get timeOfDay => TimeOfDay.fromDateTime(dateTime);
  bool get hasAvailability => availability > 0;

  occupy() {
    assert(availability > 0);
    availability--;
  }

  bool equals(TimeSlot other) {
    return timeOfDay.hour == other.timeOfDay.hour && timeOfDay.minute == other.timeOfDay.minute;
  }
}
