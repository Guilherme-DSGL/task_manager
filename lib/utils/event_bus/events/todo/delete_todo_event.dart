import 'package:task_manager/utils/event_bus/event_bus.dart';

class DeleteTodoEvent extends Event<List<int>> {
  DeleteTodoEvent({
    required super.value,
    required super.source,
  });
}
