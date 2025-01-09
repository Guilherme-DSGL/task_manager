import 'package:flutter/material.dart';

Future<T?> showCustomModalBottomSheet<T>(BuildContext context,
    {required Widget Function(BuildContext) builder}) {
  final result = showModalBottomSheet<T>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Builder(
            builder: builder,
          ),
        );
      });
  return result;
}
