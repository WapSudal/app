import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/analysis_status_entity.dart';
import 'analysis_common_widgets.dart';

/// 분석 빈 상태 카드 (데이터 부족)
///
/// Figma: Analyze - 1 (Card/None)
/// 분석에 필요한 건강 데이터가 부족할 때 표시되는 카드입니다.
/// 진행 상태 헤더, 프로그레스 바, 빈 상태 메시지를 포함합니다.
class AnalysisEmptyCard extends StatelessWidget {
  const AnalysisEmptyCard({super.key, required this.analysisStatus});

  final AnalysisStatusEntity analysisStatus;

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
        children: [
          // 진행 상태 헤더
          _buildProgressHeader(context),
          const SizedBox(height: 16),
          // 진행 바
          AnalysisProgressBar(progress: analysisStatus.progress),
          const SizedBox(height: 12),
          // 빈 상태 카드
          Expanded(child: _buildEmptyStateCard(context)),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '분석 가능 상태까지',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColorScheme.grey200),
            ),
            const SizedBox(height: 4),
            Text(
              '${analysisStatus.recordsNeeded}개의 건강 정보 필요',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColorScheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        _buildInfoButton(context),
      ],
    );
  }

  Widget _buildInfoButton(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColorScheme.white200,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        '정보 입력',
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: AppColorScheme.grey300),
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(9),
              child: Assets.icons.compass.svg(
                width: 72,
                height: 72,
                colorFilter: ColorFilter.mode(
                  AppColorScheme.grey500,
                  BlendMode.srcIn,
                ),
              ),
            ),
            // 텍스트 영역
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

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);

    // Dashed path 생성
    final dashedPath = _createDashedPath(path);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source) {
    final dashedPath = Path();
    final pathMetrics = source.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0;
      bool draw = true;

      while (distance < metric.length) {
        final length = draw ? dashWidth : dashSpace;
        if (draw) {
          dashedPath.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }

    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
