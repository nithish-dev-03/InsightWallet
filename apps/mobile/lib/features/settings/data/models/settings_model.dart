import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/settings_entity.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
class NotificationsConfigModel with _$NotificationsConfigModel {
  const factory NotificationsConfigModel({
    @Default(true) bool budgetAlerts,
    @Default(true) bool goalReminders,
    @Default(true) bool monthlySummary,
    @Default(true) bool insights,
  }) = _NotificationsConfigModel;

  const NotificationsConfigModel._();

  factory NotificationsConfigModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsConfigModelFromJson(json);

  factory NotificationsConfigModel.fromEntity(NotificationsConfig entity) =>
      NotificationsConfigModel(
        budgetAlerts: entity.budgetAlerts,
        goalReminders: entity.goalReminders,
        monthlySummary: entity.monthlySummary,
        insights: entity.insights,
      );
}

extension NotificationsConfigModelX on NotificationsConfigModel {
  NotificationsConfig toEntity() => NotificationsConfig(
        budgetAlerts: budgetAlerts,
        goalReminders: goalReminders,
        monthlySummary: monthlySummary,
        insights: insights,
      );
}

@freezed
class PrivacyConfigModel with _$PrivacyConfigModel {
  const factory PrivacyConfigModel({
    @Default(true) bool showBalance,
    @Default(true) bool showTransactions,
  }) = _PrivacyConfigModel;

  const PrivacyConfigModel._();

  factory PrivacyConfigModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacyConfigModelFromJson(json);

  factory PrivacyConfigModel.fromEntity(PrivacyConfig entity) =>
      PrivacyConfigModel(
        showBalance: entity.showBalance,
        showTransactions: entity.showTransactions,
      );
}

extension PrivacyConfigModelX on PrivacyConfigModel {
  PrivacyConfig toEntity() => PrivacyConfig(
        showBalance: showBalance,
        showTransactions: showTransactions,
      );
}

@freezed
class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    @Default('dark') String theme,
    @Default('en') String language,
    @Default('USD') String currency,
    @Default('csv') String exportFormat,
    @Default(NotificationsConfigModel()) NotificationsConfigModel notifications,
    @Default(PrivacyConfigModel()) PrivacyConfigModel privacy,
  }) = _SettingsModel;

  const SettingsModel._();

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  factory SettingsModel.fromEntity(SettingsEntity entity) => SettingsModel(
        theme: entity.theme,
        language: entity.language,
        currency: entity.currency,
        exportFormat: entity.exportFormat,
        notifications:
            NotificationsConfigModel.fromEntity(entity.notifications),
        privacy: PrivacyConfigModel.fromEntity(entity.privacy),
      );
}

extension SettingsModelX on SettingsModel {
  SettingsEntity toEntity() => SettingsEntity(
        theme: theme,
        language: language,
        currency: currency,
        exportFormat: exportFormat,
        notifications: notifications.toEntity(),
        privacy: privacy.toEntity(),
      );
}
