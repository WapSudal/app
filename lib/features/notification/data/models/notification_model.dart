import '../../domain/entities/notification.dart';

/// 알림 모델 (Data Layer)
class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.category,
    required super.message,
    required super.createdAt,
    super.isRead,
  });

  /// JSON에서 NotificationModel 생성
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      category: NotificationCategory.values.firstWhere(
        (c) => c.name == json['category'],
      ),
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  /// NotificationModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  /// Entity에서 Model 생성
  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      category: entity.category,
      message: entity.message,
      createdAt: entity.createdAt,
      isRead: entity.isRead,
    );
  }

  /// copyWith 오버라이드
  @override
  NotificationModel copyWith({
    String? id,
    NotificationCategory? category,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      category: category ?? this.category,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
