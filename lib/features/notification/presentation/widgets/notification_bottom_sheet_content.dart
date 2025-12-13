import 'package:flutter/material.dart';

import '../../../../core/theme/color_scheme.dart';
import 'notification_element.dart';
import 'notification_filter.dart';

/// 알림 Bottom Sheet 컨텐츠 위젯
///
/// 타이틀, 필터, 알림 리스트를 포함합니다.
/// [AppBottomSheet]의 child로 사용됩니다.
class NotificationBottomSheetContent extends StatefulWidget {
  const NotificationBottomSheetContent({super.key});

  @override
  State<NotificationBottomSheetContent> createState() =>
      _NotificationBottomSheetContentState();
}

class _NotificationBottomSheetContentState
    extends State<NotificationBottomSheetContent> {
  NotificationFilterType _selectedFilter = NotificationFilterType.all;

  // 임시 알림 데이터
  final List<NotificationItem> _notifications = const [
    NotificationItem(
      id: '1',
      category: NotificationCategory.healthRecord,
      message: '이제 위험도 측정을 확인할 수 있어요.',
      timeAgo: '1분 전',
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      category: NotificationCategory.prediction,
      message: '이번 주 위험도 분석이 완료되었습니다.',
      timeAgo: '3시간 전',
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      category: NotificationCategory.reminder,
      message: '오늘 건강 기록을 작성해주세요.',
      timeAgo: '1일 전',
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      category: NotificationCategory.system,
      message: '앱이 최신 버전으로 업데이트되었습니다.',
      timeAgo: '3일 전',
      isRead: true,
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    switch (_selectedFilter) {
      case NotificationFilterType.all:
        return _notifications;
      case NotificationFilterType.unread:
        return _notifications.where((n) => !n.isRead).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 필터 (고정)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: NotificationFilter(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
        ),
        const SizedBox(height: 16),

        // 알림 리스트 (스크롤 가능)
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 20,
            ),
            itemCount: _filteredNotifications.isEmpty
                ? 1
                : _filteredNotifications.length,
            itemBuilder: (context, index) {
              if (_filteredNotifications.isEmpty) {
                return _buildEmptyState();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: NotificationElement(
                  notification: _filteredNotifications[index],
                  onTap: () {
                    // TODO: 알림 상세 또는 관련 화면으로 이동
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
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
            _selectedFilter == NotificationFilterType.unread
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
