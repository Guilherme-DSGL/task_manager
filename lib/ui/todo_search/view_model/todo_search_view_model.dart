import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/domain/usecases/check_todo_usecase.dart';
import 'package:task_manager/utils/command.dart';
import 'package:task_manager/utils/event_bus/events/todo/delete_todo_event.dart';
import 'package:task_manager/utils/result.dart';

import '../../../domain/entities/todo_item.dart';
import '../../../utils/event_bus/event_bus.dart';
import '../../../utils/event_bus/events/todo/check_todo_event.dart';

class TodoSearchViewModel extends ChangeNotifier {
  TodoSearchViewModel({
    required CheckTodoUseCase checkTodoUsecase,
    required TodoRepository todoRepository,
  })  : _todoRepository = todoRepository,
        _checkTodoUsecase = checkTodoUsecase {
    search = Command1(_search);
    check = Command1(_check);

    _checkListener = EventBus.instance
        .on<CheckTodoEvent>(source: _classKey)
        .listen((event) => _updateTodo(event.value));
    _deleteListener = EventBus.instance
        .on<DeleteTodoEvent>(source: _classKey)
        .listen((event) => _removeTodos(event.value));
  }

  String get _classKey => runtimeType.toString();

  final TodoRepository _todoRepository;
  final CheckTodoUseCase _checkTodoUsecase;

  late Command1<CountListTodoItem, ({String search, int offset})> search;
  late Command1<TodoItem, ({int index, int id, bool value})> check;

  late final StreamSubscription _checkListener;
  late final StreamSubscription _deleteListener;

  final TextEditingController textEditingController = TextEditingController();

  List<TodoItem> _todoItems = [];
  List<TodoItem> get todoItems => _todoItems;

  final _log = Logger("TodoSearchViewModel");

  final _limit = 15;
  int get limit => _limit;
  int get currentOffset => _todoItems.length;

  Future<Result<CountListTodoItem>> _search(
      ({String search, int offset}) params) async {
    try {
      if (params.search.length <= 3) {
        _todoItems.clear();
        return const Result.ok((count: 0, todosItems: []));
      }

      return _getTodos((
        offset: params.offset,
        search: params.search,
        limit: limit,
      ));
    } finally {
      notifyListeners();
    }
  }

  Future<Result<CountListTodoItem>> _getTodos(
      ({
        String search,
        int offset,
        int? limit,
      }) params) async {
    final result = await _todoRepository.getTodos(
      search: params.search,
      limit: limit,
      offset: params.offset,
    );
    switch (result) {
      case Ok<CountListTodoItem>():
        _log.fine("${params.search}, ${params.offset}, $limit");
        _log.fine(
            "load ${result.value.todosItems.length} search todos in total ${result.value.count}");

        if (params.offset == 0) {
          _todoItems
            ..clear()
            ..addAll(result.value.todosItems);
          return result;
        }
        final items = <TodoItem>{
          ..._todoItems,
          ...result.value.todosItems,
        }.toList();
        _todoItems = items;

        return result;
      case Error<CountListTodoItem>():
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
      final result = await _checkTodoUsecase.call(
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

  void _updateTodo(TodoItem todoItem) {
    if (_todoItems.isEmpty) return;
    int index = _todoItems.indexWhere((item) => item.id == todoItem.id);
    if (index != -1) {
      _log.fine("Update todo item in TodoSearchViewModel");
      _todoItems[index] = todoItem;
    } else {
      _log.fine("Failed to find todo item to update");
    }
    notifyListeners();
  }

  void _removeTodos(List<int> ids) {
    _log.fine("Delete todos itens in TodoSearchViewModel");
    _todoItems.removeWhere((todoItem) => ids.contains(todoItem.id));

    if (todoItems.length < limit) {
      _getTodos((
        offset: todoItems.length,
        limit: limit - todoItems.length,
        search: textEditingController.value.text,
      ));
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _deleteListener.cancel();
    _checkListener.cancel();
  }
}
