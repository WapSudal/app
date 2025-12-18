import '../../../../core/domain/entity/auth_user_entity.dart';

/// 인증 Repository 인터페이스
abstract class AuthRepository {
  /// Google 계정으로 로그인
  ///
  /// 성공 시 [AuthUserEntity] 반환, 실패 시 Exception throw
  Future<AuthUserEntity> signInWithGoogle();

  /// 로그아웃
  ///
  /// Firebase Auth 및 Google Sign-In 모두 로그아웃
  Future<void> signOut();

  /// 계정 전환
  ///
  /// 기존 계정 로그아웃 후 Google 계정 선택 UI 표시
  /// 성공 시 [AuthUserEntity] 반환, 실패 시 Exception throw
  Future<AuthUserEntity> switchAccount();

  /// 현재 로그인된 사용자 정보 조회
  ///
  /// 로그인되지 않은 경우 null 반환
  Future<AuthUserEntity?> getCurrentUser();

  /// 인증 상태 변경 스트림
  ///
  /// 로그인/로그아웃 시 사용자 정보 또는 null emit
  Stream<AuthUserEntity?> authStateChanges();

  /// 계정 삭제
  ///
  /// Firebase Auth 계정 삭제 (requires-recent-login 예외 발생 가능)
  Future<void> deleteAccount();

  /// 재인증 후 계정 삭제
  ///
  /// Google 재로그인 후 계정 삭제 수행
  Future<void> reauthenticateAndDelete();
}
