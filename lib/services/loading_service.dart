import 'package:rxdart/rxdart.dart';

class LoadingService {
  LoadingService() {
    loading$ = _counter$.map((n) => n > 0);
  }

  BehaviorSubject<int> _counter$ = BehaviorSubject.seeded(0);
  int get count => _counter$.value;
  late Stream<bool> loading$;

  _begin() {
    _counter$.add(count + 1);
  }

  _end() {
    assert(count > 0);
    _counter$.add(count - 1);
  }

  Future<T> wrap<T>(Future<T> future) async {
    try {
      _begin();
      return await future;
    } finally {
      _end();
    }
  }
}
