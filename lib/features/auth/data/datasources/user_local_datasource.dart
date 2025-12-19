import '../../../../core/domain/entities/user_entity.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(UserEntity user);
  Future<UserEntity?> getCurrentUser();
  Future<List<UserEntity>> getAllUsers();
  Future<bool> hasCurrentUser();
  Future<void> clearUsers();
}
