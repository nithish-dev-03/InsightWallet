// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationsConfigModelImpl _$$NotificationsConfigModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationsConfigModelImpl(
      budgetAlerts: json['budgetAlerts'] as bool? ?? true,
      goalReminders: json['goalReminders'] as bool? ?? true,
      monthlySummary: json['monthlySummary'] as bool? ?? true,
      insights: json['insights'] as bool? ?? true,
    );

Map<String, dynamic> _$$NotificationsConfigModelImplToJson(
        _$NotificationsConfigModelImpl instance) =>
    <String, dynamic>{
      'budgetAlerts': instance.budgetAlerts,
      'goalReminders': instance.goalReminders,
      'monthlySummary': instance.monthlySummary,
      'insights': instance.insights,
    };

_$PrivacyConfigModelImpl _$$PrivacyConfigModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PrivacyConfigModelImpl(
      showBalance: json['showBalance'] as bool? ?? true,
      showTransactions: json['showTransactions'] as bool? ?? true,
    );

Map<String, dynamic> _$$PrivacyConfigModelImplToJson(
        _$PrivacyConfigModelImpl instance) =>
    <String, dynamic>{
      'showBalance': instance.showBalance,
      'showTransactions': instance.showTransactions,
    };

_$SettingsModelImpl _$$SettingsModelImplFromJson(Map<String, dynamic> json) =>
    _$SettingsModelImpl(
      theme: json['theme'] as String? ?? 'dark',
      language: json['language'] as String? ?? 'en',
      currency: json['currency'] as String? ?? 'USD',
      exportFormat: json['exportFormat'] as String? ?? 'csv',
      notifications: json['notifications'] == null
          ? const NotificationsConfigModel()
          : NotificationsConfigModel.fromJson(
              json['notifications'] as Map<String, dynamic>),
      privacy: json['privacy'] == null
          ? const PrivacyConfigModel()
          : PrivacyConfigModel.fromJson(
              json['privacy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SettingsModelImplToJson(_$SettingsModelImpl instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'language': instance.language,
      'currency': instance.currency,
      'exportFormat': instance.exportFormat,
      'notifications': instance.notifications,
      'privacy': instance.privacy,
    };
