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
    builder: builder,
  );
  return result;
}
