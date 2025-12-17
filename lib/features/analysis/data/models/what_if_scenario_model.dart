import 'package:freezed_annotation/freezed_annotation.dart';

part 'what_if_scenario_model.freezed.dart';
part 'what_if_scenario_model.g.dart';

/// What-if 시뮬레이션 API 응답 모델
@freezed
abstract class WhatIfSimulationModel with _$WhatIfSimulationModel {
  const factory WhatIfSimulationModel({
    required int currentRiskScore,
    required int maxPossibleReduction,
    required int scenarioCount,
    WhatIfScenarioModel? recommendedScenario,
    required List<WhatIfScenarioModel> allScenarios,
  }) = _WhatIfSimulationModel;

  factory WhatIfSimulationModel.fromJson(Map<String, dynamic> json) =>
      _$WhatIfSimulationModelFromJson(json);
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
