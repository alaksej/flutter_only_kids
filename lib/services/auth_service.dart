import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user$; // firebase user
  Observable<Map<String, dynamic>> profile$; // custom user data in Firestore
  BehaviorSubject<bool> loading$ = BehaviorSubject.seeded(false);

  FirebaseUser _user;
  FirebaseUser get currentUser => _user;
  bool get isLoggedIn => _user != null;

  // constructor
  AuthService() {
    user$ = Observable(_auth.onAuthStateChanged).doOnData((u) => _user = u).shareReplay(maxSize: 1);

    profile$ = user$.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db.collection('users').document(u.uid).snapshots().map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<bool> googleSignIn() async {
    try {
      loading$.add(true);
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseUser user = await _auth.signInWithCredential(credential);
      updateUserData(user);
      print("user name: ${user.displayName}");

      return true;
    } catch (error) {
      print("Google sign in error: $error");
      return false;
    } finally {
      loading$.add(false);
    }
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData(UserProfile.fromFirebaseUser(user).toMap(), merge: true);
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return 'SignOut';
    } catch (e) {
      return e.toString();
    }
  }
}
