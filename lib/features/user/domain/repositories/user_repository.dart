import '../../../../core/domain/entity/user_entity.dart';
import '../../../../core/enums/user_role.dart';

/// 사용자 Repository 인터페이스
///
/// 사용자 가입/조회 관련 비즈니스 로직을 위한 추상 인터페이스
abstract class UserRepository {
  /// 사용자 가입 완료 (역할 선택 후)
  ///
  /// Firebase Auth 정보와 선택된 역할을 조합하여 서버에 가입 요청
  /// - [uid]: Firebase UID
  /// - [email]: 사용자 이메일
  /// - [displayName]: 표시 이름
  /// - [photoUrl]: 프로필 이미지 URL
  /// - [role]: 선택된 역할
  Future<UserEntity> registerUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    required UserRole role,
  });

  /// 현재 로그인된 사용자 정보 조회
  ///
  /// 가입되지 않은 경우 null 반환
  Future<UserEntity?> getCurrentUser();

  /// 가입 여부 확인
  ///
  /// Firebase Auth로 로그인은 했지만 역할 선택(가입)이 완료되지 않은 경우 false
  Future<bool> isRegistered();

  /// 사용자 정보 삭제 (로그아웃/탈퇴 시)
  Future<void> clearUserData();
}
