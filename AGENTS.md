# AGENTS.md

This file provides guidance to AI Agents when working with code in this repository.

IMPORTANT! NOTE: This project is currently being set up, and the content described below may not have been fully implemented. This is due to the fact that the content below is from another completed project. Please proceed as if you are aiming for the structure below.

## Project Overview
Stroke Spoiler - Prototype Mobile/Web cross-platform app for stroke prevention management.

## Development Commands

### Essential Commands
```bash
# Install dependencies
flutter pub get

# Code generation (REQUIRED - run after adding new models or providers)
dart run build_runner build --delete-conflicting-outputs

# Code generation watch mode (recommended during development)
dart run build_runner watch --delete-conflicting-outputs

# Run app (debug mode)
flutter run

# Static analysis
flutter analyze

# Run tests
flutter test

# Run single test file
flutter test test/[test_file_name]_test.dart

# Android build
flutter build apk --release
flutter build appbundle --release

# iOS build
flutter build ios --release

# Code formatting
dart format .

# Clean build
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
            └── state/          # StateNotifier and State classes
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
- **state**: State classes (`@freezed`) and StateNotifier
- **providers**: Riverpod providers (`@riverpod`)
- Naming: `*View` (e.g., `LoginView`), `*State`, `*Notifier`

## Core Coding Rules

### 1. Import Rules
- **Always use relative paths** for internal project imports (no package paths)
- Use package paths only for external dependencies
  ```dart
  // ✅ Correct - Using relative paths for project files
  import '../domain/entities/auth_entity.dart';
  import '../../core/utils/validators.dart';

  // ❌ Wrong - Using package paths for project files
  import 'package:app/features/auth/domain/entities/auth_entity.dart';

  // ✅ Correct - Package paths for external dependencies
  import 'package:flutter/material.dart';
  import 'package:riverpod_annotation/riverpod_annotation.dart';
  ```

### 2. Freezed Usage Rules
- When using `@freezed` annotation, **must define as abstract class**
  ```dart
  // ✅ Correct
  @freezed
  abstract class UserEntity with _$UserEntity {
    const factory UserEntity({...}) = _UserEntity;
  }

  // ❌ Wrong - will cause error
  @freezed
  class UserEntity with _$UserEntity {
    const factory UserEntity({...}) = _UserEntity;
  }
  ```

- **ALWAYS import Freezed classes before using their methods** (`.when`, `.whenOrNull`, `.map`, etc.)
  - Freezed generates extension methods (`.when`, `.whenOrNull`, `.map`, `.maybeMap`, etc.) in `*.freezed.dart` files
  - These methods are NOT available unless you import the class file
  - Missing imports will cause "method not found" errors even though code generation is correct
  ```dart
  // ✅ Correct
  import 'package:bovivet/features/user/domain/entities/user_entity.dart';

  void handleUser(UserEntity user) {
    user.when(  // ✅ Methods available
      intern: (data) => print('Intern'),
      farm: (data) => print('Farm'),
      // ...
    );
  }

  // ❌ Wrong - Missing import
  void handleUser(UserEntity user) {
    user.when(  // ❌ Error: 'when' is not defined
      // This will fail because UserEntity is not imported!
    );
  }
  ```

### 3. Code Generation Files
- `*.g.dart` (json_serializable) and `*.freezed.dart` files are auto-generated
- Excluded from version control (included in `.gitignore`)
- Must run `dart run build_runner build` after adding new models/providers

### 4. Riverpod Providers
- Use code generation approach (`@riverpod` annotation)
- `part` directive is required
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
- **Primary Pattern**: Use `AsyncNotifier` with `AsyncValue` for async operations
- Use `Notifier` for synchronous state only
- Use `Mutation` for one-off UI operations (form submissions, delete actions)
- State classes should be immutable (`@freezed`)
- **References**:
  - See `docs/RIVERPOD_V3_BEST_PRACTICES.md` for comprehensive guidelines
  - [Riverpod v3 Mutations (Official)](https://riverpod.dev/ko/docs/concepts2/mutations)

#### AsyncNotifier Pattern (Recommended for API calls)
  ```dart
  @riverpod
  class UserDetail extends _$UserDetail {
    @override
    Future<UserDetailState> build() async {
      final userDetail = await _fetchUserDetail();
      return UserDetailState(userDetail: userDetail);
    }

    // Custom methods use AsyncValue.guard for error handling
    Future<void> updateUser({required String name}) async {
      final currentData = state.value;
      if (currentData == null) return;

      try {
        final updateUseCase = ref.read(updateUserUseCaseProvider);
        await updateUseCase(name: name);

        // Reload data without loading state (clean pattern)
        final updatedUserDetail = await _fetchUserDetail();
        state = AsyncValue.data(
          UserDetailState(userDetail: updatedUserDetail),
        );
      } catch (error, stackTrace) {
        state = AsyncValue.error('업데이트 실패: $error', stackTrace);
      }
    }
  }
  ```

#### Notifier Pattern (For sync state)
  ```dart
  @riverpod
  class Filter extends _$Filter {
    @override
    FilterState build() => const FilterState();

    void updateCategory(String category) {
      state = state.copyWith(selectedCategory: category);
    }
  }
  ```

#### State Class Pattern
  ```dart
  @freezed
  abstract class UserDetailState with _$UserDetailState {
    const factory UserDetailState({
      required UserDetailEntity userDetail,
    }) = _UserDetailState;
  }
  ```

### 7. Repository Design Pattern
- Repository interfaces in Domain layer should use individual parameters, NOT Entity objects as method parameters
- This provides clearer API contracts and avoids unnecessary Entity creation
  ```dart
  // ✅ Correct
  Future<void> requestFarmMapping({
    required List<int> farmIds,
  });
  
  // ❌ Wrong
  Future<void> requestFarmMapping({
    required RequestFarmMappingEntity request,
  });
  ```

### 8. Model Extension Pattern
- Model to Entity conversion methods should be defined as extensions, NOT as class methods
- Extensions should be placed in a separate section at the bottom of the model file
- This keeps model classes pure and separates conversion logic
  ```dart
  // ✅ Correct - Using extension
  @freezed
  abstract class UserModel with _$UserModel {
    const factory UserModel({...}) = _UserModel;
    factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  }
  
  // ==================== Extensions ====================
  extension UserModelX on UserModel {
    UserEntity toEntity() => UserEntity(...);
  }
  
  // ❌ Wrong - Method inside class
  @freezed
  abstract class UserModel with _$UserModel {
    const UserModel._();  // Don't add this
    const factory UserModel({...}) = _UserModel;
    
    // Don't add conversion method here
    UserEntity toEntity() => UserEntity(...);
  }
  ```

### 9. Routing
- Use GoRouter (`core/router/router_provider.dart`)
- Use absolute paths (`/login`, `/mypage`, etc.)
- Automatic redirect based on authentication state

### 10. PagedEntity Usage Pattern
- **ALWAYS use the correct PagedEntity constructor pattern**
- Follow the cow feature pattern: `PagedEntity(items: ..., pagination: ...)`
- Use `response.paging.toEntity()` for pagination information
  ```dart
  // ✅ Correct
  return PagedEntity(
    items: response.data!.map((model) => model.toEntity()).toList(),
    pagination: response.paging.toEntity(),
  );
  
  // ❌ Wrong - Old pattern
  return PagedEntity<EntityType>(
    content: response.data?.map((model) => model.toEntity()).toList() ?? [],
    totalElements: response.totalElements ?? 0,
    totalPages: response.totalPages ?? 0,
    // ... other fields
  );
  ```

### 11. Provider Layer Separation
- **Data Layer Providers**: Only DataSource and Repository providers
- **Domain Layer Providers**: Only UseCase providers
- **NEVER mix UseCase providers in Data layer providers**
  ```dart
  // ✅ Correct - Data Layer (data/providers/)
  @riverpod
  ExampleRepository exampleRepository(Ref ref) {
    return ExampleRepositoryImpl(
      remoteDataSource: ref.watch(exampleRemoteDataSourceProvider),
    );
  }
  
  // ✅ Correct - Domain Layer (domain/providers/)
  @riverpod
  ExampleUseCase exampleUseCase(Ref ref) {
    return ExampleUseCase(ref.watch(exampleRepositoryProvider));
  }
  
  // ❌ Wrong - UseCase in Data Layer
  // Don't put UseCase providers in data/providers/
  ```

### 12. Color Opacity Usage
- **NEVER use `withOpacity()`** (deprecated in Flutter)
- **Always use `withValues(alpha: value)` instead**
  ```dart
  // ✅ Correct
  color: Colors.blue.withValues(alpha: 0.7)

  // ❌ Wrong - deprecated
  color: Colors.blue.withOpacity(0.7)
  ```

### 13. RadioGroup Usage (Flutter 3.32+)
- **ALWAYS use `RadioGroup` to manage radio button groups** (Flutter 3.32+)
- Individual `RadioListTile`'s `groupValue` and `onChanged` are deprecated
- Manage state at the parent `RadioGroup` level using `groupValue` and `onChanged`
  ```dart
  // ✅ Correct - Using RadioGroup
  String? selectedValue;

  RadioGroup<String>(
    groupValue: selectedValue,
    onChanged: (value) {
      setState(() {
        selectedValue = value;
      });
    },
    child: Column(
      children: [
        RadioListTile<String>(
          title: const Text('Option 1'),
          value: 'option1',
        ),
        RadioListTile<String>(
          title: const Text('Option 2'),
          value: 'option2',
        ),
      ],
    ),
  )

  // ❌ Wrong - Using deprecated individual properties
  RadioListTile<String>(
    title: const Text('Option 1'),
    value: 'option1',
    groupValue: selectedValue,  // Deprecated!
    onChanged: (value) {         // Deprecated!
      setState(() {
        selectedValue = value;
      });
    },
  )
  ```

### 14. Freezed Union Type Handling

#### Choosing the Right Method
- **Use `mapOrNull` when you have unused parameters** in the callback
  - Avoids listing parameters you don't need
  - Access properties via `state.propertyName`
  - Cleaner and more maintainable
- **Use `whenOrNull` when you need most/all parameters** from the union case
  - Parameters are destructured directly in the callback
  - Best when you actually use the parameters
- **Use `when()` only when handling ALL cases** is required
- **Use `maybeWhen()` only for custom `orElse` behavior** (NOT for empty callbacks)
- **NEVER use `maybeWhen` with empty `orElse: () {}` callback** - use `whenOrNull` or `mapOrNull` instead

#### Examples

  ```dart
  // ✅ Good - Using mapOrNull (only need 2 out of 6 parameters)
  cowDetailState.mapOrNull(
    loaded: (state) {
      // Access only what you need via state object
      if (_controller.text != state.editingCowEntityId) {
        _controller.text = state.editingCowEntityId ?? '';
      }
    },
  );

  // ❌ Bad - Using whenOrNull with unused parameters
  cowDetailState.whenOrNull(
    loaded: (cow, editingId, manageNo, species, remark, isEditing) {
      // Only using editingId, but must list all 6 parameters!
      if (_controller.text != editingId) {
        _controller.text = editingId ?? '';
      }
    },
  );

  // ✅ Good - Using whenOrNull (actually using most parameters)
  await state.whenOrNull(
    loaded: (userDetail, permissions, lastSync) async {
      // All parameters are meaningfully used
      await _updateUI(userDetail);
      await _checkPermissions(permissions);
      await _displaySyncTime(lastSync);
    },
  );

  // ❌ Wrong - Using maybeWhen with empty orElse
  await state.maybeWhen(
    loaded: (userDetail) async {
      await userDetail.maybeWhen(
        intern: (internUser) async {
          // Handle intern case only
        },
        orElse: () async {},  // Empty callback - use whenOrNull instead!
      );
    },
    orElse: () async {},  // Empty callback - use whenOrNull instead!
  );

  // ❌ Even Worse - Using when() with empty callbacks
  await state.maybeWhen(
    loaded: (userDetail) async {
      userDetail.when(
        intern: (internUser) async { /* logic */ },
        farm: (_) async {},      // All these empty callbacks
        hospital: (_) async {},  // should be replaced
        header: (_) async {},    // with a single
        admin: (_) async {},     // whenOrNull!
      );
    },
    orElse: () async {},
  );
  ```

### 15. Vector Graphics Usage (flutter_gen + vector_graphics)
- **Use `flutter_gen` for auto-generated asset references**
- **Use `vector_graphics` package for SVG rendering** (not `flutter_svg`)
- NEVER directly load SVG files with string paths
- Generated asset classes provide type-safe references
  ```dart
  // ✅ Correct - Using flutter_gen generated assets
  import 'package:app/gen/assets.gen.dart';

  // In Widget
  Assets.icons.home.svg(
    width: 24,
    height: 24,
    colorFilter: ColorFilter.mode(
      Colors.black,
      BlendMode.srcIn,
    ),
  )

  // ❌ Wrong - Direct path string
  SvgPicture.asset(
    'assets/icons/home.svg',
    width: 24,
    height: 24,
  )

  // ❌ Wrong - Using flutter_svg package
  import 'package:flutter_svg/flutter_svg.dart';
  ```

#### Configuration
- SVG assets must be declared in `pubspec.yaml` under `flutter_gen`
- Run `flutter pub get` to regenerate asset classes after adding new files
- Generated files are located in `lib/gen/assets.gen.dart`

## Environment Setup

### Required Files
- `.env` file (root directory)
  ```
  API_BASE_URL=https://cat-informed-newt.ngrok-free.app
  ```

### VS Code Settings
- Auto-hide generated files through file nesting (`*.g.dart`, `*.freezed.dart`)
- Auto-enable Hot Reload

## Testing
- Maintain test directory structure for each feature
- Use Mockito (`@GenerateMocks` annotation)
- UseCase and Repository tests are required

## API Integration
- Swagger documentation: `https://cat-informed-newt.ngrok-free.app/v3/api-docs`
- **JSON API Specification**: The above URL contains the complete API specification in JSON format (OpenAPI/Swagger), which can be used to reference all backend endpoints, request/response schemas, and data models
- Access/Refresh token pattern
- Role-based access control (Farm, Hospital, Intern, Header, Admin)

## Important Notes
- **Do not run the app directly** (requires simulator/emulator)
- Prefer modifying existing files over creating new ones
- Never include sensitive information in production code
- Use `--delete-conflicting-outputs` option if code generation fails

## Debugging Commands
```bash
# Clean and regenerate files
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs

# Check Riverpod lints
dart run custom_lint

# iOS issues
cd ios && pod install && cd ..

# Android issues
cd android && ./gradlew clean && cd ..
```