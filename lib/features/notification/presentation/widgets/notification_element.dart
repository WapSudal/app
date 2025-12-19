import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';
import '../../domain/entities/notification.dart';

/// 알림 리스트 아이템 위젯
///
/// Figma 디자인 기준:
/// - 아이콘 (20x20) + 설명 영역
/// - 읽지 않음 표시: 파란 점 (8x8)
/// - 배경: white200 (#F8F9FB)
/// - border radius: 12px
/// - padding: 16px
class NotificationElement extends StatelessWidget {
  const NotificationElement({
    super.key,
    required this.notification,
    this.onTap,
  });

  final NotificationEntity notification;
  final VoidCallback? onTap;

  /// 시간 차이를 한국어 문자열로 변환
  String _getTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}일 전';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months개월 전';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years년 전';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColorScheme.white200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 아이콘 (이모지)
                _buildIcon(),
                const SizedBox(width: 8),

                // 설명 영역
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: Center(
        child: Text(
          notification.category.emoji,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 카테고리 & 시간 행
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 카테고리
            Text(
              notification.category.label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'Pretendard',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 18 / 11,
                letterSpacing: -0.25,
                color: AppColorScheme.grey300,
              ),
            ),

            // 읽지 않음 표시 + 시간
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!notification.isRead) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColorScheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  _getTimeAgo(notification.createdAt),
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    height: 18 / 11,
                    letterSpacing: -0.25,
                    color: AppColorScheme.grey300,
                  ),
                ),
              ],
            ),
          ],
        ),

        // 메시지
        Text(
          notification.message,
          style: const TextStyle(
            fontFamily: 'Pretendard Variable',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 18 / 14,
            letterSpacing: -0.28,
            color: AppColorScheme.black100,
          ),
        ),
      ],
    );
  }
}
