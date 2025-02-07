import 'package:flutter/material.dart';
import 'package:task_manager/ui/core/themes/colors.dart';

import 'custom_checkbox.dart';
import 'custom_icon_button.dart';

class TodoWidget extends StatefulWidget {
  const TodoWidget({
    super.key,
    required this.title,
    required this.description,
    required this.isCompleted,
    this.isDeleteButtonVisible = false,
    this.onCheckChanged,
    this.onDeletePressed,
  });

  final String title;
  final String description;
  final bool isCompleted;
  final bool isDeleteButtonVisible;
  final Future<void> Function(bool?)? onCheckChanged;
  final Future<void> Function()? onDeletePressed;

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  bool isDescriptionVisible = false;

  void _toggleDescription() {
    setState(() {
      isDescriptionVisible = !isDescriptionVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: !widget.isDeleteButtonVisible,
            child: CustomCheckbox(
              checkColor:
                  widget.isDeleteButtonVisible ? AppColors.mutedAzure : null,
              value: widget.isCompleted,
              onChanged: widget.onCheckChanged?.call,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.isDeleteButtonVisible
                            ? AppColors.mutedAzure
                            : null,
                      ),
                ),
                const SizedBox(height: 5),
                Visibility(
                  visible:
                      isDescriptionVisible && !widget.isDeleteButtonVisible,
                  child: Text(
                    widget.description,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 7,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: widget.isDeleteButtonVisible,
            replacement: IconButton(
              onPressed: _toggleDescription,
              icon: const Icon(
                Icons.more_horiz,
                color: AppColors.mutedAzure,
                size: 32,
              ),
            ),
            child: LoadingIconButton(
              onPressed: widget.onDeletePressed,
              color: AppColors.fireRed,
              icon: Icons.delete,
            ),
          ),
        ],
      ),
    );
  }
}
