import 'package:flutter/material.dart';
import 'package:task_manager/ui/core/themes/colors.dart';
import 'package:task_manager/ui/core/ui/widgets/custom_text_buttom.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48.0,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomTextButton(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text("Try again"),
            backgroundColor: AppColors.fireRed.withOpacity(0.10),
          ),
        ],
      ),
    );
  }
}
