import 'package:flutter/material.dart';
import 'package:task_manager/ui/todo/widgets/todo_no_task.dart';

import '../../core/themes/sizes.dart';
import '../../core/ui/widgets/welcome_widget.dart';
import '../view_models/todo_screen_view_model.dart';
import 'todo_list.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({
    super.key,
    required this.viewModel,
  });

  final TodoScreenViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.paddingVertical,
        horizontal: AppSizes.paddingHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomeWidget(
            taskCount: 7,
            userName: 'Jhon',
          ),
          const SizedBox(height: 32),
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              if (viewModel.todoItems.isEmpty) {
                return const Expanded(
                  child: TodoNoTasks(),
                );
              }
              return Expanded(
                child: TodoList(
                  viewModel: viewModel,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
