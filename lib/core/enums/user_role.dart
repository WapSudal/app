/// 사용자 역할 타입
///
/// 앱에서 지원하는 네 가지 사용자 역할:
/// - [generalUser]: 일반 사용자 - 스스로 정보를 관리
/// - [guardian]: 가족 및 보호자 - 지인의 건강을 관찰하고 도움
/// - [doctor]: 주치의 - 지정 환자들을 관리
/// - [admin]: 관리자 - 시스템 및 콘텐츠 관리
enum UserRole {
  /// 일반 사용자
  generalUser,

  /// 가족 및 보호자
  guardian,

  /// 주치의
  doctor,

  /// 관리자
  admin,
}

/// UserRole 확장 메서드
extension UserRoleExtension on UserRole {
  /// 역할의 표시 이름
  String get displayName {
    switch (this) {
      case UserRole.generalUser:
        return '일반 사용자';
      case UserRole.guardian:
        return '가족 및 보호자';
      case UserRole.doctor:
        return '주치의';
      case UserRole.admin:
        return '관리자';
    }
  }

  /// 역할의 설명
  String get description {
    switch (this) {
      case UserRole.generalUser:
        return '스스로 정보를 관리할게요';
      case UserRole.guardian:
        return '지인의 건강을 관찰하고 도와줄게요';
      case UserRole.doctor:
        return '지정 환자들을 관리하고 도와줄게요';
      case UserRole.admin:
        return '시스템과 콘텐츠를 관리할게요';
    }
  }

  /// 권한 관련 플래그

  /// 환자 목록 관리 가능 여부 (주치의, 보호자)
  bool get canManagePatients =>
      this == UserRole.doctor || this == UserRole.guardian;

  /// 보호자 기능 접근 가능 여부 (보호자 전용)
  bool get canAccessGuardianFeatures => this == UserRole.guardian;

  /// 자신의 건강 정보 관리 가능 여부 (일반 사용자, 보호자)
  bool get canManageOwnHealth =>
      this == UserRole.generalUser || this == UserRole.guardian;

  /// 관리자 기능 접근 가능 여부 (관리자 전용)
  bool get isAdmin => this == UserRole.admin;

  /// 건강 기록 읽기 전용 여부 (주치의, 보호자는 읽기만 가능)
  bool get isHealthRecordReadOnly =>
      this == UserRole.doctor || this == UserRole.guardian;
}
