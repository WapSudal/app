import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';

/// 알림 Repository 구현
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      final notifications = await localDataSource.getNotifications();
      return notifications;
    } catch (e) {
      // 에러 처리 (실제로는 커스텀 Exception을 던질 수 있음)
      rethrow;
    }
  }

  @override
  Future<List<NotificationEntity>> getUnreadNotifications() async {
    try {
      final notifications = await localDataSource.getNotifications();
      return notifications.where((n) => !n.isRead).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await localDataSource.markAsRead(notificationId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await localDataSource.markAllAsRead();
    } catch (e) {
      rethrow;
    }
  }
}
