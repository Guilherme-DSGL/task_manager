import 'package:logging/logging.dart';
import 'package:task_manager/domain/entities/todo_item.dart';

import '../../../utils/result.dart';
import '../../data/repositories/todo_repository.dart';

class CreateTodoUseCase {
  CreateTodoUseCase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  final TodoRepository _todoRepository;
  final _log = Logger('CreateTodoUseCase');

  Future<Result<TodoItem>> call({
    required String? title,
    required String? description,
  }) async {
    if (title == null || title.isEmpty) {
      _log.warning('Title is not set');
      return Result.error(Exception('Title cannot be empty'));
    }

    if (description == null || description.isEmpty) {
      _log.warning('Description is not set');
      return Result.error(Exception('Description cannot be empty'));
    }

    final todoItem = TodoItem(
      title: title,
      description: description,
      isCompleted: false,
    );

    final createTodoResult = await _todoRepository.create(todoItem);

    switch (createTodoResult) {
      case Ok<TodoItem>():
        _log.fine("Todo created successfully");
        return Result.ok(createTodoResult.value);
      case Error<TodoItem>():
        _log.warning("Failed to save Todo");
        return Result.error(
          Exception('Failed to save Todo'),
        );
    }
  }
}
