import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_segmented_tab_bar.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../domain/entities/analysis_entity.dart';
import 'analysis_common_widgets.dart';

/// What-if 시뮬레이션 상단 스플래시 카드
class WhatIfSplashCard extends StatelessWidget {
  const WhatIfSplashCard({
    super.key,
    required this.currentRiskScore,
    required this.maxPossibleReduction,
    required this.scenarioCount,
  });

  final int currentRiskScore;
  final int maxPossibleReduction;
  final int scenarioCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 현재 위험도
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '현재 내 위험도',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColorScheme.primaryColor,
                ),
              ),
              Text('$currentRiskScore점', style: theme.textTheme.headlineLarge),
            ],
          ),
          // 최대 감소 가능 & 시나리오 개수
          Row(
            children: [
              // 최대 감소 가능
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '최대 감소 가능',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColorScheme.grey300,
                    ),
                  ),
                  Text(
                    '$maxPossibleReduction점',
                    style: theme.textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // 시나리오 개수
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '시나리오',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColorScheme.grey300,
                    ),
                  ),
                  Text('$scenarioCount개', style: theme.textTheme.labelLarge),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// What-if 탭 컨테이너 카드
class WhatIfTabCard extends StatelessWidget {
  const WhatIfTabCard({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
    required this.child,
  });

  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 탭 바
          AppSegmentedTabBar(
            items: const [
              SegmentedTabItem(label: '추천 시나리오', value: 0),
              SegmentedTabItem(label: '전체 시나리오', value: 1),
            ],
            selectedIndex: selectedTabIndex,
            onItemSelected: onTabSelected,
          ),
          const SizedBox(height: 12),
          // 탭 콘텐츠
          child,
        ],
      ),
    );
  }
}

/// 추천 시나리오 섹션 (탭 1)
class WhatIfRecommendationSection extends StatelessWidget {
  const WhatIfRecommendationSection({super.key, required this.scenario});

  final WhatIfScenarioEntity scenario;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI 추천 시나리오 헤더
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // 아이콘
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: Text(
                      scenario.iconType.emoji,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 텍스트
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Text(
                          'AI 추천 시나리오',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      Text(scenario.name, style: theme.textTheme.headlineLarge),
                    ],
                  ),
                ],
              ),
              // 난이도 칩
              DifficultyChip(
                label: scenario.difficulty.label,
                color: Color(scenario.difficulty.color),
              ),
            ],
          ),
        ),
        // 성공시 위험도 & 위험도 변화 박스
        Row(
          children: [
            // 성공시 위험도
            Expanded(
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: AppColorScheme.white200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '성공시 위험도',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColorScheme.grey300,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${scenario.resultScore}점',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 위험도 변화
            Expanded(
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: AppColorScheme.white200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '위험도 변화',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColorScheme.grey300,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${scenario.scoreChange}점',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 시나리오 추천 이유
        if (scenario.recommendationReasons.isNotEmpty)
          _WhatIfRecommendationReasons(reasons: scenario.recommendationReasons),
      ],
    );
  }
}

/// 시나리오 추천 이유 위젯
class _WhatIfRecommendationReasons extends StatelessWidget {
  const _WhatIfRecommendationReasons({required this.reasons});

  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Text(
            '시나리오 추천 이유',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColorScheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          // 목록
          ...reasons.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final reason = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Text('$index. $reason', style: theme.textTheme.bodySmall),
            );
          }),
        ],
      ),
    );
  }
}

/// 전체 시나리오 그래프 섹션 (탭 2)
class WhatIfGraphSection extends StatelessWidget {
  const WhatIfGraphSection({
    super.key,
    required this.currentScore,
    required this.scenarios,
  });

  final int currentScore;
  final List<WhatIfScenarioEntity> scenarios;

  @override
  Widget build(BuildContext context) {
    // 최대 점수 계산 (현재 점수 기준)
    final maxScore = currentScore > 0 ? currentScore : 100;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // 현재 점수 바
          _WhatIfGraphBar(
            label: '현재',
            score: currentScore,
            maxScore: maxScore,
            barColor: AppColorScheme.primaryColor,
            labelColor: AppColorScheme.primaryColor,
          ),
          const SizedBox(height: 8),
          // 시나리오별 바
          ...scenarios.map(
            (scenario) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _WhatIfGraphBar(
                label: scenario.name,
                score: scenario.resultScore,
                maxScore: maxScore,
                barColor: scenario.isRecommended
                    ? AppColorScheme.success
                    : AppColorScheme.grey500,
                labelColor: scenario.isRecommended
                    ? AppColorScheme.success
                    : AppColorScheme.black100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 개별 그래프 바 위젯
class _WhatIfGraphBar extends StatelessWidget {
  const _WhatIfGraphBar({
    required this.label,
    required this.score,
    required this.maxScore,
    required this.barColor,
    required this.labelColor,
  });

  final String label;
  final int score;
  final int maxScore;
  final Color barColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = maxScore > 0 ? (score / maxScore).clamp(0.0, 1.0) : 0.0;

    return Row(
      children: [
        // 라벨
        SizedBox(
          width: 60,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodySmall?.copyWith(color: labelColor),
          ),
        ),
        const SizedBox(width: 8),
        // 바
        Expanded(
          child: Container(
            height: 26,
            decoration: BoxDecoration(
              color: AppColorScheme.white300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final fillWidth = constraints.maxWidth * progress;
                return Stack(
                  children: [
                    // 채워진 바
                    if (fillWidth > 0)
                      Container(
                        width: fillWidth,
                        height: 26,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 10),
                        child: Opacity(
                          opacity: 0.7,
                          child: Text(
                            '$score',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColorScheme.white100,
                            ),
                          ),
                        ),
                      ),
                    // 0점일 때 바 바깥에 점수 표시
                    if (fillWidth == 0)
                      Positioned(
                        left: 8,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Opacity(
                            opacity: 0.7,
                            child: Text(
                              '$score',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColorScheme.black100,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// 시나리오 카드 (전체 시나리오 탭에서 사용)
class WhatIfScenarioCard extends StatelessWidget {
  const WhatIfScenarioCard({super.key, required this.scenario});

  final WhatIfScenarioEntity scenario;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRecommended = scenario.isRecommended;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRecommended
            ? AppColorScheme.success.withValues(alpha: 0.02)
            : AppColorScheme.white100,
        borderRadius: BorderRadius.circular(8),
        border: isRecommended
            ? Border.all(
                color: AppColorScheme.success.withValues(alpha: 0.5),
                width: 1.5,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 영역: 칩들 + 시나리오 이름 / 성공 후 위험도 + 감소량
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 왼쪽: 칩 + 이름
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 칩들
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        DifficultyChip(
                          label: scenario.difficulty.label,
                          color: Color(scenario.difficulty.color),
                        ),
                        if (isRecommended) const RecommendedChip(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 시나리오 이름
                    Text(scenario.name, style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
              // 오른쪽: 성공 후 위험도 + 감소량
              Row(
                children: [
                  // 성공 후 위험도
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '성공 후 위험도',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColorScheme.grey300,
                        ),
                      ),
                      Text(
                        '${scenario.resultScore}점',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColorScheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // 감소량
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '감소량',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColorScheme.grey300,
                        ),
                      ),
                      Text(
                        '${-scenario.scoreChange}점',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColorScheme.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // 변경사항 칩들
          if (scenario.changes.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: scenario.changes.map((change) {
                return _ChangeChip(label: change);
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

/// 변경사항 칩
class _ChangeChip extends StatelessWidget {
  const _ChangeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColorScheme.grey300.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 18 / 13,
          letterSpacing: -0.32,
          color: Color(0xFF616161),
        ),
      ),
    );
  }
}

/// 실천 가이드 카드
class WhatIfPracticeGuideCard extends StatelessWidget {
  const WhatIfPracticeGuideCard({super.key, required this.guides});

  final List<String> guides;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 4),
              Text(
                '실천 가이드',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColorScheme.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 가이드 목록
          ...guides.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final guide = entry.value;
            return Text('$index. $guide', style: theme.textTheme.bodySmall);
          }),
        ],
      ),
    );
  }
}
