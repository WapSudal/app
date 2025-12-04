import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// 현재 사용자 정보 조회 UseCase
///
/// 가입 완료된 사용자 정보를 조회
class GetCurrentUserUseCase {
  final UserRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// 현재 사용자 조회 실행
  ///
  /// 가입되지 않은 경우 null 반환
  Future<UserEntity?> call() {
    return _repository.getCurrentUser();
  }
}
