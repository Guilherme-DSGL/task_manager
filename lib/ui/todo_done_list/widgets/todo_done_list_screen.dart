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
  late ScrollController _scrollController;

  void _onScroll() {
    final loadIsRunning = !widget._todoDoneListViewModel.load.running;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !loadIsRunning) {
      widget._todoDoneListViewModel.load.execute(0);
    }
  }

  @override
  void initState() {
    super.initState();
    widget._todoDoneListViewModel.load.execute(0);
    _scrollController = ScrollController();
    widget._todoDoneListViewModel.deleteTodo.addListener(_listener);
    _scrollController.addListener(_onScroll);
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
              if (widget._todoDoneListViewModel.load.running &&
                  widget._todoDoneListViewModel.checkedTodoItems.isEmpty) {
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
                    onRetry: () {
                      widget._todoDoneListViewModel.load.execute(0);
                    },
                  ),
                );
              }

              return ListenableBuilder(
                listenable: widget._todoDoneListViewModel,
                builder: (context, _) {
                  if (widget._todoDoneListViewModel.checkedTodoItems.isEmpty) {
                    return const Expanded(child: TodoNoTasks());
                  }
                  return Expanded(
                    child: TodoDoneHeader(
                      onDeleteAllPressed: () {},
                      children: [
                        Expanded(
                          child: TodoList(
                            scrollController: _scrollController,
                            onDeletePressed: (index) async {
                              await widget._todoDoneListViewModel.deleteTodo
                                  .execute(index);
                            },
                            todoItems:
                                widget._todoDoneListViewModel.checkedTodoItems,
                            loadMoreItems: () async {
                              await widget._todoDoneListViewModel.load.execute(
                                widget._todoDoneListViewModel.currentOffset,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
