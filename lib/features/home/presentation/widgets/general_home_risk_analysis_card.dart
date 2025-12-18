import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../providers/home_state.dart';

/// 위험도 분석 카드 (3개 이상 기록 시)
///
/// Figma: Home - 7 (node-id=460:3854)
/// - 내 위험도 헤더
/// - 반원 게이지 그래프 + 위험도 퍼센트
/// - 갱신 날짜
class GeneralHomeRiskAnalysisCard extends StatelessWidget {
  const GeneralHomeRiskAnalysisCard({
    super.key,
    required this.riskAnalysisResult,
    this.onTap,
  });

  /// 위험도 분석 결과
  final RiskAnalysisResult riskAnalysisResult;

  /// 카드 탭 콜백
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColorScheme.white100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더: 내 위험도 + 화살표
            _buildHeader(context),
            const SizedBox(height: 12),
            // 위험도 그래프
            _buildRiskGraph(context),
            const SizedBox(height: 8),
            // 구분선
            const Divider(color: AppColorScheme.white400, thickness: 1),
            const SizedBox(height: 8),
            // 갱신 날짜
            _buildUpdatedDate(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '내 위험도',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColorScheme.black100,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.45,
          ),
        ),
        Opacity(
          opacity: 0.2,
          child: Assets.icons.arrowRight.svg(
            width: 21,
            height: 21,
            colorFilter: ColorFilter.mode(
              AppColorScheme.black100,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskGraph(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // 반원 게이지
          SizedBox(
            width: 200,
            height: 100,
            child: CustomPaint(
              painter: _RiskGaugePainter(
                percentage: riskAnalysisResult.riskPercentage,
                riskLevel: riskAnalysisResult.riskLevel,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 위험도 레벨 칩
                      _buildRiskChip(context),
                      // 퍼센트
                      Text(
                        '${riskAnalysisResult.riskPercentage}%',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: AppColorScheme.black100,
                              fontWeight: FontWeight.w700,
                              fontSize: 32,
                              letterSpacing: -0.8,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 안내 메시지
          Text(
            _getRiskMessage(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColorScheme.black500,
              letterSpacing: -0.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskChip(BuildContext context) {
    final chipColor = riskAnalysisResult.riskLevel.color != null
        ? Color(riskAnalysisResult.riskLevel.color!)
        : AppColorScheme.grey300;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        riskAnalysisResult.riskLevel.label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: chipColor, letterSpacing: -0.32),
      ),
    );
  }

  Widget _buildUpdatedDate(BuildContext context) {
    final date = riskAnalysisResult.updatedAt;
    final formattedDate =
        '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';

    return Center(
      child: Text(
        '갱신: $formattedDate',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColorScheme.grey300,
          letterSpacing: -0.325,
        ),
      ),
    );
  }

  String _getRiskMessage() {
    switch (riskAnalysisResult.riskLevel) {
      case RiskLevel.unknown:
        return '분석 기록이 없습니다';
      case RiskLevel.low:
        return '관리를 그대로 유지해주세요!';
      case RiskLevel.medium:
        return '조금 더 신경 써주세요!';
      case RiskLevel.higher:
        return '건강 관리에 주의가 필요해요!';
      case RiskLevel.high:
        return '전문의 상담을 권장드려요!';
    }
  }
}

/// 반원 게이지를 그리는 CustomPainter
class _RiskGaugePainter extends CustomPainter {
  _RiskGaugePainter({required this.percentage, required this.riskLevel});

  final int percentage;
  final RiskLevel riskLevel;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 10;
    const strokeWidth = 12.0;

    // 배경 호
    final backgroundPaint = Paint()
      ..color = AppColorScheme.white300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // 시작 각도 (왼쪽)
      math.pi, // 스윕 각도 (180도)
      false,
      backgroundPaint,
    );

    // 진행 호
    final progressColor = riskLevel.color != null
        ? Color(riskLevel.color!)
        : AppColorScheme.grey300;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = math.pi * (percentage / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RiskGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.riskLevel != riskLevel;
  }
}
