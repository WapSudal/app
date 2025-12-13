import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';

/// 알림 카테고리 타입
enum NotificationCategory {
  healthRecord('건강 기록', '✅️'),
  prediction('위험도 예측', '📊'),
  reminder('리마인더', '⏰'),
  system('시스템', '⚙️');

  const NotificationCategory(this.label, this.emoji);
  final String label;
  final String emoji;
}

/// 알림 데이터 모델 (임시)
class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.category,
    required this.message,
    required this.timeAgo,
    this.isRead = false,
  });

  final String id;
  final NotificationCategory category;
  final String message;
  final String timeAgo;
  final bool isRead;
}

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

  final NotificationItem notification;
  final VoidCallback? onTap;

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
              style: const TextStyle(
                fontFamily: 'Pretendard Variable',
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
                  notification.timeAgo,
                  style: const TextStyle(
                    fontFamily: 'Pretendard Variable',
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
