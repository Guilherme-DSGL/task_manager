import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/todo_item.dart';
import '../../../utils/event_bus/event_bus.dart';
import '../../../utils/event_bus/events/todo/created_todo_event.dart';

class TodoScreenViewModel extends ChangeNotifier {
  TodoScreenViewModel._() {
    _listener = EventBus.instance
        .on<CreatedTodoEvent>()
        .listen((event) => _addTodo(event.value));
  }
  static TodoScreenViewModel? _intance;

  static TodoScreenViewModel get instance {
    _intance ??= TodoScreenViewModel._();
    return _intance!;
  }

  late final StreamSubscription _listener;

  final List<TodoItem> _todoItems = [
    const TodoItem(
      id: 1,
      title: "Design sign up flow",
      description:
          "By the time a prospect arrives at your signup page, in most cases, they've already By the time a prospect arrives at your signup page, in most cases.",
      isCompleted: false,
    ),
    const TodoItem(
      id: 1,
      title: "Design sign up flow",
      description:
          "By the time a prospect arrives at your signup page, in most cases, they've already By the time a prospect arrives at your signup page, in most cases.",
      isCompleted: false,
    )
  ];

  List<TodoItem> get todoItems => _todoItems;

  TodoItem getTodo(int index) => todoItems[index];

  void _addTodo(TodoItem todoItem) {
    _todoItems.add(todoItem);
  }

  void _load() async {
    try {} finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _listener.cancel();
  }
}
