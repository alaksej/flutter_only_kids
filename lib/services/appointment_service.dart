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
    var stream = _appointmentsRef.where('uid', isEqualTo: user.uid).snapshots().map((list) {
      print(list);
      return list.documents.toList().map((appointment) => Appointment.fromSnapshot(appointment)).toList();
    });
    return stream;
  }

  Future<void> addForCurrentUser(Appointment appointment) async {
    if (!_authService.isLoggedIn) {
      print('Unable to add appointment: the user must be logged in.');
      return;
    }

    var userAppointment = Appointment(
      uid: _authService.currentUser.uid,
      username: _authService.currentUser.displayName,
      datetime: appointment.datetime,
    );

    print('Creating appointment for ${appointment.username} on ${appointment.datetime}.');

    await _appointmentsRef.add(userAppointment.toMap());
  }
}
