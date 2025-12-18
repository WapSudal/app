import 'package:flutter/material.dart';
import '../../theme/color_scheme.dart';
import '../../../gen/assets.gen.dart';

/// 데이터/환자 없음 카드
/// 환자, 보호자, 주치의 역할 공통.
///
/// Figma: Card/None
class NoDataPaint extends StatelessWidget {
  const NoDataPaint({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: double.infinity,
    //   padding: const EdgeInsets.all(16),
    //   decoration: BoxDecoration(
    //     color: AppColorScheme.white100,
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    //   child:
    // );

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
              padding: EdgeInsets.all(9),
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
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColorScheme.grey300,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subtitle,
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
