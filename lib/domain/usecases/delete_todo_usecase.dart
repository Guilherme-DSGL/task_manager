import 'package:logging/logging.dart';

import '../../data/repositories/todo_repository.dart';
import '../../utils/result.dart';

class DeleteTodoUseCase {
  DeleteTodoUseCase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  final TodoRepository _todoRepository;
  final _log = Logger('DeleteTodoUseCase');

  Future<Result<void>> call({
    required int todoId,
  }) async {
    final deleteResult = await _todoRepository.delete(todoId);

    switch (deleteResult) {
      case Ok<void>():
        _log.fine('Todo deleted successfully');
        return const Result.ok(null);
      case Error<void>():
        _log.warning('Failed to delete Todo with ID: $todoId');
        return Result.error(Exception('Failed to delete Todo'));
    }
  }
}
