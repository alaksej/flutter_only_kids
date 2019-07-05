import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/utils/utils.dart';

class CalendarService {
  final CollectionReference _collectionRef = Firestore.instance.collection('calendars');

  Stream<List<TimeOfDay>> getTimeSlots() {
    return _collectionRef.document('fixed').snapshots().map((snapshot) {
      final List<dynamic> slots = snapshot.data['timeslots'] ?? [];
      final List<TimeOfDay> times = slots.map((s) => stringToTime(s)).toList();
      times.sort((a, b) => compareTimeOfDay(a, b));
      return times;
    });
  }
}
