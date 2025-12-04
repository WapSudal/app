import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/user_role.dart';

part 'user_entity.freezed.dart';

/// 가입 완료된 사용자 엔티티
///
/// Firebase Auth 로그인 후 역할 선택을 통해 서버에 가입이 완료된 사용자 정보
@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    /// Firebase UID
    required String uid,

    /// 사용자 이메일
    required String email,

    /// 표시 이름
    String? displayName,

    /// 프로필 이미지 URL
    String? photoUrl,

    /// 선택된 역할
    required UserRole role,

    /// 가입 완료 시각
    required DateTime registeredAt,
  }) = _UserEntity;

  const UserEntity._();

  // ==================== Permission Flags ====================

  /// 환자 목록 관리 가능 여부 (주치의 전용)
  bool get canManagePatients => role.canManagePatients;

  /// 보호자 기능 접근 가능 여부 (보호자 전용)
  bool get canAccessGuardianFeatures => role.canAccessGuardianFeatures;

  /// 자신의 건강 정보 관리 가능 여부 (일반 사용자, 보호자)
  bool get canManageOwnHealth => role.canManageOwnHealth;
}
