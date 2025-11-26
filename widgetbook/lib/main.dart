import 'package:flutter/material.dart';
import 'package:stroke_spoiler/core/theme/app_theme.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      themeMode: ThemeMode.light,
      directories: directories,
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: AppTheme.lightTheme),
            // WidgetbookTheme(
            //   name: 'Dark',
            //   data: AppTheme.da, // 다크 모드 테마
            // ),
          ],
          initialTheme: WidgetbookTheme(
            name: 'Light',
            data: AppTheme.lightTheme,
          ),
        ),
      ],
      appBuilder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: child,
        ),
      ),
    );
  }
}
