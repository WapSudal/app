import '../../domain/entities/analysis_status_entity.dart';
import '../../domain/entities/risk_assessment_entity.dart';
import '../../domain/entities/what_if_scenario_entity.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../datasources/analysis_mock_datasource.dart';
import '../models/risk_assessment_model.dart';
import '../models/what_if_scenario_model.dart';

/// 분석 Repository 구현체
class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisMockDataSource _mockDataSource;

  AnalysisRepositoryImpl({required AnalysisMockDataSource mockDataSource})
    : _mockDataSource = mockDataSource;

  @override
  Future<AnalysisStatusEntity> getAnalysisStatus({
    required int recordCount,
  }) async {
    const requiredCount = 3;
    final recordsNeeded = (requiredCount - recordCount).clamp(0, requiredCount);
    final progress = (recordCount / requiredCount).clamp(0.0, 1.0);

    return AnalysisStatusEntity(
      canAnalyze: recordCount >= requiredCount,
      requiredRecordCount: requiredCount,
      currentRecordCount: recordCount,
      recordsNeeded: recordsNeeded,
      progress: progress,
    );
  }

  @override
  Future<RiskAssessmentEntity?> getRiskAssessment({
    required int recordCount,
  }) async {
    final model = await _mockDataSource.getRiskAssessment(
      recordCount: recordCount,
    );

    if (model == null) return null;

    return model.toEntity();
  }

  @override
  Future<WhatIfSimulationEntity?> getWhatIfSimulation({
    required int recordCount,
  }) async {
    final model = await _mockDataSource.getWhatIfSimulation(
      recordCount: recordCount,
    );

    if (model == null) return null;

    return model.toEntity();
  }
}

// ==================== Extensions ====================

extension RiskAssessmentModelX on RiskAssessmentModel {
  RiskAssessmentEntity toEntity() {
    return RiskAssessmentEntity(
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
      iconType: _parseIconType(iconType),
      currentValue: currentValue,
      targetValue: targetValue,
    );
  }

  RiskFactorIconType _parseIconType(String type) {
    switch (type.toLowerCase()) {
      case 'exercise':
        return RiskFactorIconType.exercise;
      case 'bloodsugar':
        return RiskFactorIconType.bloodSugar;
      case 'bloodpressure':
        return RiskFactorIconType.bloodPressure;
      case 'smoking':
        return RiskFactorIconType.smoking;
      case 'weight':
        return RiskFactorIconType.weight;
      case 'sleep':
        return RiskFactorIconType.sleep;
      default:
        return RiskFactorIconType.exercise;
    }
  }
}

extension WhatIfSimulationModelX on WhatIfSimulationModel {
  WhatIfSimulationEntity toEntity() {
    return WhatIfSimulationEntity(
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
