import 'dart:async';

import 'package:task_manager/domain/entities/todo_item.dart';

import '../../../utils/result.dart';

abstract class TodoRepository {
  Future<Result<TodoItem>> create(TodoItem todoItem);
  Future<Result<TodoItem>> update({
    required int id,
    String? title,
    String? description,
    bool? isCompleted,
  });
  Future<Result<void>> delete(int id);
  Future<Result<List<TodoItem>>> getTodos({
    bool? isCompleted,
    String? search,
  });
}

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl();

  final List<TodoItem> _todos = [
    /* const TodoItem(
      id: 1,
      title: 'Task 1',
      description: 'Description 1',
      isCompleted: false,
    ), */
  ];
  int _sequentialId = 0;

  @override
  Future<Result<TodoItem>> create(TodoItem todoItem) async {
    try {
      await Future.delayed(
        const Duration(seconds: 1),
      );
      final newTodo = todoItem.copyWith(id: _sequentialId++);

      _todos.add(newTodo);

      return Result.ok(newTodo);
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
      await Future.delayed(
        const Duration(seconds: 1),
      );
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
      await Future.delayed(
        const Duration(seconds: 1),
      );
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
  Future<Result<List<TodoItem>>> getTodos({
    bool? isCompleted,
    String? search,
  }) async {
    try {
      await Future.delayed(
        const Duration(seconds: 5),
      );
      if (isCompleted == null) {
        return Result.ok(List.unmodifiable(_todos));
      }
      return Result.ok(
        List.unmodifiable(
          _todos.where((todoItem) => todoItem.isCompleted == isCompleted),
        ),
      );
    } catch (e) {
      return Result.error(Exception(e));
    }
  }
}
