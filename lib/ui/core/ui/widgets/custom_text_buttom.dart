import 'package:flutter/material.dart';
import 'package:task_manager/ui/core/themes/colors.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.label,
  });
  final VoidCallback onPressed;
  final Widget? icon;
  final Widget label;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue.withOpacity(0.10),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      icon: icon,
      label: label,
    );
  }
}
