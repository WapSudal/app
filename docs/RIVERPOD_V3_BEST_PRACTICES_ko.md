# Riverpod 3.0 모범 사례 가이드

> **대상 아키텍처**: MVVM + 기능 우선(Feature-First) 클린 아키텍처  
> **상태 관리**: Riverpod 3.0  
> **내비게이션**: go_router  
> **불변성**: freezed  
> **코드 생성**: riverpod_generator + build_runner

---

## 목차

1. [Riverpod 3.0의 주요 변경 사항](#riverpod-30의-주요-변경-사항)
2. [Provider 명명 규칙](#provider-명명-규칙)
3. [핵심 원칙](#핵심-원칙)
4. [AsyncNotifier & AsyncValue](#asyncnotifier--asyncvalue)
5. [페이지 상태 관리 패턴](#페이지-상태-관리-패턴)
6. [뮤테이션 (실험적 기능)](#뮤테이션-실험적-기능)
7. [기능 우선(Feature-First) 프로젝트 구조](#기능-우선feature-first-프로젝트-구조)
8. [오류 처리](#오류-처리)
9. [테스팅](#테스팅)
10. [흔히 저지르는 실수](#흔히-저지르는-실수)
11. [마이그레이션 체크리스트](#마이그레이션-체크리스트)

---

## Riverpod 3.0의 주요 변경 사항

### 1. 자동 재시도 (기본적으로 활성화)

이제 Provider는 성공할 때까지 실패 시 자동으로 재시도합니다.

```dart
// 전역적으로 비활성화
void main() {
  runApp(
    ProviderScope(
      retry: (retryCount, error) => null, // 절대 재시도 안 함
      child: MyApp(),
    ),
  );
}

// Provider별로 비활성화 (riverpod_generator 사용)
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

### 2. 레거시 Provider 이동

`StateProvider`, `StateNotifierProvider`, `ChangeNotifierProvider`는 이제 레거시(legacy)가 되었습니다.

```dart
// ❌ 이전 방식 (이제 레거시)
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ 레거시 Provider를 꼭 사용해야 한다면
import 'package:flutter_riverpod/legacy.dart';

// ✅✅ 권장: Notifier를 대신 사용
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++;
}
```

### 3. Provider 명명 규칙 변경

**기본 동작**: "Notifier"로 끝나는 클래스 이름은 접미사가 자동으로 제거됩니다.

```dart
// 클래스 이름: UserNotifier
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  User build() => User();
}

// 생성된 Provider 이름:
// Riverpod 2.x: userNotifierProvider
// Riverpod 3.0: userProvider ✅
```

**설정** (build.yaml):

```yaml
targets:
  $default:
    builders:
      riverpod_generator:
        options:
          provider_name_strip_pattern: "Notifier$"  # 기본값
          provider_name_suffix: "Provider"           # 기본값
```

**권장 명명법**:

```dart
// ✅ 간단하고 깔끔한 이름 (권장)
@riverpod
class User extends _$User { }           // → userProvider

@riverpod
class UserRepository extends _$UserRepository { } // → userRepositoryProvider

// ❌ 중복되는 접미사 (권장하지 않음)
@riverpod
class UserNotifier extends _$UserNotifier { }     // → userProvider (Notifier 제거됨)
```

### 4. Family Variant 제거

이제 파라미터는 build 메서드 대신 생성자를 통해 전달됩니다.

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
  UserDetail(this.userId);  // 생성자 파라미터
  final String userId;
  
  @override
  Future<User> build() async {  // 파라미터 없음
    return fetchUser(userId);
  }
}
```

### 5. AutoDispose 인터페이스 통합

더 이상 별도의 `AutoDisposeNotifier`, `AutoDisposeAsyncNotifier` 등이 없습니다.

```dart
// ✅ 그냥 Notifier를 사용 (3.0에서는 기본적으로 autoDispose)
@riverpod
class User extends _$User {
  @override
  UserModel build() => UserModel();
}

// 상태를 유지하려면
@Riverpod(keepAlive: true)
class GlobalSettings extends _$GlobalSettings {
  @override
  Settings build() => Settings();
}
```

### 6. 오류 래핑(Wrapping)

Provider 실패는 이제 `ProviderException`으로 래핑됩니다.

```dart
// ❌ 이전
try {
  await ref.read(loginProvider.future);
} on AuthException {
  // 직접 처리
}

// ✅ 새로운 방식
try {
  await ref.read(loginProvider.future);
} on ProviderException catch (e) {
  if (e.exception is AuthException) {
    // 원본 오류 추출
  }
}

// ✅✅ 권장: AsyncValue 사용 (래핑 없음)
final loginState = ref.watch(loginProvider);
loginState.when(
  data: (_) => ...,
  error: (error, _) {
    if (error is AuthException) { } // 직접 접근
  },
  loading: () => ...,
);
```

---

## Provider 명명 규칙

### 클래스 vs Provider 이름

```dart
// 패턴: [Feature][Type]
@riverpod
class User extends _$User { }                    // → userProvider
@riverpod
class UserRepository extends _$UserRepository { } // → userRepositoryProvider
@riverpod
class ProductList extends _$ProductList { }       // → productListProvider
@riverpod
class CartTotal extends _$CartTotal { }           // → cartTotalProvider
```

### 기본 명명 규칙 재정의

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
// 또는 Provider별로 재정의
@Riverpod(name: 'currentUser')
class UserState extends _$UserState { }  // → currentUserProvider
```

---

## 핵심 원칙

### 두 가지 Provider 규칙

**99%의 사용 사례에 대해 두 가지 유형의 Provider만 사용하세요:**

1. **AsyncNotifierProvider** - 비동기 상태용 (API 호출, DB 쿼리)
2. **Provider** - 의존성 주입용 (리포지토리, 서비스)

```dart
// ✅ 비동기 상태
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async => fetchProducts();
}

// ✅ 의존성 주입
@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepositoryImpl(api: ref.watch(apiClientProvider));
}
```

### 관심사 분리

**UI 파일은 위젯을 렌더링하는 역할만 해야 합니다. 비즈니스 로직은 Provider에 있어야 합니다.**

```dart
// ❌ 위젯에 비즈니스 로직이 있는 경우
class ProductPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final products = await http.get('api/products'); // ❌ 안됨!
        // ... 처리 로직
      },
      child: Text('가져오기'),
    );
  }
}

// ✅ Provider에 로직이 있는 경우
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
      child: Text('가져오기'),
    );
  }
}
```

---

## AsyncNotifier & AsyncValue

### AsyncNotifier 기본

**AsyncNotifier**는 내장된 로딩/오류 처리 기능으로 비동기 상태를 관리합니다.

```dart
@riverpod
class User extends _$User {
  // build()는 자동으로 오류를 잡아 AsyncError로 변환합니다.
  @override
  Future<UserModel> build(String userId) async {
    return await ref.read(userRepositoryProvider).getUser(userId);
  }
  
  // 커스텀 메서드는 AsyncValue.guard가 필요합니다.
  Future<void> updateName(String newName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(userRepositoryProvider).updateName(userId, newName);
      return build(); // 새로고침
    });
  }
}
```

### AsyncValue 상태

AsyncValue는 3가지 상태를 나타냅니다:

```dart
sealed class AsyncValue<T> {
  AsyncData<T>    // 데이터가 있음
  AsyncLoading<T> // 로딩 중
  AsyncError<T>   // 오류 발생
}
```

### AsyncValue 메서드

#### 1. when() - 모든 상태 처리 (필수)

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final userState = ref.watch(userProvider);
  
  return userState.when(
    data: (user) => Text('안녕하세요 ${user.name}'),
    loading: () => CircularProgressIndicator(),
    error: (error, stack) => Text('오류: $error'),
  );
}
```

#### 2. maybeWhen() - 특정 상태 처리

```dart
return userState.maybeWhen(
  error: (error, _) => ErrorWidget(error),
  orElse: () => Text('로딩 중이거나 데이터를 보여주는 중...'),
);
```

#### 3. whenData() - 데이터만 처리

```dart
return userState.whenData(
  (user) => Text('이름: ${user.name}'),
);
// 로딩/오류 시 null 반환
```

#### 4. map() - 상태에 따라 변환

```dart
return userState.map(
  data: (AsyncData<User> data) => UserCard(user: data.value),
  loading: (AsyncLoading loading) => LoadingSpinner(),
  error: (AsyncError error) => ErrorDisplay(error: error.error),
);
```

### AsyncValue 속성

```dart
final userState = ref.watch(userProvider);

// 상태 확인
bool hasValue = userState.hasValue;     // 데이터가 있는가?
bool hasError = userState.hasError;     // 오류가 있는가?
bool isLoading = userState.isLoading;   // 로딩 중인가?

// 값 접근 (nullable)
User? user = userState.value;           // 로딩/오류 시 null
Object? error = userState.error;        // 데이터/로딩 시 null

// 값 접근 (데이터가 아니면 예외 발생)
User user = userState.requireValue;     // ⚠️ 로딩/오류 시 StateError 발생
```

### AsyncValue.guard() - 자동 오류 처리

**guard()는 try-catch를 자동으로 래핑합니다:**

```dart
// ❌ 수동 try-catch (장황함)
Future<void> updateUser(User user) async {
  try {
    state = const AsyncValue.loading();
    final updated = await repository.updateUser(user);
    state = AsyncValue.data(updated);
  } catch (error, stack) {
    state = AsyncValue.error(error, stack);
  }
}

// ✅ guard 사용 (깔끔함)
Future<void> updateUser(User user) async {
  state = const AsyncValue.loading();
  state = await AsyncValue.guard(() async {
    return await repository.updateUser(user);
  });
}
```

**guard 사용 시점:**

```dart
@riverpod
class User extends _$User {
  @override
  Future<UserModel> build() async {
    // ❌ build()에서는 guard 사용 안 함 - 자동으로 처리됨
    return fetchUser();
  }
  
  Future<void> refresh() async {
    // ✅ 커스텀 메서드에서는 guard 사용
    state = await AsyncValue.guard(() => build());
  }
}
```

### value vs requireValue

```dart
final AsyncValue<User> userState = ref.watch(userProvider);

// ✅ 안전함: 로딩/오류 시 null 반환
User? user = userState.value;
if (user != null) {
  print(user.name);
}

// ⚠️ 안전하지 않음: 로딩/오류 시 StateError 발생
User user = userState.requireValue;  // hasValue == true일 때만 사용

// ✅✅ 권장: when() 사용
userState.when(
  data: (user) => print(user.name),
  loading: () => print('로딩 중...'),
  error: (e, _) => print('오류: $e'),
);
```

---

## 페이지 상태 관리 패턴

### 패턴 1: 페이지 ViewModel을 위한 AsyncNotifier

**적합한 경우: API 호출, 복잡한 비동기 로직이 있는 페이지**

```dart
// 1. Freezed로 상태 모델 정의
@freezed
class UserPageState with _$UserPageState {
  const factory UserPageState({
    required UserModel? user,
    @Default(false) bool isEditing,
    @Default('') String searchQuery,
  }) = _UserPageState;
}

// 2. 페이지 상태를 위한 AsyncNotifier 생성
@riverpod
class UserPage extends _$UserPage {
  @override
  Future<UserPageState> build(String userId) async {
    final user = await ref.read(userRepositoryProvider).getUser(userId);
    return UserPageState(user: user);
  }
  
  // 비즈니스 로직 메서드
  Future<void> updateUserName(String newName) async {
    final current = state.value;
    if (current == null) return;
    
    // 낙관적 업데이트
    state = AsyncValue.data(
      current.copyWith(
        user: current.user?.copyWith(name: newName),
      ),
    );
    
    try {
      await ref.read(userRepositoryProvider).updateName(userId, newName);
    } catch (e) {
      // 오류 시 롤백
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

// 3. UI에서 상태 소비
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

### 패턴 2: 로컬/동기 상태를 위한 Notifier

**적합한 경우: UI 전용 상태 (필터, 탭, API 호출 없는 폼)**

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
          title: Text('다크 모드'),
          value: settings.isDarkMode,
          onChanged: (_) => ref.read(settingsPageProvider.notifier).toggleDarkMode(),
        ),
      ],
    );
  }
}
```

### 패턴 3: 낙관적 업데이트

```dart
@riverpod
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async {
    return ref.read(todoRepositoryProvider).fetchAll();
  }
  
  Future<void> toggleTodo(String id) async {
    final currentList = state.value ?? [];
    
    // 1. UI 즉시 업데이트 (낙관적)
    state = AsyncValue.data(
      currentList.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(completed: !todo.completed);
        }
        return todo;
      }).toList(),
    );
    
    // 2. 백그라운드에서 API 호출
    try {
      await ref.read(todoRepositoryProvider).toggle(id);
    } catch (e) {
      // 3. 실패 시 롤백
      state = await AsyncValue.guard(() => build());
      rethrow;
    }
  }
}
```

### 패턴 4: 이전 데이터를 사용한 당겨서 새로고침

```dart
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    return _fetchProducts();
  }
  
  Future<void> refresh() async {
    // 새로고침 중 이전 데이터 유지
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

## 뮤테이션 (실험적 기능)

**📚 공식 문서**: [Riverpod v3 뮤테이션](https://riverpod.dev/ko/docs/concepts2/mutations)  
**📄 상세 가이드**: [RIVERPOD_V3_MUTATIONS.md](RIVERPOD_V3_MUTATIONS.md)

### 뮤테이션이란?

**뮤테이션**은 Riverpod v3의 실험적 객체로, 상태 변경에 대한 UI 반응을 처리하기 위해 설계되었습니다. 특히 폼 제출, 로딩 인디케이터가 있는 API 호출 및 기타 일회성 작업에 유용합니다.

**⚠️ 실험적 상태**: 뮤테이션 API는 주요 버전 업데이트 없이 호환성이 깨지는 변경이 있을 수 있습니다. 프로덕션 환경에서는 주의해서 사용하세요.

### 뮤테이션 vs AsyncNotifier

| 기능 | AsyncNotifier | 뮤테이션 |
|---|---|---|
| **목적** | 영구적인 상태 관리 | 일회성 작업 처리 |
| **상태 오염** | UI 관련 문제로 상태를 오염시킬 수 있음 | UI 상태를 분리하여 유지 |
| **최적 사용** | 영구적으로 필요한 데이터 | 폼 제출, 삭제 작업 |
| **리셋 동작** | 수동 | 완료 시 자동 리셋 |
| **로딩 상태** | AsyncValue의 일부 | 내장된 MutationPending |

### 뮤테이션 사용 시점

✅ **뮤테이션 사용 사례:**
- 로딩/오류 피드백이 있는 폼 제출
- UI 피드백이 있는 삭제 작업
- 주 상태에 영향을 미치지 않는 일회성 API 호출
- 임시 로딩/오류 상태가 필요한 작업

❌ **AsyncNotifier 사용 사례:**
- 데이터 가져오기 및 표시
- 영구적인 상태 관리
- 주 데이터 모델을 업데이트하는 작업

### 빠른 예제

```dart
// 뮤테이션 정의
final submitForm = Mutation<FormResult>();

// 위젯에서 사용
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
          : Text('제출'),
    );
  }
}
```

> **📖 상세한 사용법, 패턴 및 전체 예제는 [RIVERPOD_V3_MUTATIONS.md](RIVERPOD_V3_MUTATIONS.md)를 참조하세요**

---

## 기능 우선(Feature-First) 프로젝트 구조

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

### Provider 구성

```dart
// ✅ 리포지토리 레이어 (Provider)
@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepositoryImpl(
    api: ref.watch(apiClientProvider),
    storage: ref.watch(storageProvider),
  );
}

// ✅ 상태 레이어 (AsyncNotifier)
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    return ref.read(productRepositoryProvider).fetchAll();
  }
}

// ✅ UI 전용 상태 (Notifier)
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

## 오류 처리

### 패턴 1: 오류 시 SnackBar 표시 (ref.listen)

```dart
class ProductPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 오류를 수신하고 SnackBar 표시
    ref.listen(productListProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    
    final productsState = ref.watch(productListProvider);
    
    // 오류가 발생했더라도 제품 표시 (이전 데이터 사용)
    final products = productsState.valueOrNull ?? [];
    
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, idx) => ProductCard(products[idx]),
    );
  }
}
```

### 패턴 2: 인라인 오류 표시

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

### 패턴 3: 커스텀 오류 유형

```dart
// 커스텀 오류 정의
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

// UI에서 처리
ref.listen(loginProvider, (previous, next) {
  next.whenOrNull(
    error: (error, _) {
      if (error is AuthException) {
        // 인증 관련 오류 표시
      } else if (error is NetworkException) {
        // 네트워크 오류 표시
      }
    },
  );
});
```

---

## 테스팅

### AsyncNotifier 테스트

```dart
void main() {
  test('UserPage가 사용자 데이터를 올바르게 로드하는지 테스트', () async {
    final container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(
          MockUserRepository(),
        ),
      ],
    );
    
    // 비동기 작업 기다리기
    final userPage = await container.read(
      userPageProvider('user123').future,
    );
    
    expect(userPage.user?.id, 'user123');
    expect(userPage.isEditing, false);
    
    container.dispose();
  });
  
  test('UserPage가 업데이트를 올바르게 처리하는지 테스트', () async {
    final container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(
          MockUserRepository(),
        ),
      ],
    );
    
    // 초기 상태 로드
    await container.read(userPageProvider('user123').future);
    
    // 이름 업데이트
    await container
        .read(userPageProvider('user123').notifier)
        .updateUserName('New Name');
    
    final updatedState = container.read(userPageProvider('user123')).value;
    expect(updatedState?.user?.name, 'New Name');
    
    container.dispose();
  });
}
```

### ProviderContainer로 테스트

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
  
  test('ProductList가 제품을 가져오는지 테스트', () async {
    final products = await container.read(productListProvider.future);
    expect(products.length, greaterThan(0));
  });
}
```

---

## 흔히 저지르는 실수

### ❌ 하지 말 일: 레거시 Provider 사용

```dart
// ❌ StateProvider 사용하지 말 것
final counterProvider = StateProvider<int>((ref) => 0);

// ✅ 대신 Notifier 사용
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++;
}
```

### ❌ 하지 말 일: 위젯에 비즈니스 로직 넣기

```dart
// ❌ 나쁨
class ProductPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final products = await http.get('api/products'); // ❌
        // ... 더 많은 로직
      },
      child: Text('가져오기'),
    );
  }
}

// ✅ 좋음 - 로직은 Provider에
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    return ref.read(productRepositoryProvider).fetchProducts();
  }
}
```

### ❌ 하지 말 일: 콜백에서 ref.watch 사용

```dart
// ❌ 나쁨
ElevatedButton(
  onPressed: () {
    final counter = ref.watch(counterProvider); // ❌ 콜백에서 watch 사용 금지
    print(counter);
  },
  child: Text('로그'),
)

// ✅ 좋음
ElevatedButton(
  onPressed: () {
    final counter = ref.read(counterProvider); // ✅ 일회성 접근에는 read 사용
    print(counter);
  },
  child: Text('로그'),
)
```

### ❌ 하지 말 일: requireValue 안전하지 않게 사용

```dart
// ❌ 안전하지 않음 - 로딩/오류 시 예외 발생
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(userProvider).requireValue; // ❌ 로딩 시 충돌!
  return Text(user.name);
}

// ✅ 안전함 - when() 사용
Widget build(BuildContext context, WidgetRef ref) {
  return ref.watch(userProvider).when(
    data: (user) => Text(user.name),
    loading: () => CircularProgressIndicator(),
    error: (e, _) => Text('오류'),
  );
}
```

### ❌ 하지 말 일: build()에서 AsyncValue.guard 사용

```dart
@riverpod
class User extends _$User {
  @override
  Future<UserModel> build() async {
    // ❌ 불필요함 - build()는 자동으로 오류를 잡음
    return await AsyncValue.guard(() => fetchUser());
    
    // ✅ 그냥 평소처럼 throw
    return await fetchUser();
  }
}
```

### ❌ 하지 말 일: 상태 직접 변경

```dart
// ❌ 나쁨 - 상태 변경
@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() => [];
  
  void addTodo(Todo todo) {
    state.add(todo); // ❌ 상태를 직접 변경!
  }
}

// ✅ 좋음 - 불변 업데이트
@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() => [];
  
  void addTodo(Todo todo) {
    state = [...state, todo]; // ✅ 새 리스트 생성
  }
}
```

---

## 마이그레이션 체크리스트

### 마이그레이션 전

- [ ] 최신 Riverpod 2.x로 업그레이드
- [ ] `riverpod_generator` 및 `riverpod_lint` 활성화
- [ ] `StateNotifierProvider`를 `NotifierProvider`로 변환
- [ ] `family` 수정자를 사용하는 모든 Provider 검토

### 마이그레이션 중

- [ ] 의존성을 Riverpod 3.0으로 업데이트
- [ ] `flutter pub get` 실행
- [ ] 주요 변경 사항 수정:
  - [ ] 레거시 Provider를 `import 'package:flutter_riverpod/legacy.dart'`로 이동
  - [ ] `FamilyNotifier`를 생성자 파라미터로 변환
  - [ ] `AutoDispose*`를 기본 클래스로 교체
  - [ ] `ProviderObserver` 구현 업데이트
  - [ ] `try-catch` 오류 처리를 `ProviderException`으로 래핑
  
### 마이그레이션 후

- [ ] 생성된 Provider 이름 검토 (제거된 접미사 확인)
- [ ] 필요한 경우 재시도 전략 구성
- [ ] 모든 비동기 작업 테스트
- [ ] 테스트를 `ProviderContainer`를 사용하도록 업데이트
- [ ] 전체 테스트 스위트 실행

### 권장 리팩토링

- [ ] 남은 `StateProvider`를 `Notifier`로 변환
- [ ] `StateNotifierProvider`를 `AsyncNotifier`로 변환
- [ ] 클래스 이름 단순화 ("Notifier" 접미사 제거)
- [ ] 복잡한 상태에 Freezed 모델 추가
- [ ] 적절한 곳에 낙관적 업데이트 구현

---

## 빠른 참조

### ref 메서드

| 메서드 | 사용 사례 | 위젯 재빌드? |
|---|---|---|
| `ref.watch()` | build()에서 상태 읽기 | ✅ 예 |
| `ref.read()` | 일회성 접근 (콜백) | ❌ 아니요 |
| `ref.listen()` | 부수 효과 (SnackBar, 내비게이션) | ❌ 아니요 |

### Provider 유형

| 유형 | 사용 사례 | 예시 |
|---|---|---|
| `@riverpod class X extends _$X` (Notifier) | 동기 상태 | 카운터, 필터, 폼 상태 |
| `@riverpod class X extends _$X` (AsyncNotifier) | 비동기 상태 | API 호출, DB 쿼리 |
| `@riverpod Type function(Ref ref)` | 의존성 주입 | 리포지토리, 서비스 |

### AsyncValue 메서드

| 메서드 | 설명 | 반환값 |
|---|---|---|
| `.when()` | 모든 상태 처리 | 필수 타입 |
| `.maybeWhen()` | 특정 상태 처리 | 필수 타입 + orElse |
| `.whenData()` | 데이터만 처리 | Nullable |
| `.value` | 데이터 가져오기 | Nullable (안전) |
| `.requireValue` | 데이터 가져오기 | Non-null (로딩/오류 시 예외 발생) |
| `.hasValue` | 데이터 존재 여부 확인 | bool |
| `.hasError` | 오류 존재 여부 확인 | bool |
| `.isLoading` | 로딩 중인지 확인 | bool |

---

## 추가 자료

- [공식 Riverpod 3.0 문서](https://riverpod.dev/docs/whats_new)
- [마이그레이션 가이드](https://riverpod.dev/docs/3.0_migration)
- [뮤테이션 (실험적 기능)](https://riverpod.dev/ko/docs/concepts2/mutations)
- [riverpod_generator 패키지](https://pub.dev/packages/riverpod_generator)
- [freezed 패키지](https://pub.dev/packages/freezed)

---

## 버전

**문서 버전**: 1.0  
**Riverpod 버전**: 3.0+  
**마지막 업데이트**: 2025년 1월

---

*이 문서는 AI Agents가 Flutter 애플리케이션에서 Riverpod 기반 상태 관리를 구현할 때 참조해야 합니다.*
