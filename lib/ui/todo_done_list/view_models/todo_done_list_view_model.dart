import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/utils/command.dart';
import 'package:task_manager/utils/event_bus/events/todo/check_todo_event.dart';
import 'package:task_manager/utils/result.dart';

import '../../../domain/entities/todo_item.dart';
import '../../../domain/usecases/delete_todo_usecase.dart';
import '../../../utils/event_bus/event_bus.dart';

class TodoDoneListViewModel extends ChangeNotifier {
  TodoDoneListViewModel({
    required TodoRepository todoRepository,
    required DeleteTodoUseCase deleteTodoUseCase,
  })  : _todoRepository = todoRepository,
        _deleteTodoUseCase = deleteTodoUseCase {
    load = Command0(_load);
    deleteTodo = Command1(_deleteTodo);
    _listener = EventBus.instance.on<CheckTodoEvent>().listen(
          (event) => _addCheckedTodo(event.value),
        );
  }

  final TodoRepository _todoRepository;
  final DeleteTodoUseCase _deleteTodoUseCase;
  late Command0<List<TodoItem>> load;
  late Command1<void, int> deleteTodo;

  late final StreamSubscription _listener;
  final List<TodoItem> _checkedTodoItems = [];
  List<TodoItem> get checkedTodoItems => _checkedTodoItems;
  TodoItem getTodo(int index) => checkedTodoItems[index];
  final _log = Logger("TodoDoneListViewModel");

  Future<Result<List<TodoItem>>> _load() async {
    try {
      return _getTodos();
    } finally {
      notifyListeners();
    }
  }

  Future<Result<List<TodoItem>>> _getTodos() async {
    final result = await _todoRepository.getTodos(
      isCompleted: true,
    );
    switch (result) {
      case Ok<List<TodoItem>>():
        _log.fine("load checkeds todos");
        _checkedTodoItems
          ..clear()
          ..addAll(result.value);
        return result;
      case Error<List<TodoItem>>():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _deleteTodo(int id) async {
    try {
      final result = await _deleteTodoUseCase.call(id);

      switch (result) {
        case Ok<void>():
          _log.fine("delete todo");

        case Error<void>():
          _log.fine("failed to delete todo");
          return Result.error(result.error);
      }

      return _getTodos();
    } finally {
      notifyListeners();
    }
  }

  void _addCheckedTodo(TodoItem todoItem) {
    _checkedTodoItems.add(todoItem);
    _log.fine("add todoitem to TodoScreenViewModel._checkedTodoItems");
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _listener.cancel();
  }
}
