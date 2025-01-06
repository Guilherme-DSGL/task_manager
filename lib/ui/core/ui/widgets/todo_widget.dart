import 'package:flutter/material.dart';
import 'package:task_manager/ui/core/themes/colors.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({
    super.key,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.showDescription,
  });

  final String title;
  final String description;
  final bool isCompleted;

  final bool showDescription;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 1.3,
            child: Checkbox(
              value: false,
              onChanged: (value) {},
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 7,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              color: AppColors.mutedAzure,
              size: 32,
            ),
          )
        ],
      ),
    );
  }
}
