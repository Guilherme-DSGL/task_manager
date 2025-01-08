import 'package:flutter/material.dart';

class LoadingIconButton extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final IconData? icon;
  final double size;
  final Color? color;

  const LoadingIconButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.color,
    this.size = 24.0,
  });

  @override
  _LoadingIconButtonState createState() => _LoadingIconButtonState();
}

class _LoadingIconButtonState extends State<LoadingIconButton> {
  bool _isLoading = false;

  Future<void> _handleOnPressed() async {
    setState(() {
      _isLoading = true;
    });

    await widget.onPressed?.call();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _isLoading ? null : _handleOnPressed,
      icon: Visibility(
        visible: !_isLoading,
        replacement: const Center(
          child: SizedBox(
            height: 12,
            width: 12,
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 2,
            ),
          ),
        ),
        child: Icon(
          widget.icon,
          color: widget.color,
          size: widget.size,
        ),
      ),
    );
  }
}
