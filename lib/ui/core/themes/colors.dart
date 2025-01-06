import 'package:flutter/material.dart';

abstract final class AppColors {
  static const black1 = Color(0xFF101010);
  static const white1 = Color(0xFFFFF7FA);

  static const whiteTransparent = Color(0x4DFFFFFF);
  static const blackTransparent = Color(0x4D000000);

  static const blue = Color(0xFF007FFF);
  static const slateBlue = Color(0xFF8D9CB8);
  static const slatePurple = Color(0xFF3F3D56);
  static const fireRed = Color(0xFFFF5E5E);
  static const mutedAzure = Color(0xFFC6CFDC);
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.blue,
    onPrimary: AppColors.white1,
    secondary: AppColors.black1,
    onSecondary: AppColors.white1,
    surface: Colors.white,
    onSurface: AppColors.black1,
    error: Colors.white,
    onError: fireRed,
  );
}
