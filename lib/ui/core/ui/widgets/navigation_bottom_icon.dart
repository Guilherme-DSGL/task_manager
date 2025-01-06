import 'package:flutter/material.dart';

import '../../themes/colors.dart';

class NavigationBottomIcon extends StatelessWidget {
  const NavigationBottomIcon(
    this.iconData, {
    super.key,
    this.useRoundedShape = false,
  });

  final bool useRoundedShape;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: useRoundedShape
            ? BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                border: Border.all(
                  width: 2,
                  color: iconTheme.color ?? AppColors.slateBlue,
                ),
              )
            : null,
        child: Container(
          margin: useRoundedShape ? const EdgeInsets.all(2.0) : null,
          child: Icon(
            iconData,
            size: useRoundedShape ? 18 : 24,
          ),
        ),
      ),
    );
  }
}
