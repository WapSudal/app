import '../entities/notification.dart';

/// 알림 Repository 인터페이스
abstract class NotificationRepository {
  /// 모든 알림 가져오기
  Future<List<NotificationEntity>> getNotifications();

  /// 읽지 않은 알림 가져오기
  Future<List<NotificationEntity>> getUnreadNotifications();

  /// 알림 읽음 처리
  Future<void> markAsRead(String notificationId);

  /// 모든 알림 읽음 처리
  Future<void> markAllAsRead();
}
