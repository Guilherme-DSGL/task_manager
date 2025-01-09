import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/domain/usecases/delete_todo_usecase.dart';
import 'package:task_manager/utils/result.dart';

import '../../testing/utils/result.dart';

class TodoRepositoryMock extends Mock implements TodoRepository {}

void main() {
  late TodoRepositoryMock todoRepositoryMock;
  late DeleteTodoUseCase deleteTodoUseCase;

  setUp(() {
    todoRepositoryMock = TodoRepositoryMock();
    deleteTodoUseCase = DeleteTodoUseCase(todoRepository: todoRepositoryMock);
  });

  group('DeleteTodoUseCase', () {
    test('should delete a Todo successfully', () async {
      when(() => todoRepositoryMock.delete(any()))
          .thenAnswer((_) async => const Result.ok(null));

      final result = await deleteTodoUseCase.call(1);

      expect(result.asOk, isA<Ok>());
      verify(() => todoRepositoryMock.delete(1)).called(1);
    });

    test('should return an error when deletion fails', () async {
      when(() => todoRepositoryMock.delete(any()))
          .thenAnswer((_) async => Result.error(Exception('Failed to delete')));

      final result = await deleteTodoUseCase.call(1);

      expect(result.asError, isA<Error>());
      expect(result.asError.error, isA<Exception>());
      verify(() => todoRepositoryMock.delete(1)).called(1);
    });
  });
}
