import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/utils/command.dart';
import 'package:task_manager/utils/result.dart';

import '../../../domain/entities/todo_item.dart';

class TodoSearchViewModel extends ChangeNotifier {
  TodoSearchViewModel({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository {
    search = Command1(_search);
  }

  final TodoRepository _todoRepository;

  late Command1<List<TodoItem>, ({String search, int offset})> search;

  late final StreamSubscription _createTodoListener;

  final List<TodoItem> _todoItems = [];
  List<TodoItem> get todoItems => _todoItems;

  final _log = Logger("TodoSearchViewModel");

  final _limit = 15;
  int get limit => _limit;
  int get currentOffset => _todoItems.length;

  Future<Result<List<TodoItem>>> _search(
      ({String search, int offset}) params) async {
    try {
      await Future.delayed(const Duration(seconds: 500));
      if (params.search.length <= 3) {
        _todoItems.clear();
        return const Result.ok([]);
      }
      final result = await _todoRepository.getTodos(
        search: params.search,
        limit: limit,
        offset: params.offset,
      );
      switch (result) {
        case Ok<List<TodoItem>>():
          _log.fine("${params.search}, ${params.offset}, $limit");
          _log.fine("load search todos ${result.value.length}");

          if (params.offset == 0) {
            _todoItems
              ..clear()
              ..addAll(result.value);
            return result;
          }

          _todoItems.addAll(result.value);

          return result;
        case Error<List<TodoItem>>():
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _createTodoListener.cancel();
  }
}
