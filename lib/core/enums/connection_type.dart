/// 연결 유형
///
/// 환자와 다른 사용자 간의 연결 관계 유형
enum ConnectionType {
  /// 보호자 연결
  guardian,

  /// 주치의 연결
  doctor,
}

/// ConnectionType 확장 메서드
extension ConnectionTypeExtension on ConnectionType {
  /// 연결 유형의 표시 이름
  String get displayName {
    switch (this) {
      case ConnectionType.guardian:
        return '보호자';
      case ConnectionType.doctor:
        return '주치의';
    }
  }

  /// 연결 유형의 설명
  String get description {
    switch (this) {
      case ConnectionType.guardian:
        return '환자의 가족 또는 보호자';
      case ConnectionType.doctor:
        return '환자의 주치의';
    }
  }

  /// 연결 요청 시 표시될 메시지
  String get requestMessage {
    switch (this) {
      case ConnectionType.guardian:
        return '보호자로 연결하여 건강 상태를 확인하고자 합니다';
      case ConnectionType.doctor:
        return '주치의로 연결하여 건강 상태를 관리하고자 합니다';
    }
  }
}
