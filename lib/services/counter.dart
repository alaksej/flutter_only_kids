import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class Counter {
  final _counter = BehaviorSubject.seeded(0);

  Observable get stream$ => _counter.stream;

  int get current => _counter.value;

  increment() {
    _counter.add(current + 1);
  }
}

Counter counterService = Counter();