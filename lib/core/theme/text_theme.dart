import 'package:flutter/material.dart';

class AppTextTheme {
  static TextTheme get textTheme {
    return TextTheme(
      // H1 - Display Large
      displayLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.4, // 56/40
        letterSpacing: -1,
      ),
      // H2 - Display Medium
      displayMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.375, // 44/32
        letterSpacing: -0.8,
      ),
      // H3 - Display Small
      displaySmall: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.385, // 36/26
        letterSpacing: -0.65,
      ),
      // H4 - Headline Large
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.455, // 32/22
        letterSpacing: -0.55,
      ),
      // H5 - Headline Medium
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4, // 28/20
        letterSpacing: -0.5,
      ),
      // H6 - Headline Small
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.444, // 26/18
        letterSpacing: -0.45,
      ),
      // B1 - Body Large
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5, // 24/16
        letterSpacing: -0.4,
      ),
      // B2 - Body Medium
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.571, // 22/14
        letterSpacing: -0.35,
      ),
      // B3 - Body Small
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.538, // 20/13
        letterSpacing: -0.325,
      ),
      // L1 - Label Large
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.25, // 20/16
        letterSpacing: -0.32,
      ),
      // L2 - Label Medium
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.286, // 18/14
        letterSpacing: -0.28,
      ),
      // C1 - Label Small
      labelSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.385, // 18/13
        letterSpacing: -0.32,
      ),
    );
  }
}
