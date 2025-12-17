import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../domain/entities/what_if_scenario_entity.dart';
import '../widgets/analysis_common_widgets.dart';

/// What-if 시뮬레이션 화면 (Analyze-3-2-1, Analyze-3-2-2)
class WhatIfSimulationView extends StatefulWidget {
  const WhatIfSimulationView({super.key, required this.simulation});

  final WhatIfSimulationEntity simulation;

  @override
  State<WhatIfSimulationView> createState() => _WhatIfSimulationViewState();
}

class _WhatIfSimulationViewState extends State<WhatIfSimulationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  WhatIfScenarioEntity? _selectedScenario;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // 초기 선택: 추천 시나리오
    _selectedScenario = widget.simulation.recommendedScenario;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F6FB),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColorScheme.black100,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'What-if 시뮬레이션',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColorScheme.black100,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // 탭 바
          _buildTabBar(),
          // 탭 뷰
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 추천 시나리오 탭
                _buildRecommendedTab(),
                // 전체 시나리오 탭
                _buildAllScenariosTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFFF7F6FB),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColorScheme.primaryColor,
        unselectedLabelColor: AppColorScheme.grey400,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: 22 / 15,
          letterSpacing: -0.375,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 22 / 15,
          letterSpacing: -0.375,
        ),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2, color: AppColorScheme.primaryColor),
        ),
        tabs: const [
          Tab(text: '추천 시나리오'),
          Tab(text: '전체 시나리오'),
        ],
      ),
    );
  }

  Widget _buildRecommendedTab() {
    final recommended = widget.simulation.recommendedScenario;
    if (recommended == null) {
      return const Center(child: Text('추천 시나리오가 없습니다.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          // 위험도 감소 요약
          _buildReductionSummaryCard(recommended),
          const SizedBox(height: 8),
          // 비교 그래프
          _buildComparisonChart(recommended),
          const SizedBox(height: 8),
          // 실천 가이드
          _buildPracticeGuideCard(recommended),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAllScenariosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          // 시나리오 목록
          ...widget.simulation.allScenarios.asMap().entries.map((entry) {
            final index = entry.key;
            final scenario = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildScenarioCard(scenario, index + 1),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReductionSummaryCard(WhatIfScenarioEntity scenario) {
    return AnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AnalysisCardHeader(title: '위험도 변화 예측'),
              const RecommendedChip(),
            ],
          ),
          const SizedBox(height: 16),
          // 요약 내용
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColorScheme.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  scenario.iconType.emoji,
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${scenario.name}을 실천하면',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 24 / 16,
                          letterSpacing: -0.4,
                          color: AppColorScheme.black100,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '위험도 ${scenario.reductionPercentage}% 감소',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 28 / 20,
                              letterSpacing: -0.5,
                              color: AppColorScheme.success,
                            ),
                          ),
                          const Text(
                            ' 예상',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 24 / 16,
                              letterSpacing: -0.4,
                              color: AppColorScheme.black500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonChart(WhatIfScenarioEntity scenario) {
    final currentScore = widget.simulation.currentRiskScore;
    final predictedScore = currentScore - scenario.reductionPercentage;

    return AnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalysisCardHeader(title: '현재 vs 예측 위험도'),
          const SizedBox(height: 16),
          // 비교 막대 그래프
          Row(
            children: [
              // 현재
              Expanded(
                child: _buildComparisonBar(
                  label: '현재',
                  score: currentScore,
                  color: AppColorScheme.grey400,
                  maxScore: 100,
                ),
              ),
              const SizedBox(width: 16),
              // 예측
              Expanded(
                child: _buildComparisonBar(
                  label: '예측',
                  score: predictedScore,
                  color: AppColorScheme.success,
                  maxScore: 100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 감소량 표시
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColorScheme.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_downward,
                    size: 16,
                    color: AppColorScheme.success,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${scenario.reductionPercentage}% 감소',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 20 / 14,
                      letterSpacing: -0.35,
                      color: AppColorScheme.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonBar({
    required String label,
    required int score,
    required Color color,
    required int maxScore,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
            letterSpacing: -0.35,
            color: AppColorScheme.grey300,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          width: 60,
          decoration: BoxDecoration(
            color: AppColorScheme.white300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 120 * (score / maxScore),
                width: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$score%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 22 / 16,
            letterSpacing: -0.4,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeGuideCard(WhatIfScenarioEntity scenario) {
    return AnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalysisCardHeader(title: '실천 가이드'),
          const SizedBox(height: 12),
          // 난이도
          Row(
            children: [
              const Text(
                '난이도',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: -0.35,
                  color: AppColorScheme.grey300,
                ),
              ),
              const SizedBox(width: 8),
              DifficultyChip(
                label: scenario.difficulty.label,
                color: Color(scenario.difficulty.color),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 실천 기간
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColorScheme.white200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('⏱️', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '예상 실천 기간',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 18 / 13,
                        letterSpacing: -0.32,
                        color: AppColorScheme.grey300,
                      ),
                    ),
                    Text(
                      scenario.expectedDuration,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 22 / 16,
                        letterSpacing: -0.4,
                        color: AppColorScheme.black100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 실천 팁
          const Text(
            '💡 실천 팁',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              letterSpacing: -0.35,
              color: AppColorScheme.black100,
            ),
          ),
          const SizedBox(height: 8),
          ...scenario.practiceGuide.map((tip) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColorScheme.grey300,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: -0.35,
                        color: AppColorScheme.grey300,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(WhatIfScenarioEntity scenario, int index) {
    final isSelected = _selectedScenario?.id == scenario.id;
    final isRecommended = scenario.isRecommended;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedScenario = scenario;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColorScheme.white100,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColorScheme.primaryColor, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      scenario.iconType.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      scenario.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 26 / 18,
                        letterSpacing: -0.45,
                        color: AppColorScheme.black100,
                      ),
                    ),
                  ],
                ),
                if (isRecommended) const RecommendedChip(),
              ],
            ),
            const SizedBox(height: 12),
            // 감소율 및 난이도
            Row(
              children: [
                // 감소율
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColorScheme.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_downward,
                        size: 14,
                        color: AppColorScheme.success,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${scenario.reductionPercentage}% 감소',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 18 / 13,
                          letterSpacing: -0.32,
                          color: AppColorScheme.success,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // 난이도
                DifficultyChip(
                  label: scenario.difficulty.label,
                  color: Color(scenario.difficulty.color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 설명
            Text(
              scenario.description,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                letterSpacing: -0.35,
                color: AppColorScheme.grey300,
              ),
            ),
            // 선택된 경우 추가 정보
            if (isSelected) ...[
              const SizedBox(height: 16),
              const Divider(color: AppColorScheme.white300),
              const SizedBox(height: 12),
              // 예상 기간
              Row(
                children: [
                  const Text('⏱️', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    '예상 실천 기간: ${scenario.expectedDuration}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 20 / 14,
                      letterSpacing: -0.35,
                      color: AppColorScheme.black100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 실천 가이드 상세보기 버튼
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // 탭 전환 및 해당 시나리오 상세 보기
                    _tabController.animateTo(0);
                    setState(() {
                      // 추천 시나리오로 설정 (실제로는 선택한 시나리오 상세를 보여주도록 수정 필요)
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColorScheme.primaryColor,
                    side: const BorderSide(color: AppColorScheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    '실천 가이드 상세보기',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      letterSpacing: -0.35,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
