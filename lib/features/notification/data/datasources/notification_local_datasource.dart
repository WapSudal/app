import '../../domain/entities/notification.dart';
import '../models/notification_model.dart';

/// 알림 로컬 데이터소스 인터페이스
abstract class NotificationLocalDataSource {
  /// 모든 알림 가져오기
  Future<List<NotificationModel>> getNotifications();

  /// 알림 읽음 처리
  Future<void> markAsRead(String notificationId);

  /// 모든 알림 읽음 처리
  Future<void> markAllAsRead();
}

/// 알림 로컬 데이터소스 구현 (모킹)
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  /// 모킹 알림 데이터
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      category: NotificationCategory.highRiskAlert,
      message: '뇌졸중 위험도가 높게 측정되었습니다. 병원 방문을 권장합니다.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      category: NotificationCategory.dataReminder,
      message: '오늘 건강 기록을 작성해주세요.',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    NotificationModel(
      id: '3',
      category: NotificationCategory.trendWarning,
      message: '최근 혈압 수치가 지속적으로 상승하고 있습니다.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: '4',
      category: NotificationCategory.generalInfo,
      message: '이번 주 위험도 분석이 완료되었습니다.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
  ];

  @override
  Future<List<NotificationModel>> getNotifications() async {
    // 실제로는 로컬 DB나 SharedPreferences에서 가져올 수 있음
    // 여기서는 모킹 데이터 반환
    await Future.delayed(const Duration(milliseconds: 100)); // 네트워크 지연 시뮬레이션
    return List.from(_notifications);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 50));
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }
}
