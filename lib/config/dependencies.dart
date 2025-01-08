import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/data/services/local_data_service.dart';
import 'package:task_manager/domain/usecases/check_todo_usecase.dart';
import 'package:task_manager/domain/usecases/create_todo_usecase.dart';
import 'package:task_manager/domain/usecases/delete_todo_usecase.dart';
import 'package:task_manager/services/local_database_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider<TodoRepository>(
      create: (context) => TodoRepositoryImpl(
        LocalDataService(
          localDatabase: LocalDatabaseService.instance,
        ),
      ),
    ),
    Provider(
      lazy: true,
      create: (context) => CreateTodoUseCase(
        todoRepository: context.read<TodoRepository>(),
      ),
    ),
    Provider(
      lazy: true,
      create: (context) => CheckTodoUseCase(
        todoRepository: context.read<TodoRepository>(),
      ),
    ),
    Provider(
      lazy: true,
      create: (context) => DeleteTodoUseCase(
        todoRepository: context.read<TodoRepository>(),
      ),
    ),
  ];
}
