import 'package:task_manager/domain/entities/todo_item.dart';

import '../../event_bus.dart';

class CreatedTodoEvent extends Event<TodoItem> {
  CreatedTodoEvent({
    required super.value,
    required super.source,
  });
}
