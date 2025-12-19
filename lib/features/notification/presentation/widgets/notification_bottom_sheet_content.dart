import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/color_scheme.dart';
import '../providers/notification_providers.dart';
import 'notification_element.dart';
import 'notification_filter.dart';

/// 알림 Bottom Sheet 컨텐츠 위젯
///
/// 타이틀, 필터, 알림 리스트를 포함합니다.
/// [AppBottomSheet]의 child로 사용됩니다.
class NotificationBottomSheetContent extends ConsumerWidget {
  const NotificationBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(notificationFilterProvider);
    final filteredNotificationsAsync = ref.watch(filteredNotificationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 필터 (고정)
        NotificationFilter(
          selectedFilter: selectedFilter,
          onFilterChanged: (filter) {
            ref.read(notificationFilterProvider.notifier).setFilter(filter);
          },
        ),
        const SizedBox(height: 16),

        // 알림 리스트 (스크롤 가능)
        Expanded(
          child: filteredNotificationsAsync.when(
            data: (notifications) {
              if (notifications.isEmpty) {
                return _buildEmptyState(selectedFilter);
              }
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: NotificationElement(
                      notification: notifications[index],
                      onTap: () {
                        // 알림 읽음 처리
                        ref
                            .read(notificationProvider.notifier)
                            .markAsRead(notifications[index].id);
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('알림을 불러오는데 실패했습니다: $error'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(NotificationFilterType selectedFilter) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 48,
            color: AppColorScheme.grey400,
          ),
          const SizedBox(height: 12),
          Text(
            selectedFilter == NotificationFilterType.unread
                ? '읽지 않은 알림이 없습니다'
                : '알림이 없습니다',
            style: const TextStyle(
              fontFamily: 'Pretendard Variable',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColorScheme.grey300,
            ),
          ),
        ],
      ),
    );
  }
}
