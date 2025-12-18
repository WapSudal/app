import 'package:flutter/material.dart';
import '../../../../core/theme/color_scheme.dart';

/// 이번 주 기록 통계 카드
///
/// Figma: Vertical Card (node-id=467:3765, 467:3772)
/// - 이번 주 작성 기록
/// - 읽지 않은 알림 (목업)
class GeneralHomeWeeklyStatsCard extends StatelessWidget {
  const GeneralHomeWeeklyStatsCard({
    super.key,
    required this.weeklyRecordCount,
    this.unreadNotificationCount = 0,
  });

  /// 이번 주 작성 기록 개수
  final int weeklyRecordCount;

  /// 읽지 않은 알림 개수 (목업)
  final int unreadNotificationCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 이번 주 작성 기록
        Expanded(
          child: _buildStatCard(
            context: context,
            label: '이번 주 작성 기록',
            count: weeklyRecordCount,
            showIcon: true,
          ),
        ),
        const SizedBox(width: 8),
        // 읽지 않은 알림
        Expanded(
          child: _buildStatCard(
            context: context,
            label: '읽지 않은 알림',
            count: unreadNotificationCount,
            showIcon: false,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String label,
    required int count,
    required bool showIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorScheme.white100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (showIcon) ...[_buildEmojiIcon(count), const SizedBox(width: 16)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColorScheme.grey300,
                    letterSpacing: -0.35,
                  ),
                ),
                Text(
                  '$count개',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColorScheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiIcon(int count) {
    // 기록 개수에 따른 이모지 표시
    // 0개: 졸린 이모지, 1-2개: 약간 졸린 이모지, 3개 이상: 화이팅 이모지
    final emoji = count == 0 ? '😴' : (count < 3 ? '💤' : '💪');

    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }
}
