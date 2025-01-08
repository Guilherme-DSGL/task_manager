import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/core/themes/colors.dart';
import 'package:task_manager/ui/core/ui/widgets/custom_text_buttom.dart';
import 'package:task_manager/ui/todo_done_list/view_models/todo_done_list_view_model.dart';

import '../../core/themes/sizes.dart';
import '../../core/ui/widgets/error_widget.dart';
import '../../core/ui/widgets/todo_list.dart';
import '../../todo_list/widgets/todo_no_task.dart';

class TodoDoneListScreen extends StatefulWidget {
  const TodoDoneListScreen({
    super.key,
    required TodoDoneListViewModel todoDoneListViewModel,
  }) : _todoDoneListViewModel = todoDoneListViewModel;

  final TodoDoneListViewModel _todoDoneListViewModel;

  @override
  State<TodoDoneListScreen> createState() => _TodoDoneListScreenState();
}

class _TodoDoneListScreenState extends State<TodoDoneListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    widget._todoDoneListViewModel.deleteTodo.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget._todoDoneListViewModel.deleteTodo.removeListener(_listener);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.paddingVertical,
        horizontal: AppSizes.paddingHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListenableBuilder(
            listenable: widget._todoDoneListViewModel.load,
            builder: (context, _) {
              if (widget._todoDoneListViewModel.load.running) {
                return const Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              if (widget._todoDoneListViewModel.load.error) {
                return Expanded(
                  child: CustomErrorWidget(
                    errorMessage: "An error occurred",
                    onRetry: widget._todoDoneListViewModel.load.execute,
                  ),
                );
              }

              return Expanded(
                child: ListenableBuilder(
                  listenable: widget._todoDoneListViewModel,
                  builder: (context, _) {
                    if (widget
                        ._todoDoneListViewModel.checkedTodoItems.isEmpty) {
                      return const TodoNoTasks();
                    }
                    return TodoDoneHeader(
                      onDeleteAllPressed: () {},
                      children: [
                        TodoList(
                          onDeletePressed: (index) async {
                            await widget._todoDoneListViewModel.deleteTodo
                                .execute(index);
                          },
                          todoItems:
                              widget._todoDoneListViewModel.checkedTodoItems,
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _listener() {
    if (widget._todoDoneListViewModel.deleteTodo.error) {
      widget._todoDoneListViewModel.deleteTodo.clearResult();
      AsukaSnackbar.warning("An error occurred while deleting task").show();
    }
  }
}

class TodoDoneHeader extends StatelessWidget {
  const TodoDoneHeader({
    super.key,
    required this.children,
    required this.onDeleteAllPressed,
  });
  final List<Widget> children;
  final VoidCallback onDeleteAllPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Completed Tasks',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            CustomTextButton(
              label: const Text(
                'Delete All',
                style: TextStyle(
                  color: AppColors.fireRed,
                ),
              ),
              backgroundColor: Colors.transparent,
              onPressed: onDeleteAllPressed,
            ),
          ],
        ),
        const SizedBox(height: 32),
        ...children,
      ],
    );
  }
}
