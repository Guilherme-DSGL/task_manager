import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/core/ui/widgets/error_widget.dart';

import '../../core/themes/sizes.dart';
import '../../core/ui/widgets/custom_modal_bottom_sheet.dart';
import '../../core/ui/widgets/todo_list.dart';
import '../../core/ui/widgets/welcome_widget.dart';
import '../../todo_form/view_models/todo_form_view_model.dart';
import '../../todo_form/widgets/todo_form_screen.dart';
import '../view_models/todo_screen_view_model.dart';
import 'todo_no_task.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({
    super.key,
    required TodoScreenViewModel todoScreenViewModel,
  }) : _todoScreenViewModel = todoScreenViewModel;
  final TodoScreenViewModel _todoScreenViewModel;
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    widget._todoScreenViewModel.load.execute(0);
    widget._todoScreenViewModel.check.addListener(_listener);
  }

  @override
  void dispose() {
    widget._todoScreenViewModel.check.removeListener(_listener);
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
            listenable: widget._todoScreenViewModel.load,
            builder: (context, _) {
              if (widget._todoScreenViewModel.load.running &&
                  widget._todoScreenViewModel.todoItems.isEmpty) {
                return const Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              if (widget._todoScreenViewModel.load.error) {
                return Expanded(
                  child: CustomErrorWidget(
                      errorMessage: "An error occurred",
                      onRetry: () {
                        widget._todoScreenViewModel.load.execute(0);
                      }),
                );
              }

              return Expanded(
                child: TodoHeader(
                  todosCount: widget._todoScreenViewModel.count,
                  children: [
                    Expanded(
                      child: ListenableBuilder(
                        listenable: widget._todoScreenViewModel,
                        builder: (context, _) {
                          if (widget._todoScreenViewModel.todoItems.isEmpty) {
                            return TodoNoTasks(
                              onCreateTaksPressed: () => _showTodoForm(context),
                            );
                          }
                          return TodoList(
                            scrollController: _scrollController,
                            loadMoreItems: () async {
                              if (widget._todoScreenViewModel.load.running) {
                                return;
                              }
                              await widget._todoScreenViewModel.load.execute(
                                widget._todoScreenViewModel.currentOffset,
                              );
                            },
                            todoItems: widget._todoScreenViewModel.todoItems,
                            onCheckChanged: (id, index, value) async {
                              if (value == null) return;
                              await widget._todoScreenViewModel.check.execute((
                                id: id!,
                                index: index,
                                value: value,
                              ));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _showTodoForm(BuildContext context) {
    showCustomModalBottomSheet(
      context,
      builder: (modalContext) => TodoFormScreen(
        createTodoViewModel: context.read<TodoFormViewModel>(),
      ),
    );
  }

  _listener() {
    if (widget._todoScreenViewModel.check.error) {
      widget._todoScreenViewModel.check.clearResult();
      AsukaSnackbar.warning("An error occurred while checking task").show();
    }
  }
}

class TodoHeader extends StatelessWidget {
  const TodoHeader({
    super.key,
    required this.todosCount,
    required this.children,
  });
  final int todosCount;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WelcomeWidget(
          taskCount: todosCount,
          userName: 'Jhon',
        ),
        const SizedBox(height: 32),
        ...children,
      ],
    );
  }
}
