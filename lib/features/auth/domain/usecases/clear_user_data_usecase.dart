import '../repositories/user_repository.dart';

/// 사용자 데이터 초기화 UseCase
///
/// 로그아웃 시 또는 계정 삭제 시 사용
class ClearUserDataUseCase {
  final UserRepository _repository;

  ClearUserDataUseCase(this._repository);

  /// 사용자 데이터 초기화 실행
  Future<void> call() {
    return _repository.clearUserData();
  }
}
