/// 공유 범위
///
/// 환자 데이터를 보호자/주치의와 공유하는 범위
enum SharingScope {
  /// 전체 공유 - 건강 기록, 위험도 분석, What-if 시뮬레이션 모두 공유
  full,

  /// 요약만 공유 - 위험도 분석 결과와 통계만 공유
  summary,

  /// 알림만 공유 - 고위험 알림만 전송
  alertOnly,
}

/// SharingScope 확장 메서드
extension SharingScopeExtension on SharingScope {
  /// 공유 범위의 표시 이름
  String get displayName {
    switch (this) {
      case SharingScope.full:
        return '전체 공유';
      case SharingScope.summary:
        return '요약만 공유';
      case SharingScope.alertOnly:
        return '알림만 공유';
    }
  }

  /// 공유 범위의 설명
  String get description {
    switch (this) {
      case SharingScope.full:
        return '건강 기록, 위험도 분석, What-if 시뮬레이션 모두 공유';
      case SharingScope.summary:
        return '위험도 분석 결과와 통계만 공유 (상세 건강 기록은 비공개)';
      case SharingScope.alertOnly:
        return '고위험 상태 발생 시 알림만 전송';
    }
  }

  /// 공유되는 항목 목록
  List<String> get includedItems {
    switch (this) {
      case SharingScope.full:
        return [
          '건강 기록 상세 내역',
          '위험도 분석 결과',
          'What-if 시뮬레이션',
          '고위험 알림',
        ];
      case SharingScope.summary:
        return [
          '위험도 분석 결과',
          '통계 요약',
          '고위험 알림',
        ];
      case SharingScope.alertOnly:
        return [
          '고위험 알림',
        ];
    }
  }

  /// 건강 기록 접근 가능 여부
  bool get canAccessHealthRecords => this == SharingScope.full;

  /// 위험도 분석 접근 가능 여부
  bool get canAccessRiskAnalysis =>
      this == SharingScope.full || this == SharingScope.summary;

  /// What-if 시뮬레이션 접근 가능 여부
  bool get canAccessWhatIf => this == SharingScope.full;

  /// 알림 수신 가능 여부
  bool get canReceiveAlerts => true; // 모든 범위에서 알림은 받을 수 있음

  /// 특정 범위 이상인지 확인
  bool isAtLeast(SharingScope requiredScope) {
    const scopeOrder = {
      SharingScope.alertOnly: 0,
      SharingScope.summary: 1,
      SharingScope.full: 2,
    };

    return scopeOrder[this]! >= scopeOrder[requiredScope]!;
  }
}
