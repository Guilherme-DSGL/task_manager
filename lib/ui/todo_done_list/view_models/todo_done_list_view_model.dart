import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/utils/command.dart';
import 'package:task_manager/utils/event_bus/events/todo/check_todo_event.dart';
import 'package:task_manager/utils/event_bus/events/todo/delete_todo_event.dart';
import 'package:task_manager/utils/result.dart';

import '../../../domain/entities/todo_item.dart';
import '../../../domain/usecases/delete_all_todos_usecase.dart';
import '../../../domain/usecases/delete_todo_usecase.dart';
import '../../../utils/event_bus/event_bus.dart';

class TodoDoneListViewModel extends ChangeNotifier {
  TodoDoneListViewModel({
    required TodoRepository todoRepository,
    required DeleteTodoUseCase deleteTodoUseCase,
    required DeleteAllTodosUseCase deleteAllTodoUsecase,
  })  : _todoRepository = todoRepository,
        _deleteTodoUseCase = deleteTodoUseCase,
        _deleteAllTodoUsecase = deleteAllTodoUsecase {
    load = Command1(_load);
    deleteTodo = Command1(_deleteTodo);
    deleteAllTodos = Command0(_deleteAllTodos);
    _listener = EventBus.instance.on<CheckTodoEvent>(source: _classKey).listen(
          (event) => _checkedTodoEvent(event.value),
        );
  }
  String get _classKey => runtimeType.toString();

  final TodoRepository _todoRepository;
  final DeleteTodoUseCase _deleteTodoUseCase;
  final DeleteAllTodosUseCase _deleteAllTodoUsecase;

  late Command1<CountListTodoItem, int> load;
  late Command1<void, int> deleteTodo;
  late Command0<void> deleteAllTodos;

  late final StreamSubscription _listener;
  List<TodoItem> _checkedTodoItems = [];
  List<TodoItem> get checkedTodoItems => _checkedTodoItems;
  TodoItem getTodo(int index) => checkedTodoItems[index];
  final _log = Logger("TodoDoneListViewModel");

  final _limit = 15;

  int get limit => _limit;
  int get currentOffset => _checkedTodoItems.length;

  Future<Result<CountListTodoItem>> _load(int offset) async {
    try {
      return await _getTodos(offset: offset);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<CountListTodoItem>> _getTodos({
    required int offset,
    int? limit,
  }) async {
    final result = await _todoRepository.getTodos(
      isCompleted: true,
      offset: offset,
      limit: limit ?? _limit,
    );
    switch (result) {
      case Ok<CountListTodoItem>():
        _log.fine(
            "load checkeds todos ${result.value.todosItems.length} in ${result.value.count}");
        if (offset == 0) {
          _checkedTodoItems
            ..clear()
            ..addAll(result.value.todosItems);
          return result;
        }
        final items = <TodoItem>{
          ..._checkedTodoItems,
          ...result.value.todosItems,
        }.toList();
        _checkedTodoItems = items;
        return result;
      case Error<CountListTodoItem>():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _deleteTodo(int id) async {
    try {
      final result = await _deleteTodoUseCase.call(id);

      switch (result) {
        case Ok<void>():
          _log.fine("delete todo");
          EventBus.instance.emit(DeleteTodoEvent(
            value: [id],
            source: _classKey,
          ));
        case Error<void>():
          _log.fine("failed to delete todo");
          return Result.error(result.error);
      }

      return await _getTodos(offset: 0, limit: _checkedTodoItems.length - 1);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteAllTodos() async {
    try {
      await Future.delayed(Durations.extralong4);
      final ids = _checkedTodoItems.map((todoItem) => todoItem.id!).toList();

      final result = await _deleteAllTodoUsecase.call(ids);
      switch (result) {
        case Ok<void>():
          _log.fine("delete all completed todos");
          _checkedTodoItems.clear();
          EventBus.instance
              .emit(DeleteTodoEvent(value: ids, source: _classKey));
          return const Result.ok(null);
        case Error<void>():
          _log.fine("failed to delete all completed todos");
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  void _checkedTodoEvent(TodoItem todoItem) {
    try {
      if (todoItem.isCompleted) {
        _checkedTodoItems.add(todoItem);
        _log.fine("add todoitem to TodoScreenViewModel._checkedTodoItems");
        return;
      }
      _removeTodo(todoItem.id!);
    } finally {
      notifyListeners();
    }
  }

  _removeTodo(int id) {
    _checkedTodoItems.removeWhere((todo) => todo.id == id);
    _log.fine("remove todoitem from TodoDoneScreenViewModel._checkedTodoItems");
    if (_checkedTodoItems.length < limit) {
      _getTodos(
        offset: _checkedTodoItems.length,
        limit: limit - _checkedTodoItems.length,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _listener.cancel();
  }
}
