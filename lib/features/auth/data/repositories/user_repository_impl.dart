import '../../../../core/enums/user_role.dart';
import '../../../../core/domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource_impl.dart';

/// UserRepository 구현체
///
/// Mock 데이터 소스를 사용하여 사용자 가입/조회 기능 구현
/// 실제 API 연동 시 RemoteDataSource 추가하여 교체 예정
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSourceImpl _localDataSource;

  UserRepositoryImpl({required UserLocalDataSourceImpl localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<UserEntity> registerUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    required UserRole role,
  }) async {
    // Mock: 네트워크 지연 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    final user = UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      role: role,
      registeredAt: DateTime.now(),
    );

    // 로컬 저장소에 Mock 데이터 저장
    await _localDataSource.saveUser(user);

    return user;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await _localDataSource.getCurrentUser();
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    return await _localDataSource.getAllUsers();
  }

  @override
  Future<bool> isRegistered() async {
    return await _localDataSource.hasCurrentUser();
  }

  @override
  Future<void> clearUserData() async {
    await _localDataSource.clearUsers();
  }
}
