import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/risk_level.dart';
import '../../domain/entities/analysis_entity.dart';

part 'analysis_model.freezed.dart';
part 'analysis_model.g.dart';

// =================== Response Models ====================

@freezed
abstract class AnalysisAvailabilityModel with _$AnalysisAvailabilityModel {
  const factory AnalysisAvailabilityModel({
    required bool canAnalyze,
    required int requiredRecordCount,
    required int currentRecordCount,
  }) = _AnalysisAvailabilityModel;

  factory AnalysisAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$AnalysisAvailabilityModelFromJson(json);
}

@freezed
abstract class RiskPredictionSummaryModel with _$RiskPredictionSummaryModel {
  const factory RiskPredictionSummaryModel({
    required int riskScore,
    required String riskLevel,
    required int strokeProbability,
    required String assessedAt,
  }) = _RiskPredictionSummaryModel;

  factory RiskPredictionSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$RiskPredictionSummaryModelFromJson(json);
}

/// 위험도 측정 API 응답 모델
@freezed
abstract class RiskAssessmentReportModel with _$RiskAssessmentReportModel {
  const factory RiskAssessmentReportModel({
    required int riskScore,
    required String riskLevel,
    required int strokeProbability,
    required String assessedAt,
    required String nextCheckupRecommended,
    required int rankPercentile,
    required int groupAverageScore,
    required List<RiskFactorModel> riskFactors,
    required String aiRecommendation,
  }) = _RiskAssessmentReportModel;

  factory RiskAssessmentReportModel.fromJson(Map<String, dynamic> json) =>
      _$RiskAssessmentReportModelFromJson(json);
}

/// 위험 요인 API 모델
@freezed
abstract class RiskFactorModel with _$RiskFactorModel {
  const factory RiskFactorModel({
    required String id,
    required String name,
    required String iconType,
    required String currentValue,
    required String targetValue,
  }) = _RiskFactorModel;

  factory RiskFactorModel.fromJson(Map<String, dynamic> json) =>
      _$RiskFactorModelFromJson(json);
}

/// What-if 시뮬레이션 API 응답 모델
@freezed
abstract class WhatIfSimulationReportModel with _$WhatIfSimulationReportModel {
  const factory WhatIfSimulationReportModel({
    required int currentRiskScore,
    required int maxPossibleReduction,
    required int scenarioCount,
    WhatIfScenarioModel? recommendedScenario,
    required List<WhatIfScenarioModel> allScenarios,
  }) = _WhatIfSimulationReportModel;

  factory WhatIfSimulationReportModel.fromJson(Map<String, dynamic> json) =>
      _$WhatIfSimulationReportModelFromJson(json);
}

/// 개별 시나리오 API 모델
@freezed
abstract class WhatIfScenarioModel with _$WhatIfScenarioModel {
  const factory WhatIfScenarioModel({
    required String id,
    required String name,
    required String description,
    required String iconType,
    required int resultScore,
    required int scoreChange,
    required int reductionPercentage,
    required String difficulty,
    required bool isRecommended,
    required String expectedDuration,
    required List<String> practiceGuide,
    required List<String> recommendationReasons,
    required List<String> changes,
  }) = _WhatIfScenarioModel;

  factory WhatIfScenarioModel.fromJson(Map<String, dynamic> json) =>
      _$WhatIfScenarioModelFromJson(json);
}

// =================== Extensions ====================

extension AnalysisAvailabilityModelX on AnalysisAvailabilityModel {
  AnalysisAvailabilityEntity toEntity() {
    return AnalysisAvailabilityEntity(
      canAnalyze: canAnalyze,
      requiredRecordCount: requiredRecordCount,
      currentRecordCount: currentRecordCount,
    );
  }
}

extension RiskPredictionSummaryModelX on RiskPredictionSummaryModel {
  RiskPredictionSummaryEntity toEntity() {
    return RiskPredictionSummaryEntity(
      riskScore: riskScore,
      riskLevel: _parseRiskLevel(riskLevel),
      strokeProbability: strokeProbability,
      assessedAt: DateTime.parse(assessedAt),
    );
  }

  RiskLevel _parseRiskLevel(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return RiskLevel.low;
      case 'medium':
        return RiskLevel.medium;
      case 'higher':
        return RiskLevel.higher;
      case 'high':
        return RiskLevel.high;
      default:
        return RiskLevel.unknown;
    }
  }
}

extension RiskAssessmentModelX on RiskAssessmentReportModel {
  RiskAssessmentReportEntity toEntity() {
    return RiskAssessmentReportEntity(
      riskScore: riskScore,
      riskLevel: _parseRiskLevel(riskLevel),
      strokeProbability: strokeProbability,
      assessedAt: DateTime.parse(assessedAt),
      nextCheckupRecommended: DateTime.parse(nextCheckupRecommended),
      rankPercentile: rankPercentile,
      groupAverageScore: groupAverageScore,
      riskFactors: riskFactors.map((f) => f.toEntity()).toList(),
      aiRecommendation: aiRecommendation,
    );
  }

  RiskLevel _parseRiskLevel(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return RiskLevel.low;
      case 'medium':
        return RiskLevel.medium;
      case 'higher':
        return RiskLevel.higher;
      case 'high':
        return RiskLevel.high;
      default:
        return RiskLevel.unknown;
    }
  }
}

extension RiskFactorModelX on RiskFactorModel {
  RiskFactorEntity toEntity() {
    return RiskFactorEntity(
      id: id,
      name: name,
      iconType: switch (iconType.toLowerCase()) {
        'exercise' => RiskFactorIconType.exercise,
        'bloodsugar' => RiskFactorIconType.bloodSugar,
        'bloodpressure' => RiskFactorIconType.bloodPressure,
        'smoking' => RiskFactorIconType.smoking,
        'weight' => RiskFactorIconType.weight,
        'sleep' => RiskFactorIconType.sleep,
        _ => RiskFactorIconType.exercise,
      },
      currentValue: currentValue,
      targetValue: targetValue,
    );
  }
}

extension WhatIfSimulationReportModelX on WhatIfSimulationReportModel {
  WhatIfSimulationReportEntity toEntity() {
    return WhatIfSimulationReportEntity(
      currentRiskScore: currentRiskScore,
      maxPossibleReduction: maxPossibleReduction,
      scenarioCount: scenarioCount,
      recommendedScenario: recommendedScenario?.toEntity(),
      allScenarios: allScenarios.map((s) => s.toEntity()).toList(),
    );
  }
}

extension WhatIfScenarioModelX on WhatIfScenarioModel {
  WhatIfScenarioEntity toEntity() {
    return WhatIfScenarioEntity(
      id: id,
      name: name,
      description: description,
      iconType: _parseIconType(iconType),
      resultScore: resultScore,
      scoreChange: scoreChange,
      reductionPercentage: reductionPercentage,
      difficulty: _parseDifficulty(difficulty),
      isRecommended: isRecommended,
      expectedDuration: expectedDuration,
      practiceGuide: practiceGuide,
      recommendationReasons: recommendationReasons,
      changes: changes,
    );
  }

  ScenarioIconType _parseIconType(String type) {
    switch (type.toLowerCase()) {
      case 'smoking':
        return ScenarioIconType.smoking;
      case 'bloodpressure':
        return ScenarioIconType.bloodPressure;
      case 'weight':
        return ScenarioIconType.weight;
      case 'exercise':
        return ScenarioIconType.exercise;
      case 'diet':
        return ScenarioIconType.diet;
      case 'sleep':
        return ScenarioIconType.sleep;
      default:
        return ScenarioIconType.smoking;
    }
  }

  ScenarioDifficulty _parseDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return ScenarioDifficulty.easy;
      case 'medium':
        return ScenarioDifficulty.medium;
      case 'hard':
        return ScenarioDifficulty.hard;
      default:
        return ScenarioDifficulty.medium;
    }
  }
}
