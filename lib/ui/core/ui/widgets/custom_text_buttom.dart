import 'package:flutter/material.dart';
import 'package:task_manager/ui/core/themes/colors.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.onPressed,
      this.icon,
      required this.label,
      this.isLoading = false,
      this.isDisable = false,
      this.backgroundColor});
  final VoidCallback onPressed;
  final Widget? icon;
  final Widget label;
  final bool isLoading;
  final bool isDisable;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.blue.withOpacity(0.10),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: !isDisable || isLoading ? onPressed : null,
      icon: icon,
      label: isLoading
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : label,
    );
  }
}
