import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String uid;
  final String username;
  final DateTime datetime;
  final DocumentReference reference;

  Appointment({this.uid, this.username, this.datetime, this.reference});

  Appointment.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['uid'] != null),
        assert(map['datetime'] != null),
        uid = map['uid'],
        username = map['username'],
        datetime = DateTime.fromMicrosecondsSinceEpoch(map['datetime'].microsecondsSinceEpoch);

  Appointment.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'username': username,
        'datetime': datetime,
      };

  @override
  String toString() => "Appointment<$username:$datetime>";
}
