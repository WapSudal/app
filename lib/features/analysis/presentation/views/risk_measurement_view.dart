import 'package:flutter/material.dart';
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
            _buildNextCheckupCard(),
            const SizedBox(height: 8),
            // 현재 위험도 카드
            _buildCurrentRiskCard(),
            const SizedBox(height: 8),
            // 집단 내 건강 순위 카드
            _buildRankCard(),
            const SizedBox(height: 8),
            // 주요 위험 요인 카드
            _buildRiskFactorsCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNextCheckupCard() {
    final nextCheckup = riskAssessment.nextCheckupRecommended;
    final now = DateTime.now();
    final diff = nextCheckup.difference(now);
    final monthsUntil = (diff.inDays / 30).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('🩺', style: TextStyle(fontSize: 48)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$monthsUntil개월 후',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 32 / 22,
                      letterSpacing: -0.55,
                      color: AppColorScheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '다음 검진 권장',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 32 / 22,
                      letterSpacing: -0.55,
                      color: AppColorScheme.black100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '정기적인 건강검진으로 위험을 관리하세요',
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
          const SizedBox(height: 8),
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

  Widget _buildRiskFactorsCard() {
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
          _buildAIRecommendation(),
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

  Widget _buildAIRecommendation() {
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
              const Text(
                'AI 추천 권고사항',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 20 / 16,
                  letterSpacing: -0.32,
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
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 게이지 차트
            SizedBox(
              width: 200,
              height: 100,
              child: CustomPaint(
                painter: _GaugeChartPainter(
                  progress: riskScore / 100,
                  color: riskLevel.color != null
                      ? Color(riskLevel.color!)
                      : AppColorScheme.grey400,
                ),
              ),
            ),
            // 레벨 칩
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
            const SizedBox(height: 12),
            // 퍼센트
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
            const SizedBox(height: 4),
            // 메시지
            Text(
              riskLevel == RiskLevel.low ? '관리를 그대로 유지해주세요!' : '개선이 필요합니다',
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

/// 순위 분포 차트
class _RankDistributionChart extends StatelessWidget {
  const _RankDistributionChart({
    required this.myScore,
    required this.groupAverage,
  });

  final int myScore;
  final int groupAverage;

  @override
  Widget build(BuildContext context) {
    // 정규 분포 유사한 히스토그램 데이터
    final heights = [
      20,
      30,
      30,
      32,
      40,
      60,
      90,
      100,
      122,
      120,
      80,
      73,
      70,
      70,
      50,
      28,
      33,
      32,
      34,
      30,
      12,
      12,
      14,
      10,
      22,
      25,
      20,
      30,
      40,
      55,
      50,
      10,
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            children: [
              // 막대 그래프
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: heights.asMap().entries.map((entry) {
                  final index = entry.key;
                  final height = entry.value;
                  final isMyScore =
                      (index * 100 / heights.length).round() ==
                      (myScore * heights.length / 100).round();

                  return Expanded(
                    child: Container(
                      height: height.toDouble(),
                      margin: const EdgeInsets.symmetric(horizontal: 0.5),
                      decoration: BoxDecoration(
                        color: isMyScore
                            ? AppColorScheme.primaryColor
                            : AppColorScheme.grey500.withValues(
                                alpha: 0.5 + (height / 244),
                              ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // 내 점수 라벨
              Positioned(
                left:
                    (myScore / 100 * (MediaQuery.of(context).size.width - 56)) -
                    30,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColorScheme.primaryColor.withValues(alpha: 0.2),
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
              ),
            ],
          ),
        ),
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
}
