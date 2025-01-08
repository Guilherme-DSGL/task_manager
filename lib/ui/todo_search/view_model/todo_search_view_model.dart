import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/utils/command.dart';
import 'package:task_manager/utils/result.dart';

import '../../../domain/entities/todo_item.dart';
import '../../../utils/event_bus/event_bus.dart';
import '../../../utils/event_bus/events/todo/created_todo_event.dart';

class TodoSearchViewModel extends ChangeNotifier {
  TodoSearchViewModel({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository {
    load = Command0(_load);
    _createTodoListener = EventBus.instance
        .on<CreatedTodoEvent>()
        .listen((event) => _addTodo(event.value));
  }

  final TodoRepository _todoRepository;

  late Command0<List<TodoItem>> load;
  late Command1<TodoItem, ({int index, int id, bool value})> check;

  late final StreamSubscription _createTodoListener;
  late final StreamSubscription _deleteTodoListener;
  final List<TodoItem> _todoItems = [];
  List<TodoItem> get todoItems => _todoItems;
  TodoItem getTodo(int index) => todoItems[index];
  final _log = Logger("TodoScreenViewModel");

  Future<Result<List<TodoItem>>> _load() async {
    try {
      final result = await _todoRepository.getTodos(
        isCompleted: false,
      );
      switch (result) {
        case Ok<List<TodoItem>>():
          _log.fine("load todos");
          _todoItems
            ..clear()
            ..addAll(result.value);

          return result;
        case Error<List<TodoItem>>():
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  void _addTodo(TodoItem todoItem) {
    _todoItems.add(todoItem);
    _log.fine("add todoitem to TodoScreenViewModel._todoItems");
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _createTodoListener.cancel();
  }
}
