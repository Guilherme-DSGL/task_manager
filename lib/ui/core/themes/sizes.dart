import 'package:flutter/material.dart';

abstract final class AppSizes {
  const AppSizes._();

  static const paddingHorizontal = 20.0;

  static const paddingVertical = 20.0;

  double get paddingScreenHorizontal => AppSizes.paddingHorizontal;

  double get paddingScreenVertical => AppSizes.paddingVertical;

  double get profilePictureSize => 64.0;
  EdgeInsets get edgeInsetsScreenHorizontal =>
      EdgeInsets.symmetric(horizontal: paddingScreenHorizontal);

  EdgeInsets get edgeInsetsScreenSymmetric => EdgeInsets.symmetric(
      horizontal: paddingScreenHorizontal, vertical: paddingScreenVertical);
}
