/// 알림 카테고리 타입
enum NotificationCategory {
  highRiskAlert('고위험 알림', '🚨'),
  dataReminder('데이터 입력 알림', '📝'),
  trendWarning('트렌드 경고', '⚠️'),
  generalInfo('일반 정보', 'ℹ️');

  const NotificationCategory(this.label, this.emoji);
  final String label;
  final String emoji;
}

/// 알림 엔티티
class NotificationEntity {
  const NotificationEntity({
    required this.id,
    required this.category,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final NotificationCategory category;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  /// copyWith 메서드
  NotificationEntity copyWith({
    String? id,
    NotificationCategory? category,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
