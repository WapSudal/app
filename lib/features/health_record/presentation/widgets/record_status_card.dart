import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';
import '../providers/health_record_state.dart';

/// 상태 카드 위젯
///
/// Figma: Record - 2 (Card/Property 1=Good)
/// 이모지 + 상태 타이틀 + 설명 메시지를 표시합니다.
class RecordStatusCard extends StatelessWidget {
  const RecordStatusCard({super.key, required this.healthStatus});

  final HealthStatusLevel healthStatus;

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
          // 이모지
          Text(healthStatus.emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 12),
          // 타이틀
          Text(
            healthStatus.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColorScheme.black100,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.55,
            ),
          ),
          const SizedBox(height: 8),
          // 설명
          Text(
            healthStatus.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColorScheme.grey300,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }
}
