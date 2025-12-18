import '../repositories/user_repository.dart';

/// 가입 여부 확인 UseCase
///
/// Firebase Auth 로그인은 됐지만 역할 선택(가입)이 완료되지 않은 상태를 확인
class CheckRegistrationUseCase {
  final UserRepository _repository;

  CheckRegistrationUseCase(this._repository);

  /// 가입 여부 확인 실행
  ///
  /// true: 가입 완료, false: 역할 선택 필요
  Future<bool> call() {
    return _repository.isRegistered();
  }
}
