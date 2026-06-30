import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String type,
    required String title,
    required String body,
    @Default({}) Map<String, dynamic> data,
    @Default(false) bool read,
    required DateTime createdAt,
  }) = _NotificationModel;

  const NotificationModel._();

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  NotificationType get notificationType {
    switch (type) {
      case 'budget_alert':
        return NotificationType.budgetAlert;
      case 'goal_reminder':
        return NotificationType.goalReminder;
      case 'monthly_summary':
        return NotificationType.monthlySummary;
      case 'insight':
        return NotificationType.insight;
      default:
        return NotificationType.system;
    }
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) =>
      NotificationModel(
        id: entity.id,
        type: entity.type.name,
        title: entity.title,
        body: entity.body,
        data: entity.data,
        read: entity.read,
        createdAt: entity.createdAt,
      );
}

extension NotificationModelX on NotificationModel {
  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        type: notificationType,
        title: title,
        body: body,
        data: data,
        read: read,
        createdAt: createdAt,
      );
}
