import 'dart:async';

class Event<T> {
  final T value;

  Event({
    required this.value,
  });
}

class EventBus {
  EventBus._({
    bool sync = false,
  }) : _streamController = StreamController.broadcast(sync: sync);

  static EventBus? _instance;

  static EventBus get instance {
    _instance ??= EventBus._(
      sync: false,
    );
    return _instance!;
  }

  final StreamController _streamController;

  StreamController get streamController => _streamController;

  Stream<T> on<T extends Event>() {
    if (T == dynamic) {
      return streamController.stream as Stream<T>;
    } else {
      return streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  void emit<T>(T event) {
    streamController.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}
