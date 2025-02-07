import 'package:task_manager/utils/event_bus/event_bus.dart';

import '../../../../domain/entities/todo_item.dart';

class CheckTodoEvent extends Event<TodoItem> {
  CheckTodoEvent({
    required super.value,
    required super.source,
  });
}
