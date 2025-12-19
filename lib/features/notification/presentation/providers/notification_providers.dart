import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/notification_data_providers.dart';
import '../../domain/entities/notification.dart';
import '../widgets/notification_filter.dart';

part 'notification_providers.g.dart';

/// 알림 목록 상태 관리 Provider
@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  @override
  Future<List<NotificationEntity>> build() async {
    final repository = ref.read(notificationRepositoryProvider);
    return await repository.getNotifications();
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// 알림 읽음 처리
  Future<void> markAsRead(String notificationId) async {
    final repository = ref.read(notificationRepositoryProvider);
    await repository.markAsRead(notificationId);

    // 상태 업데이트
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncValue.data(
        currentState.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList(),
      );
    }
  }

  /// 모든 알림 읽음 처리
  Future<void> markAllAsRead() async {
    final repository = ref.read(notificationRepositoryProvider);
    await repository.markAllAsRead();

    // 상태 업데이트
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncValue.data(
        currentState.map((notification) {
          return notification.copyWith(isRead: true);
        }).toList(),
      );
    }
  }
}

/// 알림 필터 상태 Provider
@riverpod
class NotificationFilterNotifier extends _$NotificationFilterNotifier {
  @override
  NotificationFilterType build() {
    return NotificationFilterType.all;
  }

  /// 필터 변경
  void setFilter(NotificationFilterType filter) {
    state = filter;
  }
}

/// 필터링된 알림 목록 Provider
@riverpod
Future<List<NotificationEntity>> filteredNotifications(Ref ref) async {
  // AsyncValue에서 데이터를 가져올 때까지 대기
  final notificationsAsync = ref.watch(notificationProvider);

  // AsyncValue가 data 상태일 때만 필터링
  if (!notificationsAsync.hasValue) {
    return [];
  }

  final notifications = notificationsAsync.value!;
  final filter = ref.watch(notificationFilterProvider);

  switch (filter) {
    case NotificationFilterType.all:
      return notifications;
    case NotificationFilterType.unread:
      return notifications.where((n) => !n.isRead).toList();
  }
}
