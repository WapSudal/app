import 'package:stroke_spoiler/core/theme/color_scheme.dart';
import 'package:stroke_spoiler/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Pretendard',
      textTheme: AppTextTheme.textTheme,
      colorScheme: AppColorScheme.lightColorScheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      dropdownMenuTheme: _dropdownMenuTheme,
      checkboxTheme: _checkboxTheme,
    );
  }

  // Button Themes
  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorScheme.primaryColor,
          foregroundColor: AppColorScheme.white100,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.32,
          ),
        ),
      );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorScheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: AppColorScheme.primaryColor, width: 1),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.32,
          ),
        ),
      );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColorScheme.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.32,
      ),
    ),
  );

  // Input Decoration Theme
  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        fillColor: AppColorScheme.white100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColorScheme.grey500, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColorScheme.grey500, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColorScheme.primaryColor,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColorScheme.danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColorScheme.danger, width: 1),
        ),
        hintStyle: const TextStyle(
          color: AppColorScheme.grey400,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.4,
        ),
        labelStyle: const TextStyle(
          color: AppColorScheme.grey300,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.35,
        ),
      );

  // Dropdown Menu Theme
  static final DropdownMenuThemeData _dropdownMenuTheme = DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorScheme.white100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColorScheme.primaryColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColorScheme.primaryColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColorScheme.primaryColor,
          width: 1,
        ),
      ),
    ),
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(AppColorScheme.white100),
      elevation: WidgetStateProperty.all(4),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  // Checkbox Theme
  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColorScheme.primaryColor;
      }
      return AppColorScheme.white100;
    }),
    checkColor: WidgetStateProperty.all(AppColorScheme.white100),
    side: const BorderSide(color: AppColorScheme.grey500, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );
}
