import 'dart:async';

import 'package:task_manager/domain/entities/todo_item.dart';

import '../../../utils/result.dart';

abstract class TodoRepository {
  Future<Result<void>> create(TodoItem todoItem);
  Future<Result<TodoItem>> update({
    required int id,
    String? title,
    String? description,
    bool? isCompleted,
  });
  Future<Result<void>> delete(int id);
  Future<Result<List<TodoItem>>> getTodos();
}

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl();

  final List<TodoItem> _todos = [];
  int _sequentialId = 0;

  @override
  Future<Result<void>> create(TodoItem todoItem) async {
    try {
      final newTodo = todoItem.copyWith(id: _sequentialId++);

      _todos.add(newTodo);

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<TodoItem>> update({
    required int id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    try {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index == -1) {
        return Result.error(Exception('Todo not found'));
      }

      _todos[index] = _todos[index].copyWith(
        title: title ?? _todos[index].title,
        description: description ?? _todos[index].description,
        isCompleted: isCompleted ?? _todos[index].isCompleted,
      );

      return Result.ok(_todos[index]);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<void>> delete(int id) async {
    try {
      final int index = _todos.indexWhere((todo) => todo.id == id);
      if (index == -1) {
        return Result.error(Exception('Todo not found'));
      }
      _todos.removeAt(index);

      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<List<TodoItem>>> getTodos() async {
    try {
      return Result.ok(List.unmodifiable(_todos));
    } catch (e) {
      return Result.error(Exception(e));
    }
  }
}
