import 'package:bloc/bloc.dart';

class UserEvent {
  final int currentUserId;
  const UserEvent(this.currentUserId);
}

class UserBloc extends Bloc<UserEvent, int> {
  UserBloc(super.initialState);

  @override
  int? get initialState => null;

  bool get isLoggedIn => initialState != null;

  @override
  Stream<int> mapEventToState(UserEvent event) async* {
    yield event.currentUserId;
  }
}
