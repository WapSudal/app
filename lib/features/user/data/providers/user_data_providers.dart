import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/user_repository.dart';
import '../datasources/mock_user_local_datasource.dart';
import '../repositories/user_repository_impl.dart';

part 'user_data_providers.g.dart';

/// SharedPreferences 인스턴스 Provider
///
/// main.dart에서 앱 시작 전 override 필요:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final prefs = await SharedPreferences.getInstance();
///   runApp(
///     ProviderScope(
///       overrides: [
///         sharedPreferencesProvider.overrideWithValue(prefs),
///       ],
///       child: const MyApp(),
///     ),
///   );
/// }
/// ```
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main.dart',
  );
}

/// Mock 사용자 로컬 데이터 소스 Provider
@Riverpod(keepAlive: true)
MockUserLocalDataSource mockUserLocalDataSource(Ref ref) {
  return MockUserLocalDataSource(prefs: ref.watch(sharedPreferencesProvider));
}

/// UserRepository Provider
@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(
    localDataSource: ref.watch(mockUserLocalDataSourceProvider),
  );
}
