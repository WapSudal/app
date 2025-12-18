import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/secure_storage_provider.dart';
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/mock_user_local_datasource.dart';
import '../repositories/auth_repository_impl.dart';
import '../repositories/user_repository_impl.dart';

part 'auth_data_providers.g.dart';

// ==================== Auth Providers ====================

/// FirebaseAuth 인스턴스 Provider
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

/// GoogleSignIn 인스턴스 Provider
@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(Ref ref) {
  return GoogleSignIn(scopes: ['email', 'profile']);
}

/// AuthRemoteDataSource Provider
@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
    storageHelper: ref.watch(secureStorageHelperProvider),
  );
}

/// AuthRepository Provider
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
}

// ==================== User Providers ====================

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
