import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// 인증 Repository 구현체
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<AuthUserEntity> signInWithGoogle() {
    return _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }

  @override
  Future<AuthUserEntity> switchAccount() {
    return _remoteDataSource.switchAccount();
  }

  @override
  Future<AuthUserEntity?> getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Stream<AuthUserEntity?> authStateChanges() {
    return _remoteDataSource.authStateChanges();
  }
}
