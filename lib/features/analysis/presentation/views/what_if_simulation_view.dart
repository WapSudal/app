import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_bar.dart';
import '../../domain/entities/analysis_entity.dart';
import '../widgets/what_if_widgets.dart';

/// What-if 시뮬레이션 화면
///
/// 두 개의 탭을 포함:
/// - 추천 시나리오: AI 추천 시나리오 상세 정보 표시
/// - 전체 시나리오: 그래프 + 시나리오 카드 리스트 표시
class WhatIfSimulationView extends StatefulWidget {
  const WhatIfSimulationView({super.key, required this.simulation});

  final WhatIfSimulationReportEntity simulation;

  @override
  State<WhatIfSimulationView> createState() => _WhatIfSimulationViewState();
}

class _WhatIfSimulationViewState extends State<WhatIfSimulationView> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final simulation = widget.simulation;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: CustomAppBar(mode: AppBarMode.subpage, title: 'What-if 시뮬레이션'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            // 상단 스플래시 카드
            WhatIfSplashCard(
              currentRiskScore: simulation.currentRiskScore,
              maxPossibleReduction: simulation.maxPossibleReduction,
              scenarioCount: simulation.scenarioCount,
            ),
            const SizedBox(height: 8),
            // 탭 카드
            WhatIfTabCard(
              selectedTabIndex: _selectedTabIndex,
              onTabSelected: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              child: _selectedTabIndex == 0
                  ? _buildRecommendationTab()
                  : _buildAllScenariosTab(),
            ),
            const SizedBox(height: 8),
            // 실천 가이드 카드
            WhatIfPracticeGuideCard(guides: _getPracticeGuides()),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// 추천 시나리오 탭 컨텐츠
  Widget _buildRecommendationTab() {
    final recommendedScenario = widget.simulation.recommendedScenario;

    if (recommendedScenario == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('추천 시나리오가 없습니다.'),
        ),
      );
    }

    return WhatIfRecommendationSection(scenario: recommendedScenario);
  }

  /// 전체 시나리오 탭 컨텐츠
  Widget _buildAllScenariosTab() {
    final scenarios = widget.simulation.allScenarios;

    return Column(
      children: [
        // 그래프 섹션
        WhatIfGraphSection(
          currentScore: widget.simulation.currentRiskScore,
          scenarios: scenarios,
        ),
        // 시나리오 카드 리스트
        ...scenarios.map(
          (scenario) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: WhatIfScenarioCard(scenario: scenario),
          ),
        ),
      ],
    );
  }

  /// 실천 가이드 목록 가져오기
  List<String> _getPracticeGuides() {
    // 추천 시나리오가 있으면 해당 가이드 사용, 없으면 기본 가이드
    final recommendedScenario = widget.simulation.recommendedScenario;
    if (recommendedScenario != null &&
        recommendedScenario.practiceGuide.isNotEmpty) {
      return recommendedScenario.practiceGuide;
    }

    // 기본 실천 가이드
    return [
      '작은 목표부터 시작하여 점진적으로 개선하세요.',
      '매일 조금씩 실천하는 것이 중요합니다.',
      '정기적으로 건강 데이터를 업데이트하세요.',
      '어려움이 있다면 의료진과 상담하세요.',
    ];
  }
}
