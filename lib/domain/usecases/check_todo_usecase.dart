import 'package:logging/logging.dart';

import '../../data/repositories/todo_repository.dart';
import '../../utils/result.dart';
import '../entities/todo_item.dart';

class CheckTodoUseCase {
  CheckTodoUseCase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  final TodoRepository _todoRepository;
  final _log = Logger('CheckTodoUseCase');

  Future<Result<TodoItem>> call({
    required int todoId,
    required bool isCompleted,
  }) async {
    final updateResult = await _todoRepository.update(
      id: todoId,
      isCompleted: isCompleted,
    );

    switch (updateResult) {
      case Ok<TodoItem>():
        _log.fine('Todo ${isCompleted ? "checked" : "unchecked"} successfully');
        return updateResult;
      case Error<void>():
        _log.warning('Failed to update Todo');
        return Result.error(Exception('Failed to update Todo'));
    }
  }
}
