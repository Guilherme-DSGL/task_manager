import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/domain/usecases/delete_all_todos_usecase.dart';
import 'package:task_manager/utils/result.dart';

import '../../testing/utils/result.dart';

class TodoRepositoryMock extends Mock implements TodoRepository {}

void main() {
  late TodoRepositoryMock todoRepositoryMock;
  late DeleteAllTodosUseCase deleteAllTodosUseCase;

  setUp(() {
    todoRepositoryMock = TodoRepositoryMock();
    deleteAllTodosUseCase =
        DeleteAllTodosUseCase(todoRepository: todoRepositoryMock);
  });

  group('DeleteAllTodosUseCase', () {
    test('should delete all Todos successfully', () async {
      when(() => todoRepositoryMock.deleteAll(any()))
          .thenAnswer((_) async => const Result.ok(null));

      final result = await deleteAllTodosUseCase.call([1, 2, 3]);

      expect(result.asOk, isA<Ok>());
      verify(() => todoRepositoryMock.deleteAll([1, 2, 3])).called(1);
    });

    test('should return an error when deletion of all Todos fails', () async {
      when(() => todoRepositoryMock.deleteAll(any()))
          .thenAnswer((_) async => Result.error(Exception('Failed to delete')));

      final result = await deleteAllTodosUseCase.call([1, 2, 3]);

      expect(result.asError, isA<Error>());
      expect(result.asError.error, isA<Exception>());
      verify(() => todoRepositoryMock.deleteAll([1, 2, 3])).called(1);
    });
  });
}
