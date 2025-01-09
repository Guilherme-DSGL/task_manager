import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/utils/command.dart';
import 'package:task_manager/utils/event_bus/events/todo/check_todo_event.dart';
import 'package:task_manager/utils/event_bus/events/todo/delete_todo_event.dart';
import 'package:task_manager/utils/result.dart';

import '../../../domain/entities/todo_item.dart';
import '../../../domain/usecases/check_todo_usecase.dart';
import '../../../utils/event_bus/event_bus.dart';
import '../../../utils/event_bus/events/todo/created_todo_event.dart';

class TodoScreenViewModel extends ChangeNotifier {
  TodoScreenViewModel({
    required TodoRepository todoRepository,
    required CheckTodoUseCase checkUsecase,
  })  : _todoRepository = todoRepository,
        _checkUsecase = checkUsecase {
    load = Command1(_load);
    check = Command1(_check);
    _createListener = EventBus.instance
        .on<CreatedTodoEvent>(source: _classKey)
        .listen((event) => _addTodo(event.value));
    _checkListener = EventBus.instance
        .on<CheckTodoEvent>(source: _classKey)
        .listen((event) => _updateTodo(event.value));
    _deleteListener = EventBus.instance
        .on<DeleteTodoEvent>(source: _classKey)
        .listen((event) => _removeTodo(event.value));
  }

  String get _classKey => runtimeType.toString();

  final TodoRepository _todoRepository;
  final CheckTodoUseCase _checkUsecase;

  //Actions
  late Command1<List<TodoItem>, int> load;
  late Command1<TodoItem, ({int index, int id, bool value})> check;

  //Listerners
  late final StreamSubscription _createListener;
  late final StreamSubscription _checkListener;
  late final StreamSubscription _deleteListener;

  List<TodoItem> _todoItems = [];
  List<TodoItem> get todoItems => _todoItems;
  TodoItem getTodo(int index) => todoItems[index];

  final _log = Logger("TodoScreenViewModel");

  final _limit = 15;
  int get limit => _limit;
  int get currentOffset => _todoItems.length;

  Future<Result<List<TodoItem>>> _load(
    int offset,
  ) async {
    try {
      return await _getTodos(offset, limit);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<List<TodoItem>>> _getTodos(int offset, int limit) async {
    final result = await _todoRepository.getTodos(
      offset: offset,
      limit: limit,
    );
    switch (result) {
      case Ok<List<TodoItem>>():
        _log.fine("load todos ${result.value.length}");
        if (offset == 0) {
          _todoItems
            ..clear()
            ..addAll(result.value);
          return result;
        }
        final items = <TodoItem>{
          ..._todoItems,
          ...result.value,
        }.toList();
        _todoItems = items;

        return result;
      case Error<List<TodoItem>>():
        _log.warning("failed to load todos ${result.error}");
        return Result.error(result.error);
    }
  }

  Future<Result<TodoItem>> _check(
      ({
        int index,
        int id,
        bool value,
      }) params) async {
    try {
      final result = await _checkUsecase.call(
          todoId: params.id, isCompleted: params.value);
      switch (result) {
        case Ok<TodoItem>():
          _log.fine("Checked todo");
          _todoItems[params.index] = result.value;
          EventBus.instance.emit(CheckTodoEvent(
            value: result.value,
            source: _classKey,
          ));
          return result;
        case Error<TodoItem>():
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

  void _updateTodo(TodoItem todoItem) {
    int index = _todoItems.indexWhere((item) => item.id == todoItem.id);
    if (index != -1) {
      _log.fine("update todoitem to TodoScreenViewModel._todoItems at $index");
      _log.fine(todoItem.toString());
      _todoItems[index] = todoItem;
    } else {
      _log.warning("Failed to find todo item to update");
    }
    notifyListeners();
  }

  void _removeTodo(List<int> ids) {
    _log.fine("delete todoitem to TodoScreenViewModel._todoItems");
    _todoItems.removeWhere((item) => ids.contains(item.id));
    if (todoItems.length < limit) {
      _getTodos(todoItems.length, limit - todoItems.length);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _createListener.cancel();
    _checkListener.cancel();
    _deleteListener.cancel();
  }
}
