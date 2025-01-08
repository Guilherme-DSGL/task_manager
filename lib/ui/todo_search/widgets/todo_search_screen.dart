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
    required TodoSearchViewModel todoScreenViewModel,
  }) : _todoScreenViewModel = todoScreenViewModel;
  final TodoSearchViewModel _todoScreenViewModel;
  @override
  State<TodoSearchScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoSearchScreen>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  late TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
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
              listenable: widget._todoScreenViewModel.search,
              builder: (context, child) {
                return CustomSearchField(
                  enabled: !widget._todoScreenViewModel.search.running,
                  controller: _textEditingController,
                  onSearch: (value) {
                    widget._todoScreenViewModel.search.execute((
                      offset: 0,
                      search: value,
                    ));
                  },
                );
              }),
          const SizedBox(height: 32),
          ListenableBuilder(
            listenable: widget._todoScreenViewModel.search,
            builder: (context, _) {
              if (widget._todoScreenViewModel.search.running &&
                  widget._todoScreenViewModel.todoItems.isEmpty) {
                return const Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              if (widget._todoScreenViewModel.search.error) {
                return Expanded(
                  child: CustomErrorWidget(
                      errorMessage: "An error occurred",
                      onRetry: () {
                        widget._todoScreenViewModel.search.execute((
                          offset: 0,
                          search: _textEditingController.value.text,
                        ));
                      }),
                );
              }

              return Expanded(
                child: ListenableBuilder(
                  listenable: widget._todoScreenViewModel,
                  builder: (context, _) {
                    if (widget._todoScreenViewModel.todoItems.isEmpty) {
                      return TodoNoTasks(
                        title: _textEditingController.value.text.length <= 3
                            ? 'Type to search'
                            : 'No results found',
                      );
                    }
                    return TodoList(
                      scrollController: _scrollController,
                      loadMoreItems: () async {
                        if (widget._todoScreenViewModel.search.running) {
                          return;
                        }
                        await widget._todoScreenViewModel.search.execute(
                          (
                            offset: widget._todoScreenViewModel.currentOffset,
                            search: _textEditingController.value.text,
                          ),
                        );
                      },
                      todoItems: widget._todoScreenViewModel.todoItems,
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
}
