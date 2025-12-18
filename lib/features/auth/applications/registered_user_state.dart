import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enums/user_role.dart';
import '../../../core/domain/entities/user_entity.dart';

part 'registered_user_state.freezed.dart';

/// 등록된 사용자 상태
///
/// 앱 전역에서 서버에 가입 완료된 사용자 정보를 관리
///
/// Note: 가입/등록 작업의 isLoading과 errorMessage는 confirmRoleMutation으로 분리됨
@freezed
abstract class RegisteredUserState with _$RegisteredUserState {
  const factory RegisteredUserState({
    /// 서버 가입 완료된 사용자 정보 (null이면 미가입)
    UserEntity? user,

    /// 초기화 중 여부 (앱 시작 시 저장된 사용자 로드 중)
    @Default(true) bool isInitializing,
  }) = _RegisteredUserState;
}

// ==================== Extensions ====================

extension RegisteredUserStateX on RegisteredUserState {
  /// 가입 완료 여부
  bool get isRegistered => user != null;

  /// 현재 사용자 역할 (미가입이면 null)
  UserRole? get role => user?.role;

  /// 표시 이름 (미가입이면 '사용자')
  String get displayName => user?.displayName ?? '사용자';

  /// 이메일 (미가입이면 빈 문자열)
  String get email => user?.email ?? '';

  // ==================== Permission Shortcuts ====================

  /// 환자 관리 권한 (의료인만)
  bool get canManagePatients => user?.canManagePatients ?? false;

  /// 보호자 기능 접근 권한 (보호자만)
  bool get canAccessGuardianFeatures =>
      user?.canAccessGuardianFeatures ?? false;

  /// 본인 건강 관리 권한 (일반 사용자만)
  bool get canManageOwnHealth => user?.canManageOwnHealth ?? false;
}
