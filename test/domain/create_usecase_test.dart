import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/domain/entities/todo_item.dart';
import 'package:task_manager/domain/usecases/create_todo_usecase.dart';
import 'package:task_manager/utils/result.dart';

import '../../testing/utils/result.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class TodoItemFake extends Fake implements TodoItem {}

void main() {
  late MockTodoRepository mockTodoRepository;
  late CreateTodoUseCase createTodoUseCase;

  setUpAll(() {
    registerFallbackValue(TodoItemFake());
    mockTodoRepository = MockTodoRepository();
    createTodoUseCase = CreateTodoUseCase(todoRepository: mockTodoRepository);
  });

  group('CreateTodoUseCase', () {
    test('should return error when title is empty', () async {
      final result = await createTodoUseCase.call(
        title: '',
        description: 'Description',
      );

      expect(result.asError, isA<Error>());
    });

    test('should return error when description is empty', () async {
      final result = await createTodoUseCase.call(
        title: 'Valid Title',
        description: '',
      );

      expect(result.asError, isA<Error>());
    });

    test('should return created TodoItem when repository succeeds', () async {
      const mockValidItem = TodoItem(
        id: 1,
        title: 'Valid Title',
        description: 'Valid Description',
        isCompleted: false,
      );

      when(() => mockTodoRepository.create(any())).thenAnswer(
        (_) async => const Result.ok(mockValidItem),
      );

      final result = await createTodoUseCase.call(
        title: mockValidItem.title,
        description: mockValidItem.description,
      );

      expect(result.asOk, isA<Ok<TodoItem>>());
      expect(result.asOk.value, mockValidItem);
      verify(() => mockTodoRepository.create(any())).called(1);
    });

    test('should return error when repository fails', () async {
      when(() => mockTodoRepository.create(any())).thenAnswer(
        (_) async => Result.error(Exception('Failed to save Todo')),
      );

      final result = await createTodoUseCase.call(
        title: 'Valid Title',
        description: 'Valid Description',
      );

      expect(result.asError, isA<Error>());
      expect(result.asError.error.toString(), 'Exception: Failed to save Todo');
      verify(() => mockTodoRepository.create(any())).called(1);
    });
  });
}
