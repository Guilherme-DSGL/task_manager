import 'package:flutter/material.dart';

import '../../../../domain/entities/todo_item.dart';
import 'todo_widget.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
    required this.todoItems,
    required this.loadMoreItems,
    this.onCheckChanged,
    this.onDeletePressed,
    required this.scrollController,
    this.showDeleteButton = false,
  });

  final Future<void> Function(
    int? id,
    int index,
    bool? value,
  )? onCheckChanged;
  final Future<void> Function(int id)? onDeletePressed;
  final List<TodoItem> todoItems;
  final Future<void> Function() loadMoreItems;
  final ScrollController scrollController;
  final bool showDeleteButton;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() async {
    final isAtBottom = widget.scrollController.position.pixels ==
        widget.scrollController.position.maxScrollExtent;
    if (isAtBottom && !isLoading) {
      setState(() {
        isLoading = true;
      });
      await widget.loadMoreItems();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate(
          childCount: widget.todoItems.length,
          (context, index) {
            final todo = widget.todoItems[index];
            return TodoWidget(
              key: ValueKey(todo.id),
              title: todo.title,
              description: todo.description,
              isCompleted: todo.isCompleted,
              isDeleteButtonVisible: widget.showDeleteButton,
              onDeletePressed: () async {
                await widget.onDeletePressed?.call(todo.id!);
              },
              onCheckChanged: (value) async {
                await widget.onCheckChanged?.call(
                  todo.id,
                  index,
                  value,
                );
              },
            );
          },
        )),
        SliverToBoxAdapter(
          child: Visibility.maintain(
            visible: isLoading,
            child: const Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 5,
          ),
        )
      ],
    );
  }
}
