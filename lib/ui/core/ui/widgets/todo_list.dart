import 'package:flutter/material.dart';

import '../../../../domain/entities/todo_item.dart';
import 'todo_widget.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.todoItems,
    this.onCheckChanged,
    this.onDeletePressed,
  });

  final Future<void> Function(
    int? id,
    int index,
    bool? value,
  )? onCheckChanged;
  final Future<void> Function(int id)? onDeletePressed;
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
          isDeleteButtonVisible: todo.isCompleted,
          onDeletePressed: () async {
            await onDeletePressed?.call(todo.id!);
          },
          onCheckChanged: (value) async {
            await onCheckChanged?.call(
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
