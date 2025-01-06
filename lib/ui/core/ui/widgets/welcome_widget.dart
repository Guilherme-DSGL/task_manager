import 'package:flutter/material.dart';

import '../../themes/colors.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({
    super.key,
    required this.userName,
    required this.taskCount,
  });

  final String userName;
  final int taskCount;
  @override
  Widget build(BuildContext context) {
    final titleFont = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: "Welcome, ",
            style: titleFont,
            children: [
              TextSpan(
                text: userName,
                style: titleFont?.copyWith(
                  color: AppColors.blue,
                ),
              ),
              const TextSpan(text: "."),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "You've got $taskCount tasks to do",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16,
              ),
        )
      ],
    );
  }
}
