import '../../../../core/enums/user_role.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// 사용자 가입 완료 UseCase
///
/// Firebase Auth 로그인 후 역할 선택을 통해 서버에 가입 요청
class RegisterUserUseCase {
  final UserRepository _repository;

  RegisterUserUseCase(this._repository);

  /// 사용자 가입 실행
  ///
  /// - [uid]: Firebase UID
  /// - [email]: 사용자 이메일
  /// - [displayName]: 표시 이름
  /// - [photoUrl]: 프로필 이미지 URL
  /// - [role]: 선택된 역할
  Future<UserEntity> call({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    required UserRole role,
  }) {
    return _repository.registerUser(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      role: role,
    );
  }
}
