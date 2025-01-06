import 'package:flutter/material.dart';

import '../../core/ui/widgets/todo_widget.dart';
import '../view_models/todo_screen_view_model.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.viewModel,
  });

  final TodoScreenViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: ListView.builder(
        itemCount: viewModel.todoItems.length,
        itemBuilder: (context, index) {
          final todo = viewModel.todoItems[index];
          return TodoWidget(
            title: todo.title,
            description: todo.description,
            isCompleted: todo.isCompleted,
            showDescription: false,
          );
        },
      ),
    );
  }
}
