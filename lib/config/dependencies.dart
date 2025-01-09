import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:task_manager/data/repositories/todo_repository.dart';
import 'package:task_manager/data/services/local_data_service.dart';
import 'package:task_manager/domain/usecases/check_todo_usecase.dart';
import 'package:task_manager/domain/usecases/create_todo_usecase.dart';
import 'package:task_manager/domain/usecases/delete_all_todos_usecase.dart';
import 'package:task_manager/domain/usecases/delete_todo_usecase.dart';
import 'package:task_manager/services/local_database_service.dart';

import '../ui/home/view_models/home_viewmodel.dart';
import '../ui/todo_done_list/view_models/todo_done_list_view_model.dart';
import '../ui/todo_form/view_models/todo_form_view_model.dart';
import '../ui/todo_list/view_models/todo_screen_view_model.dart';
import '../ui/todo_search/view_model/todo_search_view_model.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (context) => LocalDataService(
        localDatabase: LocalDatabaseService.instance,
      ),
    ),
    Provider<TodoRepository>(
      create: (context) => TodoRepositoryImpl(
        context.read<LocalDataService>(),
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
    Provider(
      lazy: true,
      create: (context) => DeleteAllTodosUseCase(
        todoRepository: context.read<TodoRepository>(),
      ),
    ),
  ];
}

List<SingleChildWidget> get homeScreenProviders {
  return [
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => HomeViewModel(),
    ),
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => TodoFormViewModel(
        createTodoUseCase: context.read<CreateTodoUseCase>(),
      ),
    ),
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => TodoScreenViewModel(
        todoRepository: context.read<TodoRepository>(),
        checkUsecase: context.read<CheckTodoUseCase>(),
      ),
    ),
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => TodoFormViewModel(
        createTodoUseCase: context.read<CreateTodoUseCase>(),
      ),
    ),
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => TodoDoneListViewModel(
        todoRepository: context.read<TodoRepository>(),
        deleteAllTodoUsecase: context.read<DeleteAllTodosUseCase>(),
        deleteTodoUseCase: context.read<DeleteTodoUseCase>(),
      ),
    ),
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => TodoSearchViewModel(
        todoRepository: context.read<TodoRepository>(),
        checkTodoUsecase: context.read<CheckTodoUseCase>(),
      ),
    ),
  ];
}
