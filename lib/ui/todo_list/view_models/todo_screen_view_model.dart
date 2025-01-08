import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/utils/command.dart';
import 'package:task_manager/utils/event_bus/events/todo/check_todo_event.dart';
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
    _listener = EventBus.instance
        .on<CreatedTodoEvent>()
        .listen((event) => _addTodo(event.value));
  }

  final TodoRepository _todoRepository;
  final CheckTodoUseCase _checkUsecase;

  late Command1<List<TodoItem>, int> load;
  late Command1<TodoItem, ({int index, int id, bool value})> check;

  late final StreamSubscription _listener;
  final List<TodoItem> _todoItems = [];
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
      final result = await _todoRepository.getTodos(
        isCompleted: false,
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
          _todoItems.addAll(result.value);

          return result;
        case Error<List<TodoItem>>():
          _log.warning("failed to load todos ${result.error}");
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
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
          _todoItems.removeAt(params.index);
          EventBus.instance.emit(CheckTodoEvent(
            value: result.value,
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

  @override
  void dispose() {
    super.dispose();
    _listener.cancel();
  }
}
