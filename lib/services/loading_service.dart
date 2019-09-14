import 'package:rxdart/rxdart.dart';

class LoadingService {
  LoadingService() {
    loading$ = _counter$.map((n) => n > 0);
  }

  BehaviorSubject<int> _counter$ = BehaviorSubject.seeded(0);
  int get count => _counter$.value;
  Stream<bool> loading$;

  begin() {
    _counter$.add(count + 1);
  }

  end() {
    assert(count > 0);
    _counter$.add(count - 1);
  }
}
