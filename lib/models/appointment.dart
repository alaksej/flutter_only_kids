import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:only_kids/models/time_slot.dart';

class Appointment {
  final String? id;
  final String? uid;
  final String? username;
  final DateTime? dateTime;
  final String? comment;

  const Appointment({
    this.id,
    this.uid,
    this.username,
    this.dateTime,
    this.comment,
  });

  Appointment.fromMap(this.id, Map<String, dynamic> map)
      : assert(map['uid'] != null),
        assert(map['dateTime'] != null),
        uid = map['uid'],
        username = map['username'],
        comment = map['comment'],
        dateTime = DateTime.fromMicrosecondsSinceEpoch(map['dateTime'].microsecondsSinceEpoch);

  Appointment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.id,
          snapshot.data() as Map<String, dynamic>,
        );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'username': username,
        'dateTime': dateTime,
        'comment': comment,
      };

  TimeSlot? get timeSlot => dateTime == null ? null : TimeSlot(dateTime: dateTime!);

  @override
  String toString() => "Appointment<$username:$dateTime:$comment>";
}
