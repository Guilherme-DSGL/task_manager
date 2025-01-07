import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    this.hintText = '',
    this.controller,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.validator,
    this.readOnly = false,
  });
  final String hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (prefixIcon != null)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SizedBox(
              height: 24,
              width: 24,
              child: prefixIcon,
            ),
          ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            readOnly: readOnly,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
            ),
            minLines: minLines,
            maxLines: maxLines,
            validator: validator,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
