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
  Stream<UserProfile> userProfile$; // custom user data in Firestore
  // TODO: add loading service. Fix loading indicator by using counter
  BehaviorSubject<bool> loading$ = BehaviorSubject.seeded(false); 

  FirebaseUser _user;
  FirebaseUser get currentUser => _user;
  bool get isLoggedIn => _user != null;

  // constructor
  AuthService() {
    user$ = Observable(_auth.onAuthStateChanged).doOnData((u) => _user = u).shareReplay(maxSize: 1);

    // profile$ = user$.map(
    //   (u) => u != null
    //       ? UserProfile.fromFirebaseUser(u)
    //       : null,
    // );

    userProfile$ = Observable(DeferStream(
      () {
        loading$.add(true);
        return user$.switchMap(
          (FirebaseUser u) {
            if (u != null) {
              // TODO: get rid of second network request
              return getUserProfile(u.uid);
            } else {
              return Observable.just(null);
            }
          },
        ).doOnEach((notification) {
          loading$.add(false);
        });
      },
    )).shareReplay(maxSize: 1);
  }

  Stream<UserProfile> getUserProfile(String uid) {
    return _db.collection('users').document(uid).snapshots().map((snap) => UserProfile.fromMap(snap.data));
  }

  Future<UserProfile> googleSignIn() async {
    try {
      loading$.add(true);
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseUser user = await _auth.signInWithCredential(credential);
      await updateUserData(user);
      UserProfile userProfile =
          await _db.collection('users').document(user.uid).get().then((value) => UserProfile.fromMap(value.data));

      return userProfile;
    } catch (error) {
      print("Google sign in error: $error");
      return null;
    } finally {
      loading$.add(false);
    }
  }

  Future<void> updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    return ref.setData(UserProfile.firebaseUserToMap(user), merge: true);
  }

  Future<void> updateCurrentUserPhone(String phoneNumber) async {
    DocumentReference ref = _db.collection('users').document(currentUser.uid);
    try {
      loading$.add(true);
      return await ref.setData({'phoneNumber': phoneNumber}, merge: true);
    } finally {
      loading$.add(false);
    }
  }

  Future<bool> userExists(String email) async {
    return Future.value(true);
    // TODO: use cloud function to check if the user exists
    // QuerySnapshot users = await _db.collection('users').where('email', isEqualTo: email).getDocuments();
    // return users.documents.length > 0;
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
