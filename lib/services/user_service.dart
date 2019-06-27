import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class User {
  final int userId;
  final String displayName;
  final String email;
  User(this.userId, {this.displayName, this.email});
}

class UserService {
  final BehaviorSubject<User> _currentUser = BehaviorSubject.seeded(null);

  Observable<User> get currentUser$ => _currentUser.stream;
  User get currentUser => _currentUser.value;

  Observable<bool> get isLoggedIn$ => _currentUser.map((user) => user != null);
  bool get isLoggedIn => currentUser != null;

  setUser(User user) {
    _currentUser.add(user);
  }

  signIn() {
    setUser(User(1, displayName: 'Alex', email: 'alex@email.com'));
    return true;
  }

  signOut() {
    setUser(null);
  }
}
