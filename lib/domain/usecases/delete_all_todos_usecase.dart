import 'package:logging/logging.dart';

import '../../data/repositories/todo_repository.dart';
import '../../utils/result.dart';

class DeleteAllTodosUseCase {
  DeleteAllTodosUseCase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  final TodoRepository _todoRepository;
  final _log = Logger('DeleteAllTodoUseCase');

  Future<Result<void>> call(
    List<int> ids,
  ) async {
    final deleteResult = await _todoRepository.deleteAll(ids);

    switch (deleteResult) {
      case Ok<void>():
        _log.fine('All Todo deleted successfully');
        return const Result.ok(null);
      case Error<void>():
        String failedIds = "";
        ids.map((e) {
          "$failedIds, $e";
        });
        _log.warning('Failed to delete Todo with IDs: $failedIds');
        return Result.error(Exception('Failed to delete Todo'));
    }
  }
}
