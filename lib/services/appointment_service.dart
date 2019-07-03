import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class AppointmentService {
  final CollectionReference _appointmentsRef = Firestore.instance.collection('appointments');
  final AuthService _authService = getIt.get<AuthService>();

  Stream<List<Appointment>> getByCurrentUser() {
    var stream = _authService.user$.switchMap((user) {
      if (user == null) {
        return Observable.just(List<Appointment>());
      }

      return getByUser(user);
    });

    return stream;
  }

  Stream<List<Appointment>> getByUser(FirebaseUser user) {
    final stream = _appointmentsRef.where('uid', isEqualTo: user.uid).orderBy('datetime').snapshots().map((list) {
      return list.documents.map((snapshot) => Appointment.fromSnapshot(snapshot)).toList();
    });
    return stream;
  }

  Future<String> addForCurrentUser(Appointment appointment) async {
    assert(_authService.isLoggedIn);

    final userAppointment = Appointment(
      uid: _authService.currentUser.uid,
      username: _authService.currentUser.displayName,
      datetime: appointment.datetime,
    );

    final docRef = await _appointmentsRef.add(userAppointment.toMap());

    return docRef.documentID;
  }

  Future<void> updateForCurrentUser(Appointment appointment) async {
    assert(appointment.uid == _authService.currentUser.uid);
    await _appointmentsRef.document(appointment.id).setData(appointment.toMap(), merge: true);
  }

  Future<void> delete(String appointmentId) async {
    await _appointmentsRef.document(appointmentId).delete();
  }
}
