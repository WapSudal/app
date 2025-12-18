# AGENTS.md

This file provides guidance to AI Agents when working with code in this repository.

IMPORTANT! NOTE: This project is currently being set up, and the content described below may not have been fully implemented. This is due to the fact that the content below is from another completed project. Please proceed as if you are aiming for the structure below.

## Project Overview
Stroke Spoiler - Prototype Mobile/Web cross-platform app for stroke prevention management.

## Project Documentation
Reference documents are available in the `docs/` directory:

### Design Documents
- **`docs/StrokeSpoiler_Software_Requirement_Specification.pdf`**: Complete software requirements specification
- **`docs/StrokeSpoiler_System_Modeling_and_Design.pdf`**: System architecture, modeling, and design documentation

### Development Guidelines
- **`docs/RIVERPOD_V3_BEST_PRACTICES.md`**: Comprehensive Riverpod v3 state management guidelines
- **`docs/RIVERPOD_V3_BEST_PRACTICES_ko.md`**: Korean version of Riverpod v3 best practices
- **`docs/RIVERPOD_V3_MUTATIONS.md`**: Guidelines for using Riverpod v3 Mutations
- **`docs/ROLE_BASED_ACCESS_CONTROL.md`**: Role-based access control implementation guide

**Note**: Always reference these documents when working on features related to requirements, system design, or state management patterns.

## Development Commands

```bash
# Setup
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Development (watch mode recommended)
dart run build_runner watch --delete-conflicting-outputs
flutter run

# Testing & Analysis
flutter analyze
flutter test
dart run custom_lint

# Troubleshooting
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs
```

## Architecture

### Clean Architecture Structure
The project strictly follows Clean Architecture with MVVM pattern:

```
lib/
├── core/                       # Common features and utilities
│   ├── data/
│   │   ├── models/             # Common data models (ApiResponseModel, etc.)
│   │   └── repositories/       # Common repository implementations
│   ├── domain/
│   │   └── repositories/       # Common repository interfaces
│   ├── presentation/
│   │   └── widgets/            # Reusable widgets
│   ├── router/                 # Router configuration
│   │   └── router_provider.dart
│   ├── network/                # API client and network configuration
│   │   └── api_client_provider.dart
│   ├── storage/                # Local storage
│   │   └── storage_provider.dart
│   ├── enums/                  # Global enums (UserRole, FarmType, etc.)
│   ├── exceptions/             # Custom exception classes
│   ├── theme/                  # App theme configuration
│   └── utils/                  # Utility functions (JWT, Converters, etc.)
│
└── features/                   # Feature-First structure
    └── [feature_name]/         # Each feature module
        ├── data/
        │   ├── datasources/    # Remote/local data sources
        │   ├── models/         # API models (JSON serialization)
        │   ├── repositories/   # Repository implementations
        │   └── providers/      # Data layer providers
        ├── domain/
        │   ├── entities/       # Domain entities
        │   ├── repositories/   # Repository interfaces
        │   ├── usecases/       # Business logic UseCases
        │   └── providers/      # UseCase providers
        └── presentation/
            ├── views/          # UI screens (Widgets)
            ├── providers/      # State management providers
            └── widgets/        # Feature-specific reusable widgets
```

### Layer Responsibilities

#### Data Layer
- **datasources**: API calls and local storage access
- **models**: Models for JSON serialization/deserialization (`@JsonSerializable`)
- **repositories**: Repository interface implementations
- Naming: `*Model` (e.g., `UserModel`, `AuthModel`)

#### Domain Layer  
- **entities**: Business domain entities (`@freezed`)
- **repositories**: Repository interfaces (abstract classes)
- **usecases**: Single responsibility business logic
- Naming: `*Entity` (e.g., `UserEntity`), `*UseCase` (e.g., `LoginUseCase`)

#### Presentation Layer
- **views**: UI screens (`ConsumerWidget` or `ConsumerStatefulWidget`)
- **widgets**: Feature-specific reusable widgets
- **providers**: Riverpod notifier providers (`@riverpod`) and state classes (`@freezed`)
- Naming: `*View` (e.g., `LoginView`), `*State`, `*Notifier`

## Core Coding Rules

### 1. Import Rules
- **Always use relative paths** for internal project imports (no package paths)
- Use package paths only for external dependencies
  ```dart
  // ✅ Correct
  import '../domain/entities/auth_entity.dart';
  import 'package:flutter/material.dart';  // External only
  ```

### 2. Freezed Usage Rules
- **Must define as abstract class**
  ```dart
  @freezed
  abstract class UserEntity with _$UserEntity {
    const factory UserEntity({...}) = _UserEntity;
  }
  ```

- **ALWAYS import Freezed classes before using methods** (`.when`, `.whenOrNull`, `.map`)
  - Extension methods are generated in `*.freezed.dart` and require the class import
  - Missing imports cause "method not found" errors

### 3. Code Generation Files
- `*.g.dart` (json_serializable) and `*.freezed.dart` files are auto-generated
- Excluded from version control (included in `.gitignore`)
- Must run `dart run build_runner build` after adding new models/providers

### 4. Riverpod Providers
- Use code generation (`@riverpod` annotation) with `part` directive
  ```dart
  import 'package:riverpod_annotation/riverpod_annotation.dart';
  part 'provider_name.g.dart';

  @riverpod
  class ExampleNotifier extends _$ExampleNotifier {
    @override
    ExampleState build() => const ExampleState();
  }
  ```

### 5. API Client
- Base URL: `https://cat-informed-newt.ngrok-free.app`
- All API calls go through `ApiClient`
- Automatic JWT Bearer token authentication
- Auto token refresh on 401 errors

### 6. State Management Pattern (Riverpod v3)
- **AsyncNotifier**: For async operations (API calls)
- **Notifier**: For synchronous state only
- **Mutation**: For one-off UI operations (form submissions)
- State classes must be immutable (`@freezed`)
- **See [docs/RIVERPOD_V3_BEST_PRACTICES.md](docs/RIVERPOD_V3_BEST_PRACTICES.md) for detailed patterns**

### 7. Repository Design Pattern
- Use individual parameters in method signatures, NOT Entity objects
  ```dart
  // ✅ Correct
  Future<void> requestFarmMapping({required List<int> farmIds});
  ```

### 8. Model Extension Pattern
- Define `toEntity()` as extensions at bottom of file, NOT as class methods
  ```dart
  // Model definition (keep pure)
  @freezed
  abstract class UserModel with _$UserModel {
    const factory UserModel({...}) = _UserModel;
    factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  }

  // Extension at bottom
  extension UserModelX on UserModel {
    UserEntity toEntity() => UserEntity(...);
  }
  ```

### 9. Routing
- Use GoRouter (`core/router/router_provider.dart`)
- Use absolute paths (`/login`, `/mypage`, etc.)
- Automatic redirect based on authentication state

### 10. PagedEntity Usage Pattern
- Use `PagedEntity(items: ..., pagination: ...)`
  ```dart
  return PagedEntity(
    items: response.data!.map((m) => m.toEntity()).toList(),
    pagination: response.paging.toEntity(),
  );
  ```

### 11. Provider Layer Separation
- **Data Layer**: DataSource and Repository providers only
- **Domain Layer**: UseCase providers only
- NEVER mix UseCase providers in Data layer

### 12. Color Opacity Usage
- Use `withValues(alpha:)` NOT `withOpacity()` (deprecated)
  ```dart
  color: Colors.blue.withValues(alpha: 0.7)
  ```

### 13. RadioGroup Usage (Flutter 3.32+)
- Wrap `RadioListTile` with `RadioGroup` and manage state at parent level
- Individual `RadioListTile`'s `groupValue`/`onChanged` are deprecated

### 14. Freezed Union Type Handling
- **`mapOrNull`**: When you have unused parameters (access via `state.propertyName`)
- **`whenOrNull`**: When you need most/all parameters (destructured in callback)
- **`when()`**: Only when handling ALL cases is required
- **NEVER use `maybeWhen` with empty `orElse: () {}`** - use `whenOrNull` instead
  ```dart
  // ✅ Good - mapOrNull (only need 2 of 6 params)
  state.mapOrNull(
    loaded: (s) => _controller.text = s.editingId ?? '',
  );

  // ✅ Good - whenOrNull (using all params)
  state.whenOrNull(
    loaded: (detail, perms, sync) async {
      await _updateUI(detail);
      await _checkPerms(perms);
    },
  );
  ```

### 15. Vector Graphics Usage
- Use `flutter_gen` for type-safe asset references (NOT string paths)
- Use `vector_graphics` package for SVG (NOT `flutter_svg`)
  ```dart
  import 'package:app/gen/assets.gen.dart';
  Assets.icons.home.svg(width: 24, height: 24)
  ```

### 16. TextStyle Usage (Design System)
- NEVER hardcode TextStyle - always use `Theme.of(context).textTheme`
- Available: display*, headline*, title*, body*, label* (Large/Medium/Small)
  ```dart
  // ✅ Correct
  Text('Title', style: Theme.of(context).textTheme.headlineLarge)

  // Override specific properties when needed
  Text('Custom', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red))
  ```

### 17. Common Widget Usage (UI Consistency)
- ALWAYS use widgets from `lib/core/presentation/widgets/`
- NEVER recreate basic UI components in feature code

**Available Widgets:**
- Buttons: `AppFlatButton`, `AppOutlinedButton`
- Form: `AppLinedTextField`, `AppOutlinedTextField`, `AppOutlinedTextarea`, `AppLinedDropdown`, `AppOutlinedDropdown`, `AppCheckbox`
- Navigation: `AppBar`, `AppBottomNavBar`, `AppBottomSheet`, `AppSegmentedTabBar`
- Loading: `LoadingOverlay`
- Other: `AppIcon`

**When to create feature-specific widgets:**
- Component used only within single feature
- Has feature-specific business logic
- Is composition of common widgets with feature-specific layout

### 18. Chart Display (fl_chart)
- Use `fl_chart` package for all charts (NEVER create custom with CustomPainter)
- Available: LineChart, BarChart, PieChart, ScatterChart, RadarChart

## Environment Setup

### Required Files
- `.env` file (root directory)
  ```
  API_BASE_URL=<your_api_base_url>
  ```

### VS Code Settings
- Auto-hide generated files through file nesting (`*.g.dart`, `*.freezed.dart`)
- Auto-enable Hot Reload

## Testing
- Maintain test directory structure for each feature
- Use Mockito (`@GenerateMocks` annotation)
- UseCase and Repository tests are required

## API Integration
- Swagger documentation: **To be added**
- **JSON API Specification**: The above URL contains the complete API specification in JSON format (OpenAPI/Swagger), which can be used to reference all backend endpoints, request/response schemas, and data models
- Access/Refresh token pattern
- Role-based access control (Farm, Hospital, Intern, Header, Admin)

## Important Notes
- **Do not run the app directly** (requires simulator/emulator)
- Prefer modifying existing files over creating new ones
- Never include sensitive information in production code