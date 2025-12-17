import 'package:freezed_annotation/freezed_annotation.dart';

part 'what_if_scenario_entity.freezed.dart';

/// What-if 시뮬레이션 결과 엔티티
@freezed
abstract class WhatIfSimulationEntity with _$WhatIfSimulationEntity {
  const factory WhatIfSimulationEntity({
    /// 현재 위험도 점수
    required int currentRiskScore,

    /// 최대 감소 가능 점수
    required int maxPossibleReduction,

    /// 시나리오 개수
    required int scenarioCount,

    /// AI 추천 시나리오
    required WhatIfScenarioEntity? recommendedScenario,

    /// 전체 시나리오 목록
    required List<WhatIfScenarioEntity> allScenarios,
  }) = _WhatIfSimulationEntity;
}

/// 개별 What-if 시나리오 엔티티
@freezed
abstract class WhatIfScenarioEntity with _$WhatIfScenarioEntity {
  const factory WhatIfScenarioEntity({
    /// 시나리오 ID
    required String id,

    /// 시나리오 이름
    required String name,

    /// 시나리오 설명
    required String description,

    /// 시나리오 아이콘 타입
    required ScenarioIconType iconType,

    /// 성공 시 위험도 점수
    required int resultScore,

    /// 위험도 변화량 (음수 = 감소)
    required int scoreChange,

    /// 위험도 감소 퍼센트 (양수)
    required int reductionPercentage,

    /// 난이도
    required ScenarioDifficulty difficulty,

    /// AI 추천 여부
    required bool isRecommended,

    /// 예상 실천 기간
    required String expectedDuration,

    /// 실천 가이드 목록
    required List<String> practiceGuide,

    /// 추천 이유 목록
    required List<String> recommendationReasons,

    /// 변경 사항 설명
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
