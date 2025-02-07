import 'package:flutter/material.dart';
import 'package:task_manager/config/assets.dart';
import 'package:task_manager/ui/core/ui/widgets/custom_text_buttom.dart';

import '../../core/themes/colors.dart';

class TodoNoTasks extends StatelessWidget {
  final VoidCallback? onCreateTaksPressed;

  final String title;
  const TodoNoTasks({
    super.key,
    this.onCreateTaksPressed,
    this.title = 'You have no task listed',
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
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          if (onCreateTaksPressed != null)
            SizedBox(
              height: 50,
              child: CustomTextButton(
                onPressed: onCreateTaksPressed!,
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
