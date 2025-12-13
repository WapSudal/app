import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/secure_storage_provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../repositories/auth_repository_impl.dart';

part 'auth_data_providers.g.dart';

/// FirebaseAuth 인스턴스 Provider
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

/// AuthRemoteDataSource Provider
@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(
    firebaseAuth: ref.watch(firebaseAuthProvider),
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
