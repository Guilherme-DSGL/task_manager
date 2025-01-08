import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:task_manager/domain/entities/todo_item.dart';
import 'package:task_manager/domain/usecases/create_todo_usecase.dart';
import 'package:task_manager/utils/event_bus/event_bus.dart';

import '../../../utils/command.dart';
import '../../../utils/event_bus/events/todo/created_todo_event.dart';
import '../../../utils/result.dart';

class TodoFormViewModel extends ChangeNotifier {
  TodoFormViewModel({required CreateTodoUseCase createTodoUseCase})
      : _createTodoUseCase = createTodoUseCase {
    handleSubmit = Command1<TodoItem, int?>(_handleSubmit);
  }

  void initControllers() {
    titleController.addListener(_onInputChanged);
    descriptionController.addListener(_onInputChanged);
  }

  void clearControllers() {
    handleSubmit.clearResult();
    clearTextControllers();
    titleController.removeListener(_onInputChanged);
    descriptionController.removeListener(_onInputChanged);
  }

  final CreateTodoUseCase _createTodoUseCase;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _log = Logger('CreateTodoViewModel');

  late final Command1<TodoItem, int?> handleSubmit;

  final ValueNotifier<bool> isValid = ValueNotifier(false);

  bool get isDisableFields => handleSubmit.running;

  Future<Result<TodoItem>> _handleSubmit(int? id) async {
    final title = titleController.text;
    final description = descriptionController.text;

    if (id == null) {
      return await _createTodo(
        title: title,
        description: description,
      );
    } else {
      return const Result.ok(
        TodoItem(
          description: '',
          title: '',
          isCompleted: false,
        ),
      );
    }
  }

  Future<Result<TodoItem>> _createTodo({
    required String title,
    required String description,
  }) async {
    try {
      final result = await _createTodoUseCase(
        title: title,
        description: description,
      );

      switch (result) {
        case Ok<TodoItem>():
          _log.fine('Created Todo');
          EventBus.instance.emit(CreatedTodoEvent(value: result.value));
          return Result.ok(result.value);
        case Error<TodoItem>():
          _log.warning('Failed to create Todo');
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  void clearTextControllers() {
    titleController.clear();
    descriptionController.clear();
  }

  void disposeControllers() {
    titleController.dispose();
    descriptionController.dispose();
  }

  void _onInputChanged() {
    final formValid = _validateInputs();

    isValid.value = formValid;
  }

  bool _validateInputs() {
    return titleController.value.text.isNotEmpty &&
        descriptionController.value.text.isNotEmpty;
  }

  String? titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  String? descriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a note';
    }
    return null;
  }
}
