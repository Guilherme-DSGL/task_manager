import 'package:flutter/material.dart';
import 'package:task_manager/ui/todo/widgets/todo_no_task.dart';

import '../../core/themes/sizes.dart';
import '../../core/ui/widgets/welcome_widget.dart';
import '../view_models/todo_screen_view_model.dart';
import 'todo_list.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late TodoScreenViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = TodoScreenViewModel.instance;
  }

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
          WelcomeWidget(
            taskCount: _viewModel.todoItems.length,
            userName: 'Jhon',
          ),
          const SizedBox(height: 32),
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              if (_viewModel.todoItems.isEmpty) {
                return const Expanded(
                  child: TodoNoTasks(),
                );
              }
              return Expanded(
                child: TodoList(
                  viewModel: _viewModel,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
