import 'package:bloc/bloc.dart';

enum CounterEvent { increment }

class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.increment:
        yield currentState + 1;
        break;
    }
  }
}
