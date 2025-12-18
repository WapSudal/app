/// 연결 상태
///
/// 환자와 보호자/주치의 간의 연결 요청 및 승인 상태
enum ConnectionStatus {
  /// 대기중 - 환자의 승인 대기
  pending,

  /// 수락됨 - 연결이 활성화됨
  accepted,

  /// 거절됨 - 환자가 요청을 거절
  rejected,

  /// 해제됨 - 한쪽이 연결을 끊음
  revoked,
}

/// ConnectionStatus 확장 메서드
extension ConnectionStatusExtension on ConnectionStatus {
  /// 연결 상태의 표시 이름
  String get displayName {
    switch (this) {
      case ConnectionStatus.pending:
        return '대기중';
      case ConnectionStatus.accepted:
        return '연결됨';
      case ConnectionStatus.rejected:
        return '거절됨';
      case ConnectionStatus.revoked:
        return '해제됨';
    }
  }

  /// 연결 상태의 설명
  String get description {
    switch (this) {
      case ConnectionStatus.pending:
        return '환자의 승인을 기다리고 있습니다';
      case ConnectionStatus.accepted:
        return '연결이 활성화되어 정보 공유가 가능합니다';
      case ConnectionStatus.rejected:
        return '환자가 연결 요청을 거절했습니다';
      case ConnectionStatus.revoked:
        return '연결이 해제되었습니다';
    }
  }

  /// 활성 상태 여부
  bool get isActive => this == ConnectionStatus.accepted;

  /// 대기중 여부
  bool get isPending => this == ConnectionStatus.pending;

  /// 종료된 상태 여부 (거절 또는 해제)
  bool get isTerminated =>
      this == ConnectionStatus.rejected || this == ConnectionStatus.revoked;
}
