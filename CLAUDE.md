# CLAUDE.md - AI Assistant Guide for Stroke Spoiler

## Project Overview

**Project Name:** Stroke Spoiler
**Package Name:** `stroke_spoiler`
**Type:** Flutter Mobile Application
**Flutter SDK:** >=3.9.2
**Language:** Dart
**Status:** Early Development Stage

This is a Flutter application in active development, currently featuring a basic countdown interface with Korean text ("당신은 곧 죽습니다" - "You will soon die").

## Repository Structure

```
/home/user/app/
├── lib/                        # Main application source code
│   ├── main.dart              # Application entry point
│   └── core/                  # Core functionality
│       └── theme/             # Theme configuration
│           ├── app_theme.dart       # Main theme configuration
│           ├── color_scheme.dart    # Color definitions
│           └── text_theme.dart      # Typography definitions
├── test/                      # Test files
│   └── widget_test.dart      # Widget tests
├── assets/                    # Static assets
│   └── fonts/                # Pretendard font family (9 weights)
├── android/                   # Android platform files
├── ios/                       # iOS platform files
├── web/                       # Web platform files
├── .github/                   # GitHub configuration
│   └── workflows/
│       └── ci.yml            # CI/CD pipeline
├── pubspec.yaml              # Dependencies and project config
├── analysis_options.yaml     # Dart analyzer configuration
└── .gitignore               # Git ignore rules
```

## Key Technologies & Dependencies

### Production Dependencies
- **flutter_riverpod** (^2.6.1) - State management solution
- **riverpod_annotation** (^2.6.1) - Code generation for Riverpod
- **freezed_annotation** (^3.1.0) - Immutable classes and unions
- **json_annotation** (^4.9.0) - JSON serialization
- **cupertino_icons** (^1.0.8) - iOS-style icons

### Development Dependencies
- **build_runner** (^2.10.2) - Code generation runner
- **freezed** (^3.2.3) - Code generator for data classes
- **json_serializable** (^6.11.1) - JSON serialization code generation
- **flutter_lints** (^6.0.0) - Recommended linting rules
- **custom_lint** (^0.8.1) - Custom lint rules

## Design System

### Typography
**Font Family:** Pretendard (Korean optimized)
- 9 weights available: 100 (Thin) to 900 (Black)
- Custom text theme with 10 predefined styles
- Negative letter spacing for tighter text rendering

**Text Styles Reference:**
- `displayLarge` - H1 (40px, w700)
- `displayMedium` - H2 (32px, w700)
- `displaySmall` - H3 (26px, w600)
- `headlineLarge` - H4 (22px, w600)
- `headlineMedium` - H5 (20px, w600)
- `headlineSmall` - H6 (18px, w600)
- `bodyLarge` - B1 (16px, w400)
- `bodyMedium` - B2 (14px, w400)
- `bodySmall` - B3 (13px, w500)
- `labelLarge` - L1 (16px, w500)
- `labelMedium` - L2 (14px, w500)
- `labelSmall` - C1 (13px, w400)

### Color Palette

**Primary Colors:**
- Primary: `#1E90FF` (Dodger Blue)
- Success: `#71CE6E`
- Information: `#1E90FF`
- Warning: `#F7DB34`
- Danger: `#FF4130`

**Neutral Colors:**
- White scale: `white100` to `white500` (FFFFFF → DADEE9)
- Grey scale: `grey100` to `grey500` (464646 → BEBEBE)
- Black scale: `black100` to `black500` (000000 → 4D4D4D)

**Component Themes:**
- Material 3 enabled (`useMaterial3: true`)
- 8px border radius for buttons and inputs
- No elevation on elevated buttons
- Consistent padding: 20px horizontal, 12px vertical for buttons

## Development Workflows

### Code Generation

The project uses code generation extensively. Run this command after modifying annotated files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous development with watch mode:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

**Build Filter (CI Optimization):**
```bash
dart run build_runner build --delete-conflicting-outputs --build-filter="lib/**"
```

### Dependencies Management

**Install dependencies:**
```bash
flutter pub get
```

**Update dependencies:**
```bash
flutter pub upgrade
```

**Check outdated packages:**
```bash
flutter pub outdated
```

### Code Quality

**Run analyzer:**
```bash
flutter analyze
```

**Run tests:**
```bash
flutter test
```

**Format code:**
```bash
dart format .
```

### Building the App

**Android APK (Release):**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS (requires macOS):**
```bash
flutter build ios --release
```

## CI/CD Pipeline

### GitHub Actions Workflow
**File:** `.github/workflows/ci.yml`

**Triggers:**
- Push to `main` branch
- Pull requests to `main` branch

**Jobs:**
1. **remove-old-artifacts** - Cleans up old artifacts (keeps 12 most recent)
2. **build_android_release** - Builds Android APK
   - Uses Java 17 (Temurin distribution)
   - Caches Gradle and Dart tool directories
   - Runs code generation before build
   - Optimized with parallel Gradle execution
3. **build_summary** - Posts build results summary

**Build Optimizations:**
- Gradle caching for faster builds
- Dart tool caching for build_runner outputs
- Parallel Gradle execution (max 4 workers)
- In-process Kotlin compilation

**Artifacts:**
- Android APK available for download after successful builds
- Retention period: Based on artifact cleanup policy (1 hour age, skip 12 recent)

## Git Conventions

### Branch Strategy
**Current Branch:** `claude/claude-md-mi1coeu74ihmapd0-011E876QYny3eZMJ9fsfZkQP`

**Branch Naming:**
- Feature branches: `claude/feature-<description>-<session-id>`
- All Claude branches MUST start with `claude/` prefix
- Session ID must match at the end for push authorization

### Commit Guidelines
- Clear, descriptive commit messages
- Use conventional commit format when possible:
  - `feat:` - New features
  - `fix:` - Bug fixes
  - `docs:` - Documentation changes
  - `style:` - Code style changes
  - `refactor:` - Code refactoring
  - `test:` - Test additions/changes
  - `chore:` - Build process or tooling changes

### Recent Commits
```
e149c9c - chore: CI 워크플로우 작성
d3512de - chore: setup project font, theme, package name
eb5d0db - Initialize Project
cb48739 - Initial commit
```

## AI Assistant Guidelines

### File Operations

1. **Read Before Edit/Write**
   - ALWAYS read a file before editing or writing to it
   - Understand the existing code structure and patterns

2. **Prefer Editing Over Creating**
   - Always prefer editing existing files to creating new ones
   - Only create new files when absolutely necessary

3. **Code Generation Awareness**
   - After modifying files with Freezed or JSON annotations, remind to run build_runner
   - Files with `.g.dart` or `.freezed.dart` suffixes are generated - don't edit them directly

### Code Style Standards

1. **Dart Conventions**
   - Follow `flutter_lints` rules
   - Use const constructors where possible
   - Prefer final over var for immutable variables
   - Use trailing commas for better formatting

2. **File Organization**
   - Group imports: dart SDK, flutter, packages, relative imports
   - One class per file (with exceptions for private helper classes)
   - Name files using snake_case

3. **Theme Usage**
   - Use `AppTheme.lightTheme` instead of creating custom ThemeData
   - Reference colors from `AppColorScheme` class
   - Use predefined text styles from `Theme.of(context).textTheme`

4. **State Management**
   - Use Riverpod for state management
   - Prefer `riverpod_annotation` for code generation
   - Follow provider naming convention: `*Provider`

### Common Patterns

**Creating a Themed Widget:**
```dart
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Sample Text',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
```

**Using Riverpod Provider:**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  int build() => 0;

  void increment() => state++;
}
```

**Creating Freezed Data Class:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

### Testing Guidelines

1. **Widget Tests**
   - Test widgets in isolation
   - Use `flutter_test` package
   - Mock dependencies using Riverpod's override functionality

2. **Test File Location**
   - Mirror the lib/ structure in test/
   - Name test files: `*_test.dart`

### Important Notes

1. **Font Assets**
   - Pretendard font is fully configured with 9 weights
   - Don't add alternative fonts without discussion
   - Font files are in `assets/fonts/`

2. **Platform Support**
   - Primarily targeting Android (APK builds in CI)
   - iOS/Web configurations present but not actively built in CI
   - Consider cross-platform implications when adding features

3. **Build Generation**
   - Generated files (.g.dart, .freezed.dart) are gitignored
   - Always run code generation before committing changes
   - CI pipeline runs code generation automatically

4. **Performance Considerations**
   - Use const constructors to reduce rebuilds
   - Leverage Riverpod's fine-grained reactivity
   - Avoid expensive operations in build methods

### Debugging Tips

**Common Issues:**

1. **Build errors after adding Freezed/JSON models:**
   - Solution: Run `dart run build_runner build --delete-conflicting-outputs`

2. **Theme not applying:**
   - Verify AppTheme is set in MaterialApp
   - Check that you're using Theme.of(context) to access theme

3. **Font not displaying:**
   - Confirm font files exist in assets/fonts/
   - Verify pubspec.yaml has correct font declarations
   - Run `flutter clean` and `flutter pub get`

## Quick Reference Commands

```bash
# Setup
flutter pub get

# Development
dart run build_runner watch --delete-conflicting-outputs
flutter run

# Code Quality
flutter analyze
dart format .
flutter test

# Build
flutter build apk --release
flutter build appbundle --release

# Clean
flutter clean
```

## Contact & Resources

- **Repository:** Git repository (check remote for URL)
- **Issue Tracker:** GitHub Issues
- **Documentation:** [Flutter Docs](https://docs.flutter.dev/)
- **Riverpod Docs:** [riverpod.dev](https://riverpod.dev/)
- **Freezed Docs:** [pub.dev/packages/freezed](https://pub.dev/packages/freezed)

---

**Last Updated:** 2025-11-16
**Document Version:** 1.0.0
**For AI Assistant Use:** This document is specifically designed to help AI assistants understand the codebase structure, development workflows, and conventions. Always refer to this document before making significant changes to the project.
