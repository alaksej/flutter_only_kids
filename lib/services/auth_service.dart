import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/services/cloud_functions_service.dart';
import 'package:only_kids/services/loading_service.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final LoadingService _loadingService = getIt.get<LoadingService>();

  Observable<FirebaseUser> firebaseUser$; // firebase user
  Stream<UserProfile> userProfile$; // custom user data in Firestore

  FirebaseUser _firebaseUser;
  FirebaseUser get currentUser => _firebaseUser;
  bool get isLoggedIn => _firebaseUser != null;

  AuthService() {
    firebaseUser$ = Observable(_auth.onAuthStateChanged).doOnData((u) => _firebaseUser = u).shareReplay(maxSize: 1);
    userProfile$ = firebaseUser$
        .switchMap((FirebaseUser u) => u != null ? _getUserProfileStream(u.uid) : Observable.just(null))
        .shareReplay(maxSize: 1);
  }

  Stream<UserProfile> _getUserProfileStream(String uid) {
    return _db.collection('users').document(uid).snapshots().map((snap) => UserProfile.fromMap(snap.data));
  }

  Future<UserProfile> _getUserProfile(String uid) {
    return _db.collection('users').document(uid).get().then((value) => UserProfile.fromMap(value.data));
  }

  Future<UserProfile> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _loadingService.wrap(_googleSignIn.signIn());
      GoogleSignInAuthentication googleAuth = await _loadingService.wrap(googleSignInAccount.authentication);

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseUser user = await _loadingService.wrap(_auth.signInWithCredential(credential));
      await updateUserData(user);
      UserProfile userProfile = await _loadingService.wrap(_getUserProfile(user.uid));
      return userProfile;
    } catch (error) {
      print("Google sign in error: $error");
      return null;
    }
  }

  Future<UserProfile> createUserWithPassword(String email, String password, String name) async {
    try {
      FirebaseUser user = await _loadingService.wrap(
        _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      );

      await updateUserData(user, name);
      UserProfile userProfile = await _loadingService.wrap(_getUserProfile(user.uid));
      return userProfile;
    } catch (error) {
      print("Create user error: $error");
      return null;
    }
  }

  Future<UserProfile> passwordSignIn(String email, String password) async {
    try {
      FirebaseUser user = await _loadingService.wrap(
        _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      );

      UserProfile userProfile = await _loadingService.wrap(_getUserProfile(user.uid));
      return userProfile;
    } catch (error) {
      print("Password sign in error: $error");
      return null;
    }
  }

  Future<void> updateUserData(FirebaseUser user, [String displayName]) async {
    // TODO: refactor the mess:
    DocumentReference ref = _db.collection('users').document(user.uid);
    final map = UserProfile.firebaseUserToMap(user);
    if (displayName != null && displayName.isNotEmpty) {
      map['displayName'] = displayName;
    }

    return await _loadingService.wrap(
      ref.setData(map, merge: true),
    );
  }

  Future<void> updateCurrentUserPhone(String phoneNumber) async {
    DocumentReference ref = _db.collection('users').document(currentUser.uid);
    return await _loadingService.wrap(ref.setData({'phoneNumber': phoneNumber}, merge: true));
  }

  Future<bool> userExists(String email) async {
    final cloudFunctionsService = getIt.get<CloudFunctionsService>();
    final result = await _loadingService.wrap(cloudFunctionsService.call('userExists', {'email': email}));
    return result;
  }

  Future signOut() async {
    await _loadingService.wrap(_auth.signOut());
  }
}
