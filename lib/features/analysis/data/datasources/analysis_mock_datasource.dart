import '../models/risk_assessment_model.dart';
import '../models/what_if_scenario_model.dart';

/// 분석 데이터 소스 (목업 데이터 제공)
class AnalysisMockDataSource {
  /// 분석 가능 여부에 따른 위험도 측정 결과 반환
  Future<RiskAssessmentModel?> getRiskAssessment({
    required int recordCount,
  }) async {
    // 네트워크 지연 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    // 3개 미만의 기록이면 null 반환 (분석 불가)
    if (recordCount < 3) return null;

    return const RiskAssessmentModel(
      riskScore: 13,
      riskLevel: 'low',
      strokeProbability: 10,
      assessedAt: '2025-12-18T10:00:00Z',
      nextCheckupRecommended: '2026-01-18T10:00:00Z',
      rankPercentile: 20,
      groupAverageScore: 35,
      riskFactors: [
        RiskFactorModel(
          id: 'exercise',
          name: '일일 운동 부족',
          iconType: 'exercise',
          currentValue: '하루 0시간',
          targetValue: '하루 2시간',
        ),
        RiskFactorModel(
          id: 'bloodSugar',
          name: '혈당 관리 필요',
          iconType: 'bloodSugar',
          currentValue: '100mg/dL',
          targetValue: '< 100mg/dL',
        ),
      ],
      aiRecommendation:
          '사용자님은 같은 군집에서 체중이 높은 편입니다. 따라서 운동 시간을 증가시키는 것이 가장 중요합니다. 저혈당의 문제도 있지만 운동 시간 증가가 훨씬 효과적일 것입니다. 주 3회 이상, 매회 30분 이상 유산소 운동을 하세요. 또한 당분 섭취도 줄이고 식후 혈당을 관리해야합니다. 마지막으로 충분한 수면을 취하고 스트레스를 관리하세요.',
    );
  }

  /// What-if 시뮬레이션 결과 반환
  Future<WhatIfSimulationModel?> getWhatIfSimulation({
    required int recordCount,
  }) async {
    // 네트워크 지연 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    // 3개 미만의 기록이면 null 반환 (분석 불가)
    if (recordCount < 3) return null;

    const recommendedScenario = WhatIfScenarioModel(
      id: 'quit_smoking',
      name: '금연',
      description: '흡연은 뇌졸중 위험을 크게 높입니다. 금연을 통해 뇌졸중 발생 위험을 25%까지 낮출 수 있습니다.',
      iconType: 'smoking',
      resultScore: 0,
      scoreChange: -25,
      reductionPercentage: 25,
      difficulty: 'hard',
      isRecommended: true,
      expectedDuration: '6개월 이상',
      practiceGuide: [
        '금연 보조제(니코틴 패치, 껌)를 활용하세요.',
        '금연 클리닉이나 상담 서비스를 이용하세요.',
        '스트레스 관리 방법을 찾아 흡연 욕구를 줄이세요.',
        '주변 사람들에게 금연 의지를 알리고 도움을 받으세요.',
      ],
      recommendationReasons: [
        '효과적으로 위험도를 크게 낮출 수 있음',
        '성공 난이도는 어려우나 쉽게 도전할 수 있음',
        '성공 시 전체적인 건강 개선에도 큰 영향',
      ],
      changes: ['금연 상태로 변경'],
    );

    return WhatIfSimulationModel(
      currentRiskScore: 20,
      maxPossibleReduction: 20,
      scenarioCount: 4,
      recommendedScenario: recommendedScenario,
      allScenarios: [
        recommendedScenario,
        const WhatIfScenarioModel(
          id: 'reduce_bp',
          name: '혈압 감소',
          description:
              '고혈압은 뇌졸중의 주요 위험 요인입니다. 혈압을 정상 수준으로 유지하면 위험을 크게 줄일 수 있습니다.',
          iconType: 'bloodPressure',
          resultScore: 16,
          scoreChange: -4,
          reductionPercentage: 4,
          difficulty: 'medium',
          isRecommended: false,
          expectedDuration: '3개월',
          practiceGuide: [
            '나트륨 섭취를 줄이세요 (하루 2g 이하).',
            '규칙적인 혈압 측정 습관을 들이세요.',
            '처방받은 혈압약을 꾸준히 복용하세요.',
          ],
          recommendationReasons: [],
          changes: ['혈압 10% 감소', '식이요법 조절'],
        ),
        const WhatIfScenarioModel(
          id: 'weight_loss',
          name: '체중 감량',
          description: '적정 체중을 유지하면 혈압과 혈당 조절에 도움이 되어 뇌졸중 위험을 줄입니다.',
          iconType: 'weight',
          resultScore: 18,
          scoreChange: -2,
          reductionPercentage: 2,
          difficulty: 'medium',
          isRecommended: false,
          expectedDuration: '4개월',
          practiceGuide: [
            '균형 잡힌 식단으로 칼로리 섭취를 조절하세요.',
            '주 3회 이상 유산소 운동을 하세요.',
            '야식과 간식을 줄이세요.',
          ],
          recommendationReasons: [],
          changes: ['체중 5kg 감량'],
        ),
        const WhatIfScenarioModel(
          id: 'exercise_increase',
          name: '운동 증가',
          description: '규칙적인 운동은 심혈관 건강을 개선하고 뇌졸중 위험을 낮춥니다.',
          iconType: 'exercise',
          resultScore: 19,
          scoreChange: -1,
          reductionPercentage: 1,
          difficulty: 'easy',
          isRecommended: false,
          expectedDuration: '2개월',
          practiceGuide: [
            '하루 30분 이상 걷기 운동을 하세요.',
            '계단 이용을 생활화하세요.',
            '주말에는 야외 활동을 즐기세요.',
          ],
          recommendationReasons: [],
          changes: ['주 3회 이상 운동', '하루 30분 이상'],
        ),
      ],
    );
  }
}
