# Riverpod 3.0 Best Practices Guide

> **Target Architecture**: MVVM + Feature-First Clean Architecture  
> **State Management**: Riverpod 3.0  
> **Navigation**: go_router  
> **Immutability**: freezed  
> **Code Generation**: riverpod_generator + build_runner

---

## Table of Contents

1. [Breaking Changes in Riverpod 3.0](#breaking-changes-in-riverpod-30)
2. [Provider Naming Conventions](#provider-naming-conventions)
3. [Core Principles](#core-principles)
4. [AsyncNotifier & AsyncValue](#asyncnotifier--asyncvalue)
5. [Page State Management Patterns](#page-state-management-patterns)
6. [Mutations (Experimental)](#mutations-experimental)
7. [Feature-First Project Structure](#feature-first-project-structure)
8. [Error Handling](#error-handling)
9. [Testing](#testing)
10. [Common Pitfalls](#common-pitfalls)
11. [Migration Checklist](#migration-checklist)

---

## Breaking Changes in Riverpod 3.0

### 1. Automatic Retry (Enabled by Default)

Providers now automatically retry on failure until they succeed.

```dart
// Disable globally
void main() {
  runApp(
    ProviderScope(
      retry: (retryCount, error) => null, // Never retry
      child: MyApp(),
    ),
  );
}

// Disable per provider (with riverpod_generator)
@riverpod
Duration? retry(int retryCount, Object error) {
  if (error is NetworkException) return null;
  if (retryCount > 3) return null;
  return Duration(seconds: retryCount * 2);
}

@Riverpod(retry: retry)
class User extends _$User {
  @override
  Future<UserModel> build() async => fetchUser();
}
```

### 2. Legacy Providers Moved

`StateProvider`, `StateNotifierProvider`, and `ChangeNotifierProvider` are now legacy.

```dart
// ❌ Old way (now legacy)
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ If you must use legacy providers
import 'package:flutter_riverpod/legacy.dart';

// ✅✅ Recommended: Use Notifier instead
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++;
}
```

### 3. Provider Naming Convention Changed

**Default behavior**: Class names ending with "Notifier" have the suffix automatically stripped.

```dart
// Class name: UserNotifier
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  User build() => User();
}

// Generated provider name:
// Riverpod 2.x: userNotifierProvider
// Riverpod 3.0: userProvider ✅
```

**Configuration** (build.yaml):

```yaml
targets:
  $default:
    builders:
      riverpod_generator:
        options:
          provider_name_strip_pattern: "Notifier$"  # default
          provider_name_suffix: "Provider"           # default
```

**Recommended naming**:

```dart
// ✅ Simple, clean names (recommended)
@riverpod
class User extends _$User { }           // → userProvider

@riverpod
class UserRepository extends _$UserRepository { } // → userRepositoryProvider

// ❌ Redundant suffix (discouraged)
@riverpod
class UserNotifier extends _$UserNotifier { }     // → userProvider (Notifier stripped)
```

### 4. Family Variant Removed

Parameters are now passed via constructor instead of build method.

```dart
// ❌ Riverpod 2.x
@riverpod
class UserDetail extends _$UserDetail {
  @override
  Future<User> build(String userId) async {
    return fetchUser(userId);
  }
}

// ✅ Riverpod 3.0
@riverpod
class UserDetail extends _$UserDetail {
  UserDetail(this.userId);  // Constructor parameter
  final String userId;
  
  @override
  Future<User> build() async {  // No parameters
    return fetchUser(userId);
  }
}
```

### 5. AutoDispose Interfaces Unified

No more separate `AutoDisposeNotifier`, `AutoDisposeAsyncNotifier`, etc.

```dart
// ✅ Just use Notifier (autoDispose by default in 3.0)
@riverpod
class User extends _$User {
  @override
  UserModel build() => UserModel();
}

// To keep alive
@Riverpod(keepAlive: true)
class GlobalSettings extends _$GlobalSettings {
  @override
  Settings build() => Settings();
}
```

### 6. Error Wrapping

Provider failures are now wrapped in `ProviderException`.

```dart
// ❌ Old
try {
  await ref.read(loginProvider.future);
} on AuthException {
  // Handle directly
}

// ✅ New
try {
  await ref.read(loginProvider.future);
} on ProviderException catch (e) {
  if (e.exception is AuthException) {
    // Extract original error
  }
}

// ✅✅ Recommended: Use AsyncValue (no wrapping)
final loginState = ref.watch(loginProvider);
loginState.when(
  data: (_) => ...,
  error: (error, _) {
    if (error is AuthException) { } // Direct access
  },
  loading: () => ...,
);
```

---

## Provider Naming Conventions

### Class vs Provider Names

```dart
// Pattern: [Feature][Type]
@riverpod
class User extends _$User { }                    // → userProvider
@riverpod
class UserRepository extends _$UserRepository { } // → userRepositoryProvider
@riverpod
class ProductList extends _$ProductList { }       // → productListProvider
@riverpod
class CartTotal extends _$CartTotal { }           // → cartTotalProvider
```

### Override Default Naming

```yaml
# build.yaml
targets:
  $default:
    builders:
      riverpod_generator:
        options:
          provider_name_strip_pattern: "(Notifier|Controller)$"
          provider_name_suffix: "Provider"
```

```dart
// Or override per provider
@Riverpod(name: 'currentUser')
class UserState extends _$UserState { }  // → currentUserProvider
```

---

## Core Principles

### The Two-Provider Rule

**Use only 2 types of providers for 99% of use cases:**

1. **AsyncNotifierProvider** - For async state (API calls, DB queries)
2. **Provider** - For dependency injection (repositories, services)

```dart
// ✅ Async state
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async => fetchProducts();
}

// ✅ Dependency injection
@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepositoryImpl(api: ref.watch(apiClientProvider));
}
```

### Separation of Concerns

**UI files should ONLY render widgets. Business logic stays in providers.**

```dart
// ❌ Business logic in widget
class ProductPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final products = await http.get('api/products'); // ❌ NO!
        // ... processing logic
      },
      child: Text('Fetch'),
    );
  }
}

// ✅ Logic in provider
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    return ref.read(productRepositoryProvider).fetchProducts();
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

class ProductPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => ref.read(productListProvider.notifier).refresh(),
      child: Text('Fetch'),
    );
  }
}
```

---

## AsyncNotifier & AsyncValue

### AsyncNotifier Basics

**AsyncNotifier** manages asynchronous state with built-in loading/error handling.

```dart
@riverpod
class User extends _$User {
  // build() automatically catches errors and converts to AsyncError
  @override
  Future<UserModel> build(String userId) async {
    return await ref.read(userRepositoryProvider).getUser(userId);
  }
  
  // Custom methods need AsyncValue.guard
  Future<void> updateName(String newName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).updateName(userId, newName);
      return build(); // Reload
    });
  }
}
```

### AsyncValue States

AsyncValue represents 3 states:

```dart
sealed class AsyncValue<T> {
  AsyncData<T>    // Has data
  AsyncLoading<T> // Loading
  AsyncError<T>   // Has error
}
```

### AsyncValue Methods

#### 1. when() - Handle all states (required)

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final userState = ref.watch(userProvider);
  
  return userState.when(
    data: (user) => Text('Hello ${user.name}'),
    loading: () => CircularProgressIndicator(),
    error: (error, stack) => Text('Error: $error'),
  );
}
```

#### 2. maybeWhen() - Handle specific states

```dart
return userState.maybeWhen(
  error: (error, _) => ErrorWidget(error),
  orElse: () => Text('Loading or showing data...'),
);
```

#### 3. whenData() - Handle only data

```dart
return userState.whenData(
  (user) => Text('Name: ${user.name}'),
);
// Returns null on loading/error
```

#### 4. map() - Transform based on state

```dart
return userState.map(
  data: (AsyncData<User> data) => UserCard(user: data.value),
  loading: (AsyncLoading loading) => LoadingSpinner(),
  error: (AsyncError error) => ErrorDisplay(error: error.error),
);
```

### AsyncValue Properties

```dart
final userState = ref.watch(userProvider);

// State checks
bool hasValue = userState.hasValue;     // Has data?
bool hasError = userState.hasError;     // Has error?
bool isLoading = userState.isLoading;   // Is loading?

// Value access (nullable)
User? user = userState.value;           // null if loading/error
Object? error = userState.error;        // null if data/loading

// Value access (throws if not data)
User user = userState.requireValue;     // ⚠️ Throws StateError if loading/error
```

### AsyncValue.guard() - Automatic Error Handling

**guard() wraps try-catch automatically:**

```dart
// ❌ Manual try-catch (verbose)
Future<void> updateUser(User user) async {
  try {
    state = const AsyncValue.loading();
    final updated = await repository.updateUser(user);
    state = AsyncValue.data(updated);
  } catch (error, stack) {
    state = AsyncValue.error(error, stack);
  }
}

// ✅ Using guard (clean)
Future<void> updateUser(User user) async {
  state = const AsyncValue.loading();
  state = await AsyncValue.guard(() async {
    return await repository.updateUser(user);
  });
}
```

**When to use guard:**

```dart
@riverpod
class User extends _$User {
  @override
  Future<UserModel> build() async {
    // ❌ NO guard in build() - auto-handled
    return fetchUser();
  }
  
  Future<void> refresh() async {
    // ✅ YES guard in custom methods
    state = await AsyncValue.guard(() => build());
  }
}
```

### value vs requireValue

```dart
final AsyncValue<User> userState = ref.watch(userProvider);

// ✅ Safe: Returns null on loading/error
User? user = userState.value;
if (user != null) {
  print(user.name);
}

// ⚠️ Unsafe: Throws StateError on loading/error
User user = userState.requireValue;  // Use only if hasValue == true

// ✅✅ Recommended: Use when()
userState.when(
  data: (user) => print(user.name),
  loading: () => print('Loading...'),
  error: (e, _) => print('Error: $e'),
);
```

---

## Page State Management Patterns

### Pattern 1: AsyncNotifier for Page ViewModel

**Best for: Pages with API calls, complex async logic**

```dart
// 1. Define state model with Freezed
@freezed
class UserPageState with _$UserPageState {
  const factory UserPageState({
    required UserModel? user,
    @Default(false) bool isEditing,
    @Default('') String searchQuery,
  }) = _UserPageState;
}

// 2. Create AsyncNotifier for page state
@riverpod
class UserPage extends _$UserPage {
  @override
  Future<UserPageState> build(String userId) async {
    final user = await ref.read(userRepositoryProvider).getUser(userId);
    return UserPageState(user: user);
  }
  
  // Business logic methods
  Future<void> updateUserName(String newName) async {
    final current = state.value;
    if (current == null) return;
    
    // Optimistic update
    state = AsyncValue.data(
      current.copyWith(
        user: current.user?.copyWith(name: newName),
      ),
    );
    
    try {
      await ref.read(userRepositoryProvider).updateName(userId, newName);
    } catch (e) {
      // Rollback on error
      state = await AsyncValue.guard(() => build());
    }
  }
  
  void startEditing() {
    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(isEditing: true));
    }
  }
}

// 3. UI consumes the state
class UserPage extends ConsumerWidget {
  final String userId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageState = ref.watch(userPageProvider(userId));
    
    return Scaffold(
      body: pageState.when(
        data: (state) => _buildContent(context, ref, state),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(error: error),
      ),
    );
  }
  
  Widget _buildContent(BuildContext context, WidgetRef ref, UserPageState state) {
    return Column(
      children: [
        Text(state.user?.name ?? ''),
        if (state.isEditing)
          TextField(
            onSubmitted: (name) => ref
                .read(userPageProvider(userId).notifier)
                .updateUserName(name),
          ),
      ],
    );
  }
}
```

### Pattern 2: Notifier for Local/Sync State

**Best for: UI-only state (filters, tabs, forms without API calls)**

```dart
@freezed
class SettingsPageState with _$SettingsPageState {
  const factory SettingsPageState({
    @Default(false) bool isDarkMode,
    @Default(true) bool notificationsEnabled,
  }) = _SettingsPageState;
}

@riverpod
class SettingsPage extends _$SettingsPage {
  @override
  SettingsPageState build() {
    return const SettingsPageState();
  }
  
  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }
  
  void toggleNotifications() {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
  }
}

class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsPageProvider);
    
    return Column(
      children: [
        SwitchListTile(
          title: Text('Dark Mode'),
          value: settings.isDarkMode,
          onChanged: (_) => ref.read(settingsPageProvider.notifier).toggleDarkMode(),
        ),
      ],
    );
  }
}
```

### Pattern 3: Optimistic Updates

```dart
@riverpod
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async {
    return ref.read(todoRepositoryProvider).fetchAll();
  }
  
  Future<void> toggleTodo(String id) async {
    final currentList = state.value ?? [];
    
    // 1. Update UI immediately (optimistic)
    state = AsyncValue.data(
      currentList.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(completed: !todo.completed);
        }
        return todo;
      }).toList(),
    );
    
    // 2. API call in background
    try {
      await ref.read(todoRepositoryProvider).toggle(id);
    } catch (e) {
      // 3. Rollback on failure
      state = await AsyncValue.guard(() => build());
      rethrow;
    }
  }
}
```

### Pattern 4: Pull-to-Refresh with Previous Data

```dart
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    return _fetchProducts();
  }
  
  Future<void> refresh() async {
    // Keep previous data visible during refresh
    state = const AsyncValue.loading().copyWithPrevious(state);
    state = await AsyncValue.guard(() => _fetchProducts());
  }
  
  Future<List<Product>> _fetchProducts() async {
    return ref.read(productRepositoryProvider).fetchAll();
  }
}

class ProductPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productListProvider);
    
    return RefreshIndicator(
      onRefresh: () => ref.read(productListProvider.notifier).refresh(),
      child: productsState.when(
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (ctx, idx) => ProductCard(products[idx]),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(error: e),
      ),
    );
  }
}
```

---

## Mutations (Experimental)

**📚 Official Documentation**: [Riverpod v3 Mutations](https://riverpod.dev/ko/docs/concepts2/mutations)  
**📄 Detailed Guide**: [RIVERPOD_V3_MUTATIONS.md](RIVERPOD_V3_MUTATIONS.md)

### What are Mutations?

**Mutations** are experimental objects in Riverpod v3 designed to handle UI reactions to state changes, particularly for operations like form submissions, API calls with loading indicators, and other one-off actions.

**⚠️ Experimental Status**: The Mutations API may change in breaking ways without a major version bump. Use with caution in production.

### Mutations vs AsyncNotifier

| Feature | AsyncNotifier | Mutation |
|---------|---------------|----------|
| **Purpose** | Manage persistent state | Handle one-off operations |
| **State pollution** | Can pollute state with UI concerns | Keeps UI state separate |
| **Best for** | Data that needs to persist | Form submissions, delete actions |
| **Reset behavior** | Manual | Auto-resets on completion |
| **Loading state** | Part of AsyncValue | Built-in MutationPending |

### When to Use Mutations

✅ **Use Mutations for:**
- Form submissions with loading/error feedback
- Delete operations with UI feedback
- One-off API calls that don't affect main state
- Operations where you need temporary loading/error states

❌ **Use AsyncNotifier for:**
- Fetching and displaying data
- Managing persistent state
- Operations that update the main data model

### Quick Example

```dart
// Define mutation
final submitForm = Mutation<FormResult>();

// Use in widget
class FormPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(submitForm);
    
    return ElevatedButton(
      onPressed: state.isPending ? null : () {
        submitForm.run(ref, (tsx) async {
          return await tsx.get(repositoryProvider).submit(data);
        });
      },
      child: state.isPending 
          ? CircularProgressIndicator() 
          : Text('Submit'),
    );
  }
}
```

> **📖 For detailed usage, patterns, and complete examples, see [RIVERPOD_V3_MUTATIONS.md](RIVERPOD_V3_MUTATIONS.md)**

---

## Feature-First Project Structure

```
lib/
├── core/
│   ├── providers/
│   │   ├── api_client.dart          # Provider<ApiClient>
│   │   └── storage.dart              # Provider<Storage>
│   └── utils/
│       └── constants.dart
│
├── features/
│   ├── auth/
│   │   ├── models/
│   │   │   ├── user_model.dart          # @freezed
│   │   │   └── auth_state.dart          # @freezed
│   │   ├── providers/
│   │   │   ├── auth_repository.dart     # Provider
│   │   │   └── auth.dart                # AsyncNotifier
│   │   └── views/
│   │       ├── login_page.dart
│   │       └── widgets/
│   │           └── login_form.dart
│   │
│   ├── product/
│   │   ├── models/
│   │   │   ├── product_model.dart       # @freezed
│   │   │   └── product_page_state.dart  # @freezed
│   │   ├── providers/
│   │   │   ├── product_repository.dart  # Provider
│   │   │   ├── product_list.dart        # AsyncNotifier
│   │   │   ├── product_detail.dart      # AsyncNotifier
│   │   │   └── product_filter.dart      # Notifier (sync)
│   │   └── views/
│   │       ├── product_list_page.dart
│   │       ├── product_detail_page.dart
│   │       └── widgets/
│   │           ├── product_card.dart
│   │           └── product_filter_bar.dart
│   │
│   └── cart/
│       ├── models/
│       ├── providers/
│       └── views/
│
└── main.dart
```

### Provider Organization

```dart
// ✅ Repository layer (Provider)
@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepositoryImpl(
    api: ref.watch(apiClientProvider),
    storage: ref.watch(storageProvider),
  );
}

// ✅ State layer (AsyncNotifier)
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    return ref.read(productRepositoryProvider).fetchAll();
  }
}

// ✅ UI-only state (Notifier)
@riverpod
class ProductFilter extends _$ProductFilter {
  @override
  FilterState build() => const FilterState();
  
  void updateCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }
}
```

---

## Error Handling

### Pattern 1: SnackBar on Error (ref.listen)

```dart
class ProductPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for errors and show SnackBar
    ref.listen(productListProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    
    final productsState = ref.watch(productListProvider);
    
    // Show products even if error occurred (using previous data)
    final products = productsState.valueOrNull ?? [];
    
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, idx) => ProductCard(products[idx]),
    );
  }
}
```

### Pattern 2: Inline Error Display

```dart
class ProductPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productListProvider);
    
    return productsState.when(
      data: (products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, idx) => ProductCard(products[idx]),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(productListProvider),
      ),
    );
  }
}
```

### Pattern 3: Custom Error Types

```dart
// Define custom errors
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

// Handle in UI
ref.listen(loginProvider, (previous, next) {
  next.whenOrNull(
    error: (error, _) {
      if (error is AuthException) {
        // Show auth-specific error
      } else if (error is NetworkException) {
        // Show network error
      }
    },
  );
});
```

---

## Testing

### Test AsyncNotifier

```dart
void main() {
  test('UserPage loads user data correctly', () async {
    final container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(
          MockUserRepository(),
        ),
      ],
    );
    
    // Wait for async operation
    final userPage = await container.read(
      userPageProvider('user123').future,
    );
    
    expect(userPage.user?.id, 'user123');
    expect(userPage.isEditing, false);
    
    container.dispose();
  });
  
  test('UserPage handles update correctly', () async {
    final container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(
          MockUserRepository(),
        ),
      ],
    );
    
    // Load initial state
    await container.read(userPageProvider('user123').future);
    
    // Update name
    await container
        .read(userPageProvider('user123').notifier)
        .updateUserName('New Name');
    
    final updatedState = container.read(userPageProvider('user123')).value;
    expect(updatedState?.user?.name, 'New Name');
    
    container.dispose();
  });
}
```

### Test with ProviderContainer

```dart
void main() {
  late ProviderContainer container;
  
  setUp(() {
    container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(
          MockProductRepository(),
        ),
      ],
    );
  });
  
  tearDown(() {
    container.dispose();
  });
  
  test('ProductList fetches products', () async {
    final products = await container.read(productListProvider.future);
    expect(products.length, greaterThan(0));
  });
}
```

---

## Common Pitfalls

### ❌ DON'T: Use Legacy Providers

```dart
// ❌ Don't use StateProvider
final counterProvider = StateProvider<int>((ref) => 0);

// ✅ Use Notifier instead
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++;
}
```

### ❌ DON'T: Put Business Logic in Widgets

```dart
// ❌ Bad
class ProductPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final products = await http.get('api/products'); // ❌
        // ... more logic
      },
      child: Text('Fetch'),
    );
  }
}

// ✅ Good - logic in provider
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    return ref.read(productRepositoryProvider).fetchProducts();
  }
}
```

### ❌ DON'T: Use ref.watch in Callbacks

```dart
// ❌ Bad
ElevatedButton(
  onPressed: () {
    final counter = ref.watch(counterProvider); // ❌ Don't watch in callbacks
    print(counter);
  },
  child: Text('Log'),
)

// ✅ Good
ElevatedButton(
  onPressed: () {
    final counter = ref.read(counterProvider); // ✅ Use read for one-time access
    print(counter);
  },
  child: Text('Log'),
)
```

### ❌ DON'T: Use requireValue Unsafely

```dart
// ❌ Unsafe - throws on loading/error
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(userProvider).requireValue; // ❌ Crashes on loading!
  return Text(user.name);
}

// ✅ Safe - use when()
Widget build(BuildContext context, WidgetRef ref) {
  return ref.watch(userProvider).when(
    data: (user) => Text(user.name),
    loading: () => CircularProgressIndicator(),
    error: (e, _) => Text('Error'),
  );
}
```

### ❌ DON'T: Use AsyncValue.guard in build()

```dart
@riverpod
class User extends _$User {
  @override
  Future<UserModel> build() async {
    // ❌ Unnecessary - build() auto-catches errors
    return await AsyncValue.guard(() => fetchUser());
    
    // ✅ Just throw normally
    return await fetchUser();
  }
}
```

### ❌ DON'T: Mutate State Directly

```dart
// ❌ Bad - mutating state
@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() => [];
  
  void addTodo(Todo todo) {
    state.add(todo); // ❌ Mutates state!
  }
}

// ✅ Good - immutable update
@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() => [];
  
  void addTodo(Todo todo) {
    state = [...state, todo]; // ✅ Creates new list
  }
}
```

---

## Migration Checklist

### Pre-Migration

- [ ] Upgrade to latest Riverpod 2.x
- [ ] Enable `riverpod_generator` and `riverpod_lint`
- [ ] Convert `StateNotifierProvider` to `NotifierProvider`
- [ ] Review all providers using `family` modifier

### During Migration

- [ ] Update dependencies to Riverpod 3.0
- [ ] Run `flutter pub get`
- [ ] Fix breaking changes:
  - [ ] Move legacy providers to `import 'package:flutter_riverpod/legacy.dart'`
  - [ ] Convert `FamilyNotifier` to constructor parameters
  - [ ] Replace `AutoDispose*` with base classes
  - [ ] Update `ProviderObserver` implementations
  - [ ] Wrap `try-catch` error handling with `ProviderException`
  
### Post-Migration

- [ ] Review generated provider names (check for stripped suffixes)
- [ ] Configure retry strategy if needed
- [ ] Test all async operations
- [ ] Update tests to use `ProviderContainer`
- [ ] Run full test suite

### Recommended Refactoring

- [ ] Convert remaining `StateProvider` to `Notifier`
- [ ] Convert `StateNotifierProvider` to `AsyncNotifier`
- [ ] Simplify class names (remove "Notifier" suffix)
- [ ] Add Freezed models for complex state
- [ ] Implement optimistic updates where appropriate

---

## Quick Reference

### ref Methods

| Method | Use Case | Rebuilds Widget? |
|--------|----------|------------------|
| `ref.watch()` | Read state in build() | ✅ Yes |
| `ref.read()` | One-time access (callbacks) | ❌ No |
| `ref.listen()` | Side effects (SnackBar, navigation) | ❌ No |

### Provider Types

| Type | Use Case | Example |
|------|----------|---------|
| `@riverpod class X extends _$X` (Notifier) | Sync state | Counter, filter, form state |
| `@riverpod class X extends _$X` (AsyncNotifier) | Async state | API calls, DB queries |
| `@riverpod Type function(Ref ref)` | Dependency injection | Repository, service |

### AsyncValue Methods

| Method | Description | Returns |
|--------|-------------|---------|
| `.when()` | Handle all states | Required type |
| `.maybeWhen()` | Handle specific states | Required type + orElse |
| `.whenData()` | Handle only data | Nullable |
| `.value` | Get data | Nullable (safe) |
| `.requireValue` | Get data | Non-null (throws on loading/error) |
| `.hasValue` | Check if data exists | bool |
| `.hasError` | Check if error exists | bool |
| `.isLoading` | Check if loading | bool |

---

## Additional Resources

- [Official Riverpod 3.0 Docs](https://riverpod.dev/docs/whats_new)
- [Migration Guide](https://riverpod.dev/docs/3.0_migration)
- [Mutations (Experimental)](https://riverpod.dev/ko/docs/concepts2/mutations)
- [riverpod_generator Package](https://pub.dev/packages/riverpod_generator)
- [freezed Package](https://pub.dev/packages/freezed)

---

## Version

**Document Version**: 1.0  
**Riverpod Version**: 3.0+  
**Last Updated**: January 2025

---

*This document should be referenced by AI Agents when implementing Riverpod-based state management in Flutter applications.*
