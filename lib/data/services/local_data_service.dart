import 'package:task_manager/data/models/todo_item_model.dart';

import '../../domain/entities/todo_item.dart';
import '../../services/local_database_service.dart';

class LocalDataService {
  LocalDataService({
    required this.localDatabase,
  });

  final LocalDatabaseService localDatabase;

  Future<TodoItemModel> createTodo(TodoItem todoItem) async {
    try {
      final model = TodoItemModel(
        title: todoItem.title,
        description: todoItem.description,
        isCompleted: todoItem.isCompleted ? 1 : 0,
      );
      final id = await localDatabase.insert('todos', model.toJson());
      final newModel = model.copyWith(id: id);
      return newModel;
    } catch (e) {
      throw Exception('Failed to create Todo: $e');
    }
  }

  Future<TodoItemModel> updateTodo({
    required int id,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    try {
      final values = {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (isCompleted != null) 'isCompleted': isCompleted ? 1 : 0,
      };

      final updatedRows = await localDatabase.update(
        'todos',
        values,
        'id = ?',
        [id],
      );

      if (updatedRows == 0) {
        throw Exception('Todo not found');
      }

      return await _getTodoById(id);
    } catch (e) {
      throw Exception('Failed to update Todo: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final deletedRows = await localDatabase.delete('todos', 'id = ?', [id]);
      if (deletedRows == 0) {
        throw Exception('Todo not found');
      }
    } catch (e) {
      throw Exception('Failed to delete Todo: $e');
    }
  }

  Future<void> deleteAllTodos(List<int> ids) async {
    try {
      final deletedRows = await localDatabase.delete(
        'todos',
        'id IN (${ids.map((_) => '?').join(', ')})',
        ids,
      );
      if (deletedRows == 0) {
        throw Exception('No Todos deleted');
      }
    } catch (e) {
      throw Exception('Failed to delete Todos: $e');
    }
  }

  Future<({int count, List<TodoItemModel> todosItems})> getTodos({
    bool? isCompleted,
    String? search,
    int? limit,
    int? offset,
  }) async {
    try {
      final whereClauses = <String>[];
      final whereArgs = <Object?>[];

      if (isCompleted != null) {
        whereClauses.add('isCompleted = ?');
        whereArgs.add(isCompleted ? 1 : 0);
      }

      if (search != null && search.isNotEmpty) {
        whereClauses.add('(title LIKE ? OR description LIKE ?)');
        whereArgs.addAll(['%$search%', '%$search%']);
      }

      final count = await localDatabase.count(
        'todos',
        where: whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null,
        whereArgs: whereArgs,
      );

      print("A quantidade foi $count");

      final result = await localDatabase.query(
        'todos',
        where: whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null,
        whereArgs: whereArgs,
        limit: limit,
        offset: offset,
      );

      return (
        count: count,
        todosItems: result.map((json) => TodoItemModel.fromJson(json)).toList()
      );
    } catch (e) {
      throw Exception('Failed to fetch Todos: $e');
    }
  }

  Future<TodoItemModel> _getTodoById(int id) async {
    try {
      final result = await localDatabase.query(
        'todos',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) {
        throw Exception('Todo not found');
      }

      return TodoItemModel.fromJson(result.first);
    } catch (e) {
      throw Exception('Failed to fetch Todo by ID: $e');
    }
  }
}
