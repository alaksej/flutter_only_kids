import 'package:bloc/bloc.dart';

class NavBarEvent {
  final int currentIndex;
  const NavBarEvent(this.currentIndex);
}

class NavBarBloc extends Bloc<NavBarEvent, int> {
  NavBarBloc(super.initialState);

  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(NavBarEvent event) async* {
    yield event.currentIndex;
  }
}
