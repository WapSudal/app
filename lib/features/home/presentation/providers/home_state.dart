import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/user_role.dart';

part 'home_state.freezed.dart';

/// 홈 화면 상태
///
/// Scenario B 패턴: 역할 정보를 State에 포함하여 권한 플래그로 UI 분기
///
/// Note: 로그아웃 작업의 isLoading과 errorMessage는 signOutMutation으로 분리됨
@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    /// 현재 사용자 역할
    @Default(UserRole.generalUser) UserRole role,

    /// 환자 관리 권한 (의료인만)
    @Default(false) bool canManagePatients,

    /// 보호자 기능 접근 권한 (보호자만)
    @Default(false) bool canAccessGuardianFeatures,

    /// 본인 건강 관리 권한 (일반 사용자만)
    @Default(false) bool canManageOwnHealth,
  }) = _HomeState;

  /// 역할 기반 초기 상태 생성
  factory HomeState.fromRole(UserRole role) {
    return HomeState(
      role: role,
      canManagePatients: role.canManagePatients,
      canAccessGuardianFeatures: role.canAccessGuardianFeatures,
      canManageOwnHealth: role.canManageOwnHealth,
    );
  }
}

// ==================== Extensions ====================

extension HomeStateX on HomeState {
  /// 역할 표시 이름
  String get roleDisplayName => role.displayName;

  /// 역할 설명
  String get roleDescription => role.description;
}
