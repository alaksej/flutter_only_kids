import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:only_kids/models/time_slot.dart';

class Appointment {
  final String id;
  final String uid;
  final String username;
  final DateTime dateTime;

  const Appointment({
    this.id,
    this.uid,
    this.username,
    this.dateTime,
  });

  Appointment.fromMap(this.id, Map<String, dynamic> map)
      : assert(map['uid'] != null),
        assert(map['dateTime'] != null),
        uid = map['uid'],
        username = map['username'],
        dateTime = DateTime.fromMicrosecondsSinceEpoch(map['dateTime'].microsecondsSinceEpoch);

  Appointment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.documentID,
          snapshot.data,
        );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'username': username,
        'dateTime': dateTime,
      };

  TimeSlot get timeSlot => TimeSlot(dateTime: dateTime);

  @override
  String toString() => "Appointment<$username:$dateTime>";
}
