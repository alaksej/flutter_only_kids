import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile {
  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
  final String phoneNumber;
  final DateTime lastSeen;
  final bool admin;
  DocumentReference reference;

  UserProfile({
    this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
    this.lastSeen,
    this.phoneNumber,
    this.admin = false,
  });

  static Map<String, dynamic> firebaseUserToMap(FirebaseUser user) {
    assert(user != null);
    return {
      'uid': user.uid,
      'email': user.email,
      'photoUrl': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
    };
  }

  UserProfile.fromMap(Map<String, dynamic> data)
      : assert(data != null),
        uid = data['uid'],
        email = data['email'],
        photoUrl = data['photoURL'],
        displayName = data['displayName'],
        phoneNumber = data['phoneNumber'],
        admin = data['admin'] ?? false,
        lastSeen = DateTime.fromMicrosecondsSinceEpoch(data['lastSeen'].microsecondsSinceEpoch);

  @override
  String toString() => "UserProfile<$uid:$email>";

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'photoURL': photoUrl,
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'lastSeen': lastSeen,
        'admin': admin,
      };
}
