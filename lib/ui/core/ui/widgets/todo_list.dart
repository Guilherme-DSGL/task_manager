import 'package:flutter/material.dart';

import '../../../../domain/entities/todo_item.dart';
import 'todo_widget.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.todoItems,
    this.onChanged,
  });

  final Future<void> Function(
    int? id,
    int index,
    bool? value,
  )? onChanged;
  final List<TodoItem> todoItems;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todoItems.length,
      itemBuilder: (context, index) {
        final todo = todoItems[index];
        return TodoWidget(
          key: ValueKey(todo.id),
          title: todo.title,
          description: todo.description,
          isCompleted: todo.isCompleted,
          onChanged: (value) async {
            await onChanged?.call(
              todo.id,
              index,
              value,
            );
          },
        );
      },
    );
  }
}
