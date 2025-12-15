import 'package:flutter/material.dart';
import '../../../../../core/theme/color_scheme.dart';
import '../../../../../gen/assets.gen.dart';

/// 진행 상태 카드 (1~2개 기록 시)
///
/// Figma: Home/Progress
/// - 분석 가능까지 필요한 기록 수 표시
/// - 프로그레스바 표시
/// - 데이터 없음 안내
class HomeProgressCard extends StatelessWidget {
  const HomeProgressCard({
    super.key,
    required this.recordCount,
    required this.recordsNeeded,
    this.onInputPressed,
  });

  /// 현재 기록 개수
  final int recordCount;

  /// 분석 가능까지 필요한 기록 개수
  final int recordsNeeded;

  /// 정보 입력 버튼 콜백
  final VoidCallback? onInputPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단: 텍스트 + 버튼
          _buildHeader(context),
          const SizedBox(height: 16),
          // 프로그레스바
          _buildProgressBar(),
          const SizedBox(height: 24),
          // 데이터 없음 카드
          _buildNoDataCard(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '분석 가능 상태까지',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColorScheme.grey200,
                letterSpacing: -0.32,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${recordsNeeded}개의 건강 정보 필요',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColorScheme.primaryColor,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.45,
              ),
            ),
          ],
        ),
        // 정보 입력 버튼
        GestureDetector(
          onTap: onInputPressed,
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColorScheme.white200,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '정보 입력',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColorScheme.grey200,
                letterSpacing: -0.32,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    // 진행률 계산 (0~3개 기준)
    final progress = recordCount / 3;

    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: AppColorScheme.white300,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final progressWidth = constraints.maxWidth * progress.clamp(0.0, 1.0);
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: progressWidth,
              height: 10,
              decoration: BoxDecoration(
                color: AppColorScheme.success,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoDataCard(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: AppColorScheme.white500,
        strokeWidth: 1.5,
        borderRadius: 12,
        dashWidth: 6,
        dashSpace: 4,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘
            Assets.icons.compass.svg(
              width: 72,
              height: 72,
              colorFilter: ColorFilter.mode(
                AppColorScheme.grey500,
                BlendMode.srcIn,
              ),
            ),
            // 텍스트
            Text(
              '아직 데이터가 없네요',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColorScheme.grey300,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '꾸준히 건강 데이터를 입력해주세요!',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColorScheme.grey500),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashed border를 그리는 CustomPainter
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashSpace,
  });

  final Color color;
  final double strokeWidth;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    // 대시 패턴 적용
    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
