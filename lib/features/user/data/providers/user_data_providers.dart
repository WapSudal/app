import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/shared_preferences_provider.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/mock_user_local_datasource.dart';
import '../repositories/user_repository_impl.dart';

part 'user_data_providers.g.dart';

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
