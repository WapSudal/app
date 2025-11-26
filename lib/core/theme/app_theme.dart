import 'color_scheme.dart';
import 'text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Pretendard',
      textTheme: AppTextTheme.textTheme,
      colorScheme: AppColorScheme.lightColorScheme,
    );
  }
}
