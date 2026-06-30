import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';

enum NotificationType {
  budgetAlert,
  goalReminder,
  monthlySummary,
  insight,
  system,
}

@freezed
class NotificationEntity with _$NotificationEntity {
  const factory NotificationEntity({
    required String id,
    required NotificationType type,
    required String title,
    required String body,
    @Default({}) Map<String, dynamic> data,
    @Default(false) bool read,
    required DateTime createdAt,
  }) = _NotificationEntity;

  const NotificationEntity._();
}
