import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile {
  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
  final String phoneNumber;
  final DateTime lastSeen;
  DocumentReference reference;

  UserProfile({
    this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
    this.lastSeen,
    this.phoneNumber,
  });

  UserProfile.fromFirebaseUser(FirebaseUser user)
      : assert(user != null),
        uid = user.uid,
        email = user.email,
        photoUrl = user.photoUrl,
        displayName = user.displayName,
        phoneNumber = user.phoneNumber,
        lastSeen = DateTime.now();

  UserProfile.fromMap(Map<String, dynamic> data)
      : assert(data != null),
        uid = data['uid'],
        email = data['email'],
        photoUrl = data['photoUrl'],
        displayName = data['displayName'],
        phoneNumber = data['phoneNumber'],
        lastSeen = DateTime.fromMicrosecondsSinceEpoch(
            data['lastSeen'].microsecondsSinceEpoch);

  @override
  String toString() => "UserProfile<$uid:$email>";

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'photoURL': photoUrl,
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'lastSeen': lastSeen,
      };
}
