import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/ui/core/themes/colors.dart';
import 'package:task_manager/ui/core/themes/sizes.dart';
import 'package:task_manager/ui/core/ui/widgets/custom_text_buttom.dart';
import 'package:task_manager/ui/todo_form/view_models/todo_form_view_model.dart';

import '../../core/ui/widgets/custom_input.dart';

class TodoFormScreen extends StatefulWidget {
  const TodoFormScreen({
    super.key,
    required TodoFormViewModel createTodoViewModel,
  }) : _createTodoViewModel = createTodoViewModel;

  final TodoFormViewModel _createTodoViewModel;
  @override
  State<TodoFormScreen> createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  @override
  void initState() {
    super.initState();
    widget._createTodoViewModel.init();
  }

  @override
  void dispose() {
    super.dispose();
    widget._createTodoViewModel.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingHorizontal,
          vertical: AppSizes.paddingVertical,
        ),
        child: Form(
            key: widget._createTodoViewModel.formKey,
            child: Column(
              children: [
                ListenableBuilder(
                  listenable: Listenable.merge([
                    widget._createTodoViewModel.isValid,
                    widget._createTodoViewModel.handleSubmit,
                  ]),
                  builder: (context, _) {
                    return CustomInput(
                      readOnly: widget._createTodoViewModel.isDisableFields,
                      controller: widget._createTodoViewModel.titleController,
                      validator: widget._createTodoViewModel.titleValidator,
                      prefixIcon: Transform.scale(
                        scale: 1.3,
                        child: const Checkbox(
                          value: false,
                          onChanged: null,
                        ),
                      ),
                      hintText: 'What\'s in your mind',
                    );
                  },
                ),
                const SizedBox(height: 20),
                ListenableBuilder(
                  listenable: Listenable.merge([
                    widget._createTodoViewModel.isValid,
                    widget._createTodoViewModel.handleSubmit,
                  ]),
                  builder: (context, _) {
                    return CustomInput(
                      readOnly: widget._createTodoViewModel.isDisableFields,
                      controller:
                          widget._createTodoViewModel.descriptionController,
                      validator:
                          widget._createTodoViewModel.descriptionValidator,
                      prefixIcon: const Icon(
                        Icons.edit,
                        color: AppColors.mutedAzure,
                      ),
                      minLines: 1,
                      maxLines: 4,
                      hintText: 'Add a note',
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListenableBuilder(
                      listenable: Listenable.merge([
                        widget._createTodoViewModel.isValid,
                        widget._createTodoViewModel.handleSubmit,
                      ]),
                      builder: (context, _) {
                        if (widget._createTodoViewModel.handleSubmit.error) {
                          widget._createTodoViewModel.handleSubmit
                              .clearResult();
                          AsukaSnackbar.warning(
                                  "An error occurred creating the to do")
                              .show();
                        }
                        if (widget
                            ._createTodoViewModel.handleSubmit.completed) {
                          context.pop();
                        }
                        return CustomTextButton(
                          isDisable: !widget._createTodoViewModel.isValid.value,
                          isLoading:
                              widget._createTodoViewModel.handleSubmit.running,
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            widget._createTodoViewModel.handleSubmit
                                .execute(null);
                          },
                          backgroundColor: Colors.transparent,
                          label: const Text("Create"),
                        );
                      },
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
