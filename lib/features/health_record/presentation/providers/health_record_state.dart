import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../health_record/domain/entities/health_record_entity.dart';

part 'health_record_state.freezed.dart';

/// 기록 탭 화면 상태
@freezed
abstract class HealthRecordState with _$HealthRecordState {
  const factory HealthRecordState({
    /// 건강 기록 목록
    @Default([]) List<HealthRecordEntity> healthRecords,

    /// 선택된 기간 필터 (7일, 30일, 전체)
    @Default(HealthRecordPeriodFilter.week)
    HealthRecordPeriodFilter periodFilter,
  }) = _HealthRecordState;
}

/// 기록 기간 필터
enum HealthRecordPeriodFilter {
  week('7일', 7),
  month('30일', 30),
  all('전체', null);

  const HealthRecordPeriodFilter(this.label, this.days);

  final String label;
  final int? days;
}

/// 건강 상태 레벨 (혈압/혈당 안정성 기준)
enum HealthStatusLevel {
  excellent('아주 좋아요!', '혈압/혈당 변화가 안정적이에요.', '👏', 0xFF71CE6E),
  good('좋아요!', '건강 관리를 잘 하고 계세요.', '💪', 0xFF1E90FF),
  caution('주의가 필요해요', '혈압/혈당 변화가 다소 불안정해요.', '⚠️', 0xFFFF9500),
  warning('관리가 필요해요', '혈압/혈당이 정상 범위를 벗어났어요.', '🩺', 0xFFFF4130);

  const HealthStatusLevel(this.title, this.description, this.emoji, this.color);

  final String title;
  final String description;
  final String emoji;
  final int color;
}

// ==================== Extensions ====================

extension HealthRecordStateX on HealthRecordState {
  /// 데이터 존재 여부
  bool get hasData => healthRecords.isNotEmpty;

  /// 건강 기록 개수
  int get recordCount => healthRecords.length;

  /// 필터링된 기록 (선택된 기간에 따라)
  List<HealthRecordEntity> get filteredRecords {
    if (periodFilter.days == null) {
      return healthRecords;
    }

    final cutoffDate = DateTime.now().subtract(
      Duration(days: periodFilter.days!),
    );

    return healthRecords
        .where((record) => record.recordedAt.isAfter(cutoffDate))
        .toList();
  }

  /// 필터링된 기록 개수
  int get filteredRecordCount => filteredRecords.length;

  /// 평균 수축기 혈압
  int? get averageSystolicBP {
    final records = filteredRecords.where((r) => r.systolicBP != null).toList();
    if (records.isEmpty) return null;
    final sum = records.fold<int>(0, (sum, r) => sum + r.systolicBP!);
    return (sum / records.length).round();
  }

  /// 평균 이완기 혈압
  int? get averageDiastolicBP {
    final records = filteredRecords
        .where((r) => r.diastolicBP != null)
        .toList();
    if (records.isEmpty) return null;
    final sum = records.fold<int>(0, (sum, r) => sum + r.diastolicBP!);
    return (sum / records.length).round();
  }

  /// 평균 혈압 문자열 (예: "120/80")
  String? get averageBPString {
    final systolic = averageSystolicBP;
    final diastolic = averageDiastolicBP;
    if (systolic == null || diastolic == null) return null;
    return '$systolic/$diastolic';
  }

  /// 평균 혈당
  int? get averageBloodSugar {
    final records = filteredRecords.where((r) => r.bloodSugar != null).toList();
    if (records.isEmpty) return null;
    final sum = records.fold<int>(0, (sum, r) => sum + r.bloodSugar!);
    return (sum / records.length).round();
  }

  /// 건강 상태 레벨 판정
  ///
  /// 판정 기준 (임의 정의):
  /// - excellent: 혈압 90-120/60-80, 혈당 70-100
  /// - good: 혈압 120-130/80-85, 혈당 100-125
  /// - caution: 혈압 130-140/85-90, 혈당 125-140
  /// - warning: 혈압 140+/90+, 혈당 140+
  HealthStatusLevel get healthStatus {
    final systolic = averageSystolicBP;
    final diastolic = averageDiastolicBP;
    final bloodSugar = averageBloodSugar;

    if (systolic == null && bloodSugar == null) {
      return HealthStatusLevel.good; // 데이터 없으면 기본값
    }

    // 혈압 판정
    int bpScore = 0;
    if (systolic != null && diastolic != null) {
      if (systolic >= 140 || diastolic >= 90) {
        bpScore = 3; // warning
      } else if (systolic >= 130 || diastolic >= 85) {
        bpScore = 2; // caution
      } else if (systolic >= 120 || diastolic >= 80) {
        bpScore = 1; // good
      } else {
        bpScore = 0; // excellent
      }
    }

    // 혈당 판정
    int bsScore = 0;
    if (bloodSugar != null) {
      if (bloodSugar >= 140) {
        bsScore = 3; // warning
      } else if (bloodSugar >= 125) {
        bsScore = 2; // caution
      } else if (bloodSugar >= 100) {
        bsScore = 1; // good
      } else {
        bsScore = 0; // excellent
      }
    }

    // 더 나쁜 점수로 판정
    final maxScore = (bpScore > bsScore) ? bpScore : bsScore;

    return switch (maxScore) {
      0 => HealthStatusLevel.excellent,
      1 => HealthStatusLevel.good,
      2 => HealthStatusLevel.caution,
      _ => HealthStatusLevel.warning,
    };
  }

  /// 월별로 그룹화된 기록
  Map<String, List<HealthRecordEntity>> get recordsByMonth {
    final grouped = <String, List<HealthRecordEntity>>{};

    for (final record in healthRecords) {
      final key = '${record.recordedAt.year}년 ${record.recordedAt.month}월 작성';
      grouped.putIfAbsent(key, () => []).add(record);
    }

    // 날짜 기준 내림차순 정렬
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return {for (final key in sortedKeys) key: grouped[key]!};
  }

  /// 최근 N개 기록
  List<HealthRecordEntity> recentHealthRecords(int count) {
    final sorted = List<HealthRecordEntity>.from(healthRecords)
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return sorted.take(count).toList();
  }
}
