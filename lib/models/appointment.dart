import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String name;
  final DateTime datetime;
  final DocumentReference reference;

  Appointment.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['datetime'] != null),
        name = map['name'],
        datetime = DateTime.fromMicrosecondsSinceEpoch(
            map['datetime'].microsecondsSinceEpoch);

  Appointment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Appointment<$name:$datetime>";
}
