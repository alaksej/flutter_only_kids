import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String uid;
  final String username;
  final DateTime datetime;

  const Appointment({
    this.id,
    this.uid,
    this.username,
    this.datetime,
  });

  Appointment.fromMap(this.id, Map<String, dynamic> map)
      : assert(map['uid'] != null),
        assert(map['datetime'] != null),
        uid = map['uid'],
        username = map['username'],
        datetime = DateTime.fromMicrosecondsSinceEpoch(map['datetime'].microsecondsSinceEpoch);

  Appointment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.documentID,
          snapshot.data,
        );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'username': username,
        'datetime': datetime,
      };

  TimeOfDay get time => TimeOfDay.fromDateTime(datetime);

  @override
  String toString() => "Appointment<$username:$datetime>";
}
