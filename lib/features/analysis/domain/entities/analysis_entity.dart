import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/risk_level.dart';

part 'analysis_entity.freezed.dart';

@freezed
abstract class AnalysisAvailabilityEntity with _$AnalysisAvailabilityEntity {
  const factory AnalysisAvailabilityEntity({
    required bool canAnalyze,
    required int requiredRecordCount,
    required int currentRecordCount,
  }) = _AnalysisAvailabilityEntity;
}

@freezed
abstract class RiskPredictionSummaryEntity with _$RiskPredictionSummaryEntity {
  const factory RiskPredictionSummaryEntity({
    required int riskScore,
    required RiskLevel riskLevel,
    required int strokeProbability,
  }) = _RiskPredictionSummaryEntity;
}

/// 위험도 측정 API 응답 모델
@freezed
abstract class RiskAssessmentReportEntity with _$RiskAssessmentReportEntity {
  const factory RiskAssessmentReportEntity({
    required int riskScore,
    required RiskLevel riskLevel,
    required int strokeProbability,
    required DateTime assessedAt,
    required DateTime nextCheckupRecommended,
    required int rankPercentile,
    required int groupAverageScore,
    required List<RiskFactorEntity> riskFactors,
    required String aiRecommendation,
  }) = _RiskAssessmentReportEntity;
}

/// 위험 요인 API 모델
@freezed
abstract class RiskFactorEntity with _$RiskFactorEntity {
  const factory RiskFactorEntity({
    required String id,
    required String name,
    required RiskFactorIconType iconType,
    required String currentValue,
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

/// What-if 시뮬레이션 API 응답 모델
@freezed
abstract class WhatIfSimulationReportEntity
    with _$WhatIfSimulationReportEntity {
  const factory WhatIfSimulationReportEntity({
    required int currentRiskScore,
    required int maxPossibleReduction,
    required int scenarioCount,
    WhatIfScenarioEntity? recommendedScenario,
    required List<WhatIfScenarioEntity> allScenarios,
  }) = _WhatIfSimulationReportEntity;
}

/// 개별 시나리오 API 모델
@freezed
abstract class WhatIfScenarioEntity with _$WhatIfScenarioEntity {
  const factory WhatIfScenarioEntity({
    required String id,
    required String name,
    required String description,
    required ScenarioIconType iconType,
    required int resultScore,
    required int scoreChange,
    required int reductionPercentage,
    required ScenarioDifficulty difficulty,
    required bool isRecommended,
    required String expectedDuration,
    required List<String> practiceGuide,
    required List<String> recommendationReasons,
    required List<String> changes,
  }) = _WhatIfScenarioEntity;
}

/// 시나리오 아이콘 타입
enum ScenarioIconType {
  smoking('🚭'),
  bloodPressure('💉'),
  weight('⚖️'),
  exercise('💪'),
  diet('🥗'),
  sleep('💤');

  const ScenarioIconType(this.emoji);

  final String emoji;
}

/// 시나리오 난이도
enum ScenarioDifficulty {
  easy('쉬움', 0xFF71CE6E),
  medium('보통', 0xFFF7DB34),
  hard('어려움', 0xFFFF4130);

  const ScenarioDifficulty(this.label, this.color);

  final String label;
  final int color;
}
