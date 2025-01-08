import 'package:flutter/material.dart';
import 'package:task_manager/config/assets.dart';
import 'package:task_manager/ui/core/ui/widgets/custom_text_buttom.dart';

import '../../core/themes/colors.dart';

class TodoNoTasks extends StatelessWidget {
  final VoidCallback onPressed;
  const TodoNoTasks({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Assets.notFoundTasks,
            height: 80,
            width: 80,
          ),
          const SizedBox(height: 16),
          Text(
            "You have no task listed",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: CustomTextButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.add,
                color: AppColors.blue,
              ),
              label: Text(
                "Create task",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.blue,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
