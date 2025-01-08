import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.checkColor,
  });

  final bool value;
  final Color? checkColor;

  final Future<void> Function(bool?)? onChanged;

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(
          scale: 1.3,
          child: Checkbox(
            checkColor: widget.checkColor,
            value: loading ? false : widget.value,
            onChanged: loading
                ? null
                : (value) async {
                    setState(() {
                      loading = true;
                    });
                    await widget.onChanged?.call(value);
                    setState(() {
                      loading = false;
                    });
                  },
          ),
        ),
        if (loading)
          const Positioned(
            width: 8,
            height: 8,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
      ],
    );
  }
}
