import 'package:freezed_annotation/freezed_annotation.dart';

part 'risk_assessment_entity.freezed.dart';

/// 위험도 측정 결과 엔티티
@freezed
abstract class RiskAssessmentEntity with _$RiskAssessmentEntity {
  const factory RiskAssessmentEntity({
    /// 위험도 점수 (0-100)
    required int riskScore,

    /// 위험도 레벨
    required RiskLevel riskLevel,

    /// 뇌졸중 발병 확률 (%)
    required int strokeProbability,

    /// 분석 날짜
    required DateTime assessedAt,

    /// 다음 검진 권장일
    required DateTime nextCheckupRecommended,

    /// 동일 연령대/성별 내 순위 (%)
    required int rankPercentile,

    /// 집단 평균 점수
    required int groupAverageScore,

    /// 주요 위험 요인 목록
    required List<RiskFactorEntity> riskFactors,

    /// AI 추천 권고사항
    required String aiRecommendation,
  }) = _RiskAssessmentEntity;
}

/// 위험도 레벨 열거형
enum RiskLevel {
  unknown('Unknown', null),
  low('낮음', 0xFF71CE6E),
  medium('보통', 0xFFF7DB34),
  higher('주의', 0xFFFF9500),
  high('높음', 0xFFFF4130);

  const RiskLevel(this.label, this.color);

  final String label;
  final int? color;
}

/// 위험 요인 엔티티
@freezed
abstract class RiskFactorEntity with _$RiskFactorEntity {
  const factory RiskFactorEntity({
    /// 요인 ID
    required String id,

    /// 요인 이름
    required String name,

    /// 아이콘 타입
    required RiskFactorIconType iconType,

    /// 현재 값
    required String currentValue,

    /// 목표 값
    required String targetValue,
  }) = _RiskFactorEntity;
}

/// 위험 요인 아이콘 타입
enum RiskFactorIconType {
  exercise('💪'),
  bloodSugar('🩸'),
  bloodPressure('⚡'),
  smoking('🚬'),
  weight('⚖️'),
  sleep('💤');

  const RiskFactorIconType(this.emoji);

  final String emoji;
}
