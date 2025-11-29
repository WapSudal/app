/// 사용자 역할 타입
///
/// 앱에서 지원하는 세 가지 사용자 역할:
/// - [generalUser]: 일반 사용자 - 스스로 정보를 관리
/// - [guardian]: 가족 및 보호자 - 지인의 건강을 관찰하고 도움
/// - [doctor]: 주치의 - 지정 환자들을 관리
enum UserRole {
  /// 일반 사용자
  generalUser,

  /// 가족 및 보호자
  guardian,

  /// 주치의
  doctor,
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
    }
  }
}
