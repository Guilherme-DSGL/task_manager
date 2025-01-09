import 'dart:async';

class Event<T> {
  final T value;
  final String source;
  Event({
    required this.value,
    required this.source,
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

  Stream<T> on<T extends Event>({required String source}) {
    if (T == dynamic) {
      return streamController.stream as Stream<T>;
    } else {
      return streamController.stream
          .where((event) => event is T && event.source != source)
          .cast<T>();
    }
  }

  void emit<T extends Event>(T event) {
    streamController.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}
