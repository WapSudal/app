import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';

/// 분석 카드 위젯
/// TODO: core 폴더에 공통 스타일로 분리 검토
class AnalysisCard extends StatelessWidget {
  const AnalysisCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

/// 분석 카드 헤더
class AnalysisCardHeader extends StatelessWidget {
  const AnalysisCardHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 28,
      alignment: Alignment.centerLeft,
      child: Text(title, style: theme.textTheme.headlineSmall),
    );
  }
}

/// 진행률 바
class AnalysisProgressBar extends StatelessWidget {
  const AnalysisProgressBar({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColorScheme.white300,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColorScheme.success,
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
    );
  }
}

/// 난이도 칩
class DifficultyChip extends StatelessWidget {
  const DifficultyChip({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = color.withValues(alpha: 0.1);
    final textColor = HSLColor.fromColor(color).withLightness(0.35).toColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 18 / 14,
          letterSpacing: -0.28,
          color: textColor,
        ),
      ),
    );
  }
}

/// 추천 칩
class RecommendedChip extends StatelessWidget {
  const RecommendedChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColorScheme.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        '추천 시나리오',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 18 / 14,
          letterSpacing: -0.28,
          color: Color(0xFF5AA558),
        ),
      ),
    );
  }
}
