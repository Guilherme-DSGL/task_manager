import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/themes/colors.dart';

class CustomSearchField extends StatefulWidget {
  final Function(String) onSearch;
  final String hintText;
  final TextEditingController controller;
  final bool enabled;

  const CustomSearchField({
    super.key,
    required this.onSearch,
    this.hintText = 'Search...',
    required this.controller,
    required this.enabled,
  });

  @override
  _CustomSearchFieldState createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enabled,
      controller: widget.controller,
      onChanged: _onTextChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.blue,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            widget.controller.clear();
            widget.onSearch('');
          },
          icon: const Icon(
            Icons.cancel,
            color: AppColors.mutedAzure,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            width: 2.5,
            color: AppColors.blue.withOpacity(0.5),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.blue,
          ),
        ),
        hintText: widget.hintText,
      ),
    );
  }
}
