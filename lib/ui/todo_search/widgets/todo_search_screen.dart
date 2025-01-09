import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/core/ui/widgets/error_widget.dart';

import '../../core/themes/sizes.dart';
import '../../core/ui/widgets/todo_list.dart';
import '../../todo_list/widgets/todo_no_task.dart';
import '../view_model/todo_search_view_model.dart';
import 'custom_search_field.dart';

class TodoSearchScreen extends StatefulWidget {
  const TodoSearchScreen({
    super.key,
    required TodoSearchViewModel todoSearchScreenViewModel,
  }) : _todoSearchScreenViewModel = todoSearchScreenViewModel;
  final TodoSearchViewModel _todoSearchScreenViewModel;
  @override
  State<TodoSearchScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoSearchScreen>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    widget._todoSearchScreenViewModel.check.addListener(_listener);
  }

  @override
  void dispose() {
    widget._todoSearchScreenViewModel.check.removeListener(_listener);
    _scrollController.dispose();
    widget._todoSearchScreenViewModel.textEditingController.dispose();
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
              listenable: widget._todoSearchScreenViewModel.search,
              builder: (context, child) {
                return CustomSearchField(
                  enabled: !widget._todoSearchScreenViewModel.search.running,
                  controller:
                      widget._todoSearchScreenViewModel.textEditingController,
                  onSearch: (value) {
                    widget._todoSearchScreenViewModel.search.execute((
                      offset: 0,
                      search: value,
                    ));
                  },
                );
              }),
          const SizedBox(height: 32),
          ListenableBuilder(
            listenable: widget._todoSearchScreenViewModel.search,
            builder: (context, _) {
              if (widget._todoSearchScreenViewModel.search.running &&
                  widget._todoSearchScreenViewModel.todoItems.isEmpty) {
                return const Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              if (widget._todoSearchScreenViewModel.search.error) {
                return Expanded(
                  child: CustomErrorWidget(
                      errorMessage: "An error occurred",
                      onRetry: () {
                        widget._todoSearchScreenViewModel.search.execute((
                          offset: 0,
                          search: widget._todoSearchScreenViewModel
                              .textEditingController.value.text,
                        ));
                      }),
                );
              }

              return Expanded(
                child: ListenableBuilder(
                  listenable: widget._todoSearchScreenViewModel,
                  builder: (context, _) {
                    if (widget._todoSearchScreenViewModel.todoItems.isEmpty) {
                      return TodoNoTasks(
                        title: widget._todoSearchScreenViewModel
                                    .textEditingController.value.text.length <=
                                3
                            ? 'Type to search'
                            : 'No results found',
                      );
                    }
                    return TodoList(
                      scrollController: _scrollController,
                      loadMoreItems: () async {
                        if (widget._todoSearchScreenViewModel.search.running) {
                          return;
                        }
                        await widget._todoSearchScreenViewModel.search.execute(
                          (
                            offset:
                                widget._todoSearchScreenViewModel.currentOffset,
                            search: widget._todoSearchScreenViewModel
                                .textEditingController.value.text,
                          ),
                        );
                      },
                      onCheckChanged: (id, index, value) async {
                        if (value == null) return;
                        await widget._todoSearchScreenViewModel.check.execute((
                          id: id!,
                          index: index,
                          value: value,
                        ));
                      },
                      todoItems: widget._todoSearchScreenViewModel.todoItems,
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
    if (widget._todoSearchScreenViewModel.check.error) {
      widget._todoSearchScreenViewModel.check.clearResult();
      AsukaSnackbar.warning("An error occurred while checking task").show();
    }
  }
}
