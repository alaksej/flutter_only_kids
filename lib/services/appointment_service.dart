import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/appointment.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class AppointmentService {
  final CollectionReference _collectionRef = Firestore.instance.collection('appointments');
  final AuthService _authService = getIt.get<AuthService>();

  Stream<List<Appointment>> getByCurrentUser() {
    var stream = _authService.firebaseUser$.switchMap((user) {
      if (user == null) {
        return Stream.value(List<Appointment>());
      }

      return getByUser(user);
    });

    return stream;
  }

  Stream<List<Appointment>> getUpcomingByCurrentUser() {
    final user = _authService.currentUser;
      if (user == null) {
        return Stream.value(List<Appointment>());
      }

      return getUpcomingByUser(user);
  }

  Stream<List<Appointment>> getPastByCurrentUser() {
    var stream = _authService.firebaseUser$.switchMap((user) {
      if (user == null) {
        return Stream.value(List<Appointment>());
      }

      return getPastByUser(user);
    });

    return stream;
  }

  Stream<List<Appointment>> getByUser(FirebaseUser user) {
    final stream = _collectionRef
        .where('uid', isEqualTo: user.uid)
        .orderBy('dateTime')
        .snapshots()
        .map((list) => list.documents.map((snapshot) => Appointment.fromSnapshot(snapshot)).toList());
    return stream;
  }

  Stream<List<Appointment>> getUpcomingByUser(FirebaseUser user) {
    final now = DateTime.now();
    final stream = _collectionRef
        .where('uid', isEqualTo: user.uid)
        .where('dateTime', isGreaterThanOrEqualTo: now)
        .orderBy('dateTime')
        .snapshots()
        .map((list) => list.documents.map((snapshot) => Appointment.fromSnapshot(snapshot)).toList());
    return stream;
  }

  Stream<List<Appointment>> getPastByUser(FirebaseUser user) {
    final now = DateTime.now();
    final stream = _collectionRef
        .where('uid', isEqualTo: user.uid)
        .where('dateTime', isLessThan: now)
        .orderBy('dateTime')
        .snapshots()
        .map((list) => list.documents.map((snapshot) => Appointment.fromSnapshot(snapshot)).toList());
    return stream;
  }

  Stream<List<Appointment>> getAll() {
    return _collectionRef
        .orderBy('dateTime')
        .snapshots()
        .map((list) => list.documents.map((snapshot) => Appointment.fromSnapshot(snapshot)).toList());
  }

  Stream<List<Appointment>> getUpcomingAll() {
    return _collectionRef
        .where('dateTime', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy('dateTime')
        .snapshots()
        .map((list) => list.documents.map((snapshot) => Appointment.fromSnapshot(snapshot)).toList());
  }

  Stream<List<Appointment>> getPastAll() {
    return _collectionRef
        .where('dateTime', isLessThan: DateTime.now())
        .orderBy('dateTime')
        .snapshots()
        .map((list) => list.documents.map((snapshot) => Appointment.fromSnapshot(snapshot)).toList());
  }

  Future<String> addForCurrentUser(Appointment appointment) async {
    assert(_authService.isLoggedIn);

    final userAppointment = Appointment(
      uid: _authService.currentUser.uid,
      username: _authService.currentUser.displayName,
      dateTime: appointment.dateTime,
      comment: appointment.comment,
    );

    final docRef = await _collectionRef.add(userAppointment.toMap());

    return docRef.documentID;
  }

  Future<void> update(Appointment appointment) async {
    await _collectionRef.document(appointment.id).setData(appointment.toMap(), merge: true);
  }

  Future<void> delete(String appointmentId) async {
    await _collectionRef.document(appointmentId).delete();
  }
}
