import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../domain/entities/risk_assessment_entity.dart';
import '../widgets/analysis_common_widgets.dart';

/// 위험도 측정 결과 화면 (Analyze-3-1)
class RiskMeasurementView extends StatelessWidget {
  const RiskMeasurementView({super.key, required this.riskAssessment});

  final RiskAssessmentEntity riskAssessment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: CustomAppBar(mode: AppBarMode.subpage, title: '위험도 측정'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            // 다음 검진 권장 카드
            _buildNextCheckupCard(context),
            const SizedBox(height: 8),
            // 현재 위험도 카드
            _buildCurrentRiskCard(),
            const SizedBox(height: 8),
            // 집단 내 건강 순위 카드
            _buildRankCard(),
            const SizedBox(height: 8),
            // 주요 위험 요인 카드
            _buildRiskFactorsCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNextCheckupCard(BuildContext context) {
    final nextCheckup = riskAssessment.nextCheckupRecommended;
    final now = DateTime.now();
    final diff = nextCheckup.difference(now);
    final monthsUntil = (diff.inDays / 30).round();
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🩺', style: TextStyle(fontSize: 64)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$monthsUntil개월 후',
                    style: theme.textTheme.headlineLarge!.copyWith(
                      color: AppColorScheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('다음 검진 권장', style: theme.textTheme.headlineLarge),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '정기적인 건강검진으로 위험을 관리하세요',
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: AppColorScheme.black500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentRiskCard() {
    return AnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalysisCardHeader(title: '현재 위험도'),
          const SizedBox(height: 12),
          // 위험도 그래프
          _RiskGaugeChart(
            riskScore: riskAssessment.riskScore,
            riskLevel: riskAssessment.riskLevel,
          ),
          const SizedBox(height: 28),
          // 점수 정보
          _buildScoreInfo(),
        ],
      ),
    );
  }

  Widget _buildScoreInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        border: Border.all(color: AppColorScheme.white300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  '위험도 점수',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 20 / 13,
                    letterSpacing: -0.325,
                    color: AppColorScheme.grey300,
                  ),
                ),
                Text(
                  '${riskAssessment.riskScore}/100',
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
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  '뇌졸중 발병 확률',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 20 / 13,
                    letterSpacing: -0.325,
                    color: AppColorScheme.grey300,
                  ),
                ),
                Text(
                  '${riskAssessment.strokeProbability}%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 26 / 18,
                    letterSpacing: -0.45,
                    color: AppColorScheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankCard() {
    return AnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalysisCardHeader(title: '집단 내 건강 순위'),
          const SizedBox(height: 8),
          // 순위 정보
          _buildRankInfo(),
          const SizedBox(height: 16),
          // 분포 그래프
          _RankDistributionChart(
            myScore: riskAssessment.riskScore,
            groupAverage: riskAssessment.groupAverageScore,
          ),
          const SizedBox(height: 8),
          // 점수 범례
          _buildScoreLegend(),
        ],
      ),
    );
  }

  Widget _buildRankInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColorScheme.primaryColor.withValues(alpha: 0.1),
            AppColorScheme.primaryColor.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '50~60세 남성',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 24 / 16,
                letterSpacing: -0.4,
                color: AppColorScheme.black100,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Column(
              children: [
                const Text(
                  '동일 연령대 및 성별 기준',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 18 / 13,
                    letterSpacing: -0.32,
                    color: AppColorScheme.black500,
                  ),
                ),
                Text(
                  '상위 ${riskAssessment.rankPercentile}%',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    height: 36 / 26,
                    letterSpacing: -0.65,
                    color: AppColorScheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreLegend() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColorScheme.white200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColorScheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '내 점수',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 24 / 16,
                      letterSpacing: -0.4,
                      color: AppColorScheme.primaryColor,
                    ),
                  ),
                ],
              ),
              Text(
                '${riskAssessment.riskScore}점',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                  letterSpacing: -0.4,
                  color: AppColorScheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColorScheme.black100,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    '집단 평균',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 24 / 16,
                      letterSpacing: -0.4,
                      color: AppColorScheme.black100,
                    ),
                  ),
                ],
              ),
              Text(
                '${riskAssessment.groupAverageScore}점',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                  letterSpacing: -0.4,
                  color: AppColorScheme.grey300,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRiskFactorsCard(BuildContext context) {
    return AnalysisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnalysisCardHeader(title: '주요 위험 요인'),
          const SizedBox(height: 12),
          // 위험 요인 목록
          ...riskAssessment.riskFactors.map((factor) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildRiskFactorItem(factor),
            );
          }),
          const SizedBox(height: 8),
          // AI 추천 권고사항
          _buildAIRecommendation(context),
        ],
      ),
    );
  }

  Widget _buildRiskFactorItem(RiskFactorEntity factor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(factor.iconType.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factor.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 18 / 14,
                    letterSpacing: -0.28,
                    color: AppColorScheme.black100,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '현재: ',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 20 / 13,
                        letterSpacing: -0.325,
                        color: AppColorScheme.grey300,
                      ),
                    ),
                    Text(
                      factor.currentValue,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 20 / 13,
                        letterSpacing: -0.325,
                        color: AppColorScheme.grey300,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '→',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColorScheme.grey400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '목표: ',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 18 / 14,
                        letterSpacing: -0.28,
                        color: AppColorScheme.primaryColor,
                      ),
                    ),
                    Text(
                      factor.targetValue,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 18 / 14,
                        letterSpacing: -0.28,
                        color: AppColorScheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIRecommendation(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✅', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text(
                'AI 추천 권고사항',
                style: theme.textTheme.labelLarge!.copyWith(
                  color: AppColorScheme.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            riskAssessment.aiRecommendation,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 18 / 13,
              letterSpacing: -0.32,
              color: AppColorScheme.grey300,
            ),
          ),
        ],
      ),
    );
  }
}

/// 위험도 게이지 차트
class _RiskGaugeChart extends StatelessWidget {
  const _RiskGaugeChart({required this.riskScore, required this.riskLevel});

  final int riskScore;
  final RiskLevel riskLevel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 120,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // 게이지 차트
            CustomPaint(
              size: const Size(200, 100),
              painter: _GaugeChartPainter(
                progress: riskScore / 100,
                color: riskLevel.color != null
                    ? Color(riskLevel.color!)
                    : AppColorScheme.grey400,
              ),
            ),
            // 레벨 칩 (게이지 중앙 상단에 배치)
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: riskLevel.color != null
                            ? Color(riskLevel.color!).withValues(alpha: 0.1)
                            : AppColorScheme.white200,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        riskLevel.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 18 / 13,
                          letterSpacing: -0.32,
                          color: riskLevel.color != null
                              ? Color(riskLevel.color!)
                              : AppColorScheme.grey300,
                        ),
                      ),
                    ),

                    Column(
                      children: [
                        Text(
                          '$riskScore%',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 44 / 32,
                            letterSpacing: -0.8,
                            color: AppColorScheme.black100,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          riskLevel == RiskLevel.low
                              ? '관리를 그대로 유지해주세요!'
                              : '개선이 필요합니다',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 22 / 14,
                            letterSpacing: -0.35,
                            color: AppColorScheme.black500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 게이지 차트 페인터
class _GaugeChartPainter extends CustomPainter {
  final double progress;
  final Color color;

  _GaugeChartPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 10;
    final strokeWidth = 12.0;

    // 배경 호
    final bgPaint = Paint()
      ..color = AppColorScheme.white300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // 진행률 호
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugeChartPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// 순위 분포 차트 (fl_chart 사용)
class _RankDistributionChart extends StatelessWidget {
  const _RankDistributionChart({
    required this.myScore,
    required this.groupAverage,
  });

  final int myScore;
  final int groupAverage;

  @override
  Widget build(BuildContext context) {
    // 정규 분포 유사한 히스토그램 데이터 (32개 막대)
    final heights = [
      20.0,
      30.0,
      30.0,
      32.0,
      40.0,
      60.0,
      90.0,
      100.0,
      122.0,
      120.0,
      80.0,
      73.0,
      70.0,
      70.0,
      50.0,
      28.0,
      33.0,
      32.0,
      34.0,
      30.0,
      12.0,
      12.0,
      14.0,
      10.0,
      22.0,
      25.0,
      20.0,
      30.0,
      40.0,
      55.0,
      50.0,
      10.0,
    ];

    // 내 점수와 평균 점수에 해당하는 막대 인덱스 계산
    final myScoreIndex = (myScore * (heights.length - 1) / 100).round();
    final avgIndex = (groupAverage * (heights.length - 1) / 100).round();

    // 라벨 박스 크기 상수
    const double labelBoxWidth = 56.0;
    const double labelBoxHeight = 26.0;
    const double triangleHeight = 8.0;
    const double labelTopOffset = 0.0;

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final chartWidth = constraints.maxWidth;
              // fl_chart의 spaceEvenly 정렬에서 각 막대 위치 계산
              final barWidth = 8.0;
              final totalBars = heights.length;
              // spaceEvenly: 양쪽 끝에도 동일한 간격
              final spacing =
                  (chartWidth - (barWidth * totalBars)) / (totalBars + 1);
              // 막대 중앙 위치 계산
              final barCenterX =
                  spacing +
                  (myScoreIndex * (barWidth + spacing)) +
                  (barWidth / 2);
              // 라벨 왼쪽 위치 (라벨 중앙이 막대 중앙에 오도록)
              final labelLeft = (barCenterX - (labelBoxWidth / 2)).clamp(
                0.0,
                chartWidth - labelBoxWidth,
              );

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // fl_chart BarChart
                  BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      maxY: 150,
                      minY: 0,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      barGroups: List.generate(heights.length, (index) {
                        final height = heights[index];
                        final isMyScore = index == myScoreIndex;
                        final isAvgArea = _isInAverageArea(index, avgIndex);

                        Color barColor;
                        if (isMyScore) {
                          // 내 점수: Primary Color
                          barColor = AppColorScheme.primaryColor;
                        } else if (isAvgArea) {
                          // 평균 점수 주변: Black 그라데이션
                          final distance = (index - avgIndex).abs();
                          final opacity = _calculateBlackOpacity(distance);
                          barColor = AppColorScheme.black100.withValues(
                            alpha: opacity,
                          );
                        } else {
                          // 기본: 회색
                          barColor = const Color(0xFFD9D9D9);
                        }

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: height,
                              color: barColor,
                              width: barWidth,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  // 내 점수 라벨 (말풍선 스타일)
                  Positioned(
                    left: labelLeft,
                    top: labelTopOffset,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 라벨 박스
                        Container(
                          width: labelBoxWidth,
                          height: labelBoxHeight,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColorScheme.primaryColor.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '내 점수',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 18 / 14,
                              letterSpacing: -0.28,
                              color: AppColorScheme.primaryColor,
                            ),
                          ),
                        ),
                        // 말풍선 삼각형 (박스 바깥)
                        CustomPaint(
                          size: Size(12, triangleHeight),
                          painter: _TrianglePainter(
                            color: AppColorScheme.primaryColor.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        // 점수 눈금
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              '0점',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 18 / 13,
                letterSpacing: -0.32,
                color: AppColorScheme.grey400,
              ),
            ),
            Text(
              '50점',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 18 / 13,
                letterSpacing: -0.32,
                color: AppColorScheme.grey400,
              ),
            ),
            Text(
              '100점',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 18 / 13,
                letterSpacing: -0.32,
                color: AppColorScheme.grey400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 평균 점수 주변 영역인지 확인 (±3 범위)
  bool _isInAverageArea(int index, int avgIndex) {
    return (index - avgIndex).abs() <= 3;
  }

  /// Black 컬러의 투명도 계산 (거리에 따라)
  double _calculateBlackOpacity(int distance) {
    switch (distance) {
      case 0:
        return 1.0; // 평균 점수 정확히: 완전 검정
      case 1:
        return 0.75;
      case 2:
        return 0.5;
      case 3:
        return 0.25;
      default:
        return 0.0;
    }
  }
}

/// 삼각형 화살표 페인터 (말풍선 꼬리)
class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
