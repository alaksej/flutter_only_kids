import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/models/time_slot.dart';
import 'package:only_kids/utils/utils.dart';

class CalendarService {
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('calendars');

  Stream<List<TimeSlot>> getTimeSlots(DateTime dateTime) {
    return _collectionRef.doc('fixed').snapshots().map((snapshot) {
      final List<dynamic> slots = (snapshot.data() as Map)['timeslots'] ?? [];
      final List<TimeOfDay> times = slots.map((s) => stringToTime(s)).toList();
      times.sort((a, b) => compareTimeOfDay(a, b));
      final List<TimeSlot> timeSlots = times.map((time) => TimeSlot(dateTime: fromDateAndTime(dateTime, time))).toList();
      return timeSlots;
    });
  }
}
