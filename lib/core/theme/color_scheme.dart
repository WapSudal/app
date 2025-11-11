import 'package:flutter/material.dart';

class AppColorScheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF1E90FF);
  static const Color success = Color(0xFF71CE6E);
  static const Color information = Color(0xFF1E90FF);
  static const Color warning = Color(0xFFF7DB34);
  static const Color danger = Color(0xFFFF4130);

  // White/Light Colors
  static const Color white100 = Color(0xFFFFFFFF);
  static const Color white200 = Color(0xFFF8F9FB);
  static const Color white300 = Color(0xFFEDEFF4);
  static const Color white400 = Color(0xFFE6E9F0);
  static const Color white500 = Color(0xFFDADEE9);

  // Grey Colors
  static const Color grey100 = Color(0xFF464646);
  static const Color grey200 = Color(0xFF5B5B5B);
  static const Color grey300 = Color(0xFF797979);
  static const Color grey400 = Color(0xFF989898);
  static const Color grey500 = Color(0xFFBEBEBE);

  // Black/Dark Colors
  static const Color black100 = Color(0xFF000000);
  static const Color black200 = Color(0xFF111111);
  static const Color black300 = Color(0xFF1E1E1E);
  static const Color black400 = Color(0xFF3C3C3C);
  static const Color black500 = Color(0xFF4D4D4D);

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColorScheme.primaryColor,
    onPrimary: AppColorScheme.white100,
    secondary: AppColorScheme.grey400,
    onSecondary: AppColorScheme.white100,
    error: AppColorScheme.danger,
    onError: AppColorScheme.white100,
    surface: AppColorScheme.white100,
    onSurface: AppColorScheme.black100,
    surfaceContainerHighest: AppColorScheme.white300,
    outline: AppColorScheme.grey500,
    shadow: AppColorScheme.black400,
  );
}
