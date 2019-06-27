import 'package:flutter/material.dart';

class TimeSlot {
  final TimeOfDay timeOfDay;
  int availability;
  
  TimeSlot({this.timeOfDay, this.availability});

  get isAvailable => availability > 0;

  occupy() {
    assert(availability > 0);
    availability--;
  }
}
