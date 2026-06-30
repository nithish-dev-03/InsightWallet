import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_entity.freezed.dart';

@freezed
class NotificationsConfig with _$NotificationsConfig {
  const factory NotificationsConfig({
    @Default(true) bool budgetAlerts,
    @Default(true) bool goalReminders,
    @Default(true) bool monthlySummary,
    @Default(true) bool insights,
  }) = _NotificationsConfig;

  const NotificationsConfig._();
}

@freezed
class PrivacyConfig with _$PrivacyConfig {
  const factory PrivacyConfig({
    @Default(true) bool showBalance,
    @Default(true) bool showTransactions,
  }) = _PrivacyConfig;

  const PrivacyConfig._();
}

@freezed
class SettingsEntity with _$SettingsEntity {
  const factory SettingsEntity({
    @Default('dark') String theme,
    @Default('en') String language,
    @Default('USD') String currency,
    @Default('csv') String exportFormat,
    @Default(NotificationsConfig()) NotificationsConfig notifications,
    @Default(PrivacyConfig()) PrivacyConfig privacy,
  }) = _SettingsEntity;

  const SettingsEntity._();
}
