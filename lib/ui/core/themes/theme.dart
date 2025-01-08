import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

abstract final class AppTheme {
  static final _textTheme = GoogleFonts.urbanistTextTheme(
    const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.slatePurple,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: AppColors.slatePurple,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.slatePurple,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.slatePurple,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.slatePurple,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.slateBlue,
      ),
      labelMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.slatePurple,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.slateBlue,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.slateBlue,
      ),
    ),
  );

  static const _inputDecorationTheme = InputDecorationTheme(
    hintStyle: TextStyle(
      color: AppColors.mutedAzure,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    ),
    errorStyle: TextStyle(
      color: AppColors.fireRed,
    ),
    border: InputBorder.none,
    filled: false,
  );

  static const _checkBoxTheme = CheckboxThemeData(
    side: BorderSide(
      color: AppColors.mutedAzure,
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
  );

  static const _snackBarTheme = SnackBarThemeData(
    insetPadding: EdgeInsets.only(
      bottom: 80,
      left: 16,
      right: 16,
    ),
  );
  static const _bottomNavigationBarTheme = BottomNavigationBarThemeData(
    unselectedItemColor: AppColors.mutedAzure,
    selectedItemColor: AppColors.blue,
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecorationTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    checkboxTheme: _checkBoxTheme,
    snackBarTheme: _snackBarTheme,
  );
}
