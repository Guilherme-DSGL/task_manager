import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/domain/entities/todo_item.dart';
import 'package:task_manager/domain/usecases/check_todo_usecase.dart';
import 'package:task_manager/utils/result.dart';

import '../../testing/utils/result.dart';

class TodoRepositoryMock extends Mock implements TodoRepository {}

class TodoItemFake extends Fake implements TodoItem {}

void main() {
  late TodoRepositoryMock todoRepositoryMock;
  late CheckTodoUseCase checkTodoUseCase;

  setUpAll(() {
    registerFallbackValue(TodoItemFake());
  });

  setUp(() {
    todoRepositoryMock = TodoRepositoryMock();
    checkTodoUseCase = CheckTodoUseCase(todoRepository: todoRepositoryMock);
  });

  group('CheckTodoUseCase', () {
    test('should check a Todo successfully', () async {
      const todoItem = TodoItem(
        id: 1,
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: true,
      );

      when(() => todoRepositoryMock.update(
            id: any(named: 'id'),
            isCompleted: any(named: 'isCompleted'),
          )).thenAnswer((_) async => const Result.ok(todoItem));

      final result = await checkTodoUseCase.call(
        todoId: 1,
        isCompleted: true,
      );

      expect(result.asOk, isA<Ok>());
      expect(result.asOk.value.isCompleted, isTrue);
      verify(() => todoRepositoryMock.update(id: 1, isCompleted: true))
          .called(1);
    });

    test('should uncheck a Todo successfully', () async {
      const todoItem = TodoItem(
        id: 1,
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
      );

      when(() => todoRepositoryMock.update(
            id: any(named: 'id'),
            isCompleted: any(named: 'isCompleted'),
          )).thenAnswer((_) async => const Result.ok(todoItem));

      final result = await checkTodoUseCase.call(
        todoId: 1,
        isCompleted: false,
      );

      expect(result.asOk, isA<Ok>());
      expect(result.asOk.value.isCompleted, isFalse);
      verify(() => todoRepositoryMock.update(id: 1, isCompleted: false))
          .called(1);
    });

    test('should return an error when the update fails', () async {
      when(() => todoRepositoryMock.update(
                id: any(named: 'id'),
                isCompleted: any(named: 'isCompleted'),
              ))
          .thenAnswer((_) async => Result.error(Exception('Failed to update')));

      final result = await checkTodoUseCase.call(
        todoId: 1,
        isCompleted: true,
      );

      expect(result.asError, isA<Error>());
      expect(result.asError.error, isA<Exception>());
      verify(() => todoRepositoryMock.update(id: 1, isCompleted: true))
          .called(1);
    });
  });
}
