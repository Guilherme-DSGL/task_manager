import 'dart:async';

import 'package:task_manager/data/models/todo_item_model.dart';
import 'package:task_manager/domain/entities/todo_item.dart';

import '../../../utils/result.dart';
import '../services/local_data_service.dart';

abstract class TodoRepository {
  Future<Result<TodoItem>> create(TodoItem todoItem);
  Future<Result<TodoItem>> update({
    required int id,
    String? title,
    String? description,
    bool? isCompleted,
  });
  Future<Result<void>> delete(int id);
  Future<Result<void>> deleteAll(List<int> ids);
  Future<Result<List<TodoItem>>> getTodos({
    bool? isCompleted,
    String? search,
    int? limit,
    int? offset,
  });
}

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(
    this.localDataService,
  );
  final LocalDataService localDataService;

  static const hasInternet = false; // mock internet connection

  @override
  Future<Result<TodoItem>> create(TodoItem todoItem) async {
    try {
      // Aqui deve se chamar o RemoteDataService se for sucesso, deve criar a task no localDataService
      final todoModel = await localDataService.createTodo(todoItem);
      final newTodo = TodoItem(
        id: todoModel.id,
        title: todoModel.title,
        description: todoModel.description,
        isCompleted: todoModel.isCompleted == 1 ? true : false,
      );
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
      final updatedModel = await localDataService.updateTodo(
        id: id,
        title: title,
        description: description,
        isCompleted: isCompleted,
      );

      return Result.ok(TodoItem(
        id: updatedModel.id,
        title: updatedModel.title,
        description: updatedModel.description,
        isCompleted: updatedModel.isCompleted == 1 ? true : false,
      ));
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<void>> delete(int id) async {
    try {
      await localDataService.deleteTodo(id);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<void>> deleteAll(List<int> ids) async {
    try {
      await localDataService.deleteAllTodos(ids);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  @override
  Future<Result<List<TodoItem>>> getTodos({
    bool? isCompleted,
    String? search,
    int? limit,
    int? offset,
  }) async {
    try {
      List<TodoItemModel> models;
      if (hasInternet) {
        models = [];
      } else {
        models = await localDataService.getTodos(
          isCompleted: isCompleted,
          search: search,
          limit: limit,
          offset: offset,
        );
      }

      final entities = models
          .map(
            (model) => TodoItem(
              id: model.id,
              title: model.title,
              description: model.description,
              isCompleted: model.isCompleted == 1 ? true : false,
            ),
          )
          .toList();
      return Result.ok(entities);
    } catch (e) {
      return Result.error(Exception(e));
    }
  }
}
