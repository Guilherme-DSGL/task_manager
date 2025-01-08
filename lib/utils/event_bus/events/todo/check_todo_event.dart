import '../../event_bus.dart';

class CheckTodoEvent extends Event {
  CheckTodoEvent({
    required super.value,
  });
}
