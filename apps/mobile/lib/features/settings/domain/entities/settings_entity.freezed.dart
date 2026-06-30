// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotificationsConfig {
  bool get budgetAlerts => throw _privateConstructorUsedError;
  bool get goalReminders => throw _privateConstructorUsedError;
  bool get monthlySummary => throw _privateConstructorUsedError;
  bool get insights => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationsConfigCopyWith<NotificationsConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsConfigCopyWith<$Res> {
  factory $NotificationsConfigCopyWith(
          NotificationsConfig value, $Res Function(NotificationsConfig) then) =
      _$NotificationsConfigCopyWithImpl<$Res, NotificationsConfig>;
  @useResult
  $Res call(
      {bool budgetAlerts,
      bool goalReminders,
      bool monthlySummary,
      bool insights});
}

/// @nodoc
class _$NotificationsConfigCopyWithImpl<$Res, $Val extends NotificationsConfig>
    implements $NotificationsConfigCopyWith<$Res> {
  _$NotificationsConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetAlerts = null,
    Object? goalReminders = null,
    Object? monthlySummary = null,
    Object? insights = null,
  }) {
    return _then(_value.copyWith(
      budgetAlerts: null == budgetAlerts
          ? _value.budgetAlerts
          : budgetAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      goalReminders: null == goalReminders
          ? _value.goalReminders
          : goalReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      monthlySummary: null == monthlySummary
          ? _value.monthlySummary
          : monthlySummary // ignore: cast_nullable_to_non_nullable
              as bool,
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationsConfigImplCopyWith<$Res>
    implements $NotificationsConfigCopyWith<$Res> {
  factory _$$NotificationsConfigImplCopyWith(_$NotificationsConfigImpl value,
          $Res Function(_$NotificationsConfigImpl) then) =
      __$$NotificationsConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool budgetAlerts,
      bool goalReminders,
      bool monthlySummary,
      bool insights});
}

/// @nodoc
class __$$NotificationsConfigImplCopyWithImpl<$Res>
    extends _$NotificationsConfigCopyWithImpl<$Res, _$NotificationsConfigImpl>
    implements _$$NotificationsConfigImplCopyWith<$Res> {
  __$$NotificationsConfigImplCopyWithImpl(_$NotificationsConfigImpl _value,
      $Res Function(_$NotificationsConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetAlerts = null,
    Object? goalReminders = null,
    Object? monthlySummary = null,
    Object? insights = null,
  }) {
    return _then(_$NotificationsConfigImpl(
      budgetAlerts: null == budgetAlerts
          ? _value.budgetAlerts
          : budgetAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      goalReminders: null == goalReminders
          ? _value.goalReminders
          : goalReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      monthlySummary: null == monthlySummary
          ? _value.monthlySummary
          : monthlySummary // ignore: cast_nullable_to_non_nullable
              as bool,
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NotificationsConfigImpl extends _NotificationsConfig {
  const _$NotificationsConfigImpl(
      {this.budgetAlerts = true,
      this.goalReminders = true,
      this.monthlySummary = true,
      this.insights = true})
      : super._();

  @override
  @JsonKey()
  final bool budgetAlerts;
  @override
  @JsonKey()
  final bool goalReminders;
  @override
  @JsonKey()
  final bool monthlySummary;
  @override
  @JsonKey()
  final bool insights;

  @override
  String toString() {
    return 'NotificationsConfig(budgetAlerts: $budgetAlerts, goalReminders: $goalReminders, monthlySummary: $monthlySummary, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsConfigImpl &&
            (identical(other.budgetAlerts, budgetAlerts) ||
                other.budgetAlerts == budgetAlerts) &&
            (identical(other.goalReminders, goalReminders) ||
                other.goalReminders == goalReminders) &&
            (identical(other.monthlySummary, monthlySummary) ||
                other.monthlySummary == monthlySummary) &&
            (identical(other.insights, insights) ||
                other.insights == insights));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, budgetAlerts, goalReminders, monthlySummary, insights);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsConfigImplCopyWith<_$NotificationsConfigImpl> get copyWith =>
      __$$NotificationsConfigImplCopyWithImpl<_$NotificationsConfigImpl>(
          this, _$identity);
}

abstract class _NotificationsConfig extends NotificationsConfig {
  const factory _NotificationsConfig(
      {final bool budgetAlerts,
      final bool goalReminders,
      final bool monthlySummary,
      final bool insights}) = _$NotificationsConfigImpl;
  const _NotificationsConfig._() : super._();

  @override
  bool get budgetAlerts;
  @override
  bool get goalReminders;
  @override
  bool get monthlySummary;
  @override
  bool get insights;
  @override
  @JsonKey(ignore: true)
  _$$NotificationsConfigImplCopyWith<_$NotificationsConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PrivacyConfig {
  bool get showBalance => throw _privateConstructorUsedError;
  bool get showTransactions => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PrivacyConfigCopyWith<PrivacyConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyConfigCopyWith<$Res> {
  factory $PrivacyConfigCopyWith(
          PrivacyConfig value, $Res Function(PrivacyConfig) then) =
      _$PrivacyConfigCopyWithImpl<$Res, PrivacyConfig>;
  @useResult
  $Res call({bool showBalance, bool showTransactions});
}

/// @nodoc
class _$PrivacyConfigCopyWithImpl<$Res, $Val extends PrivacyConfig>
    implements $PrivacyConfigCopyWith<$Res> {
  _$PrivacyConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showBalance = null,
    Object? showTransactions = null,
  }) {
    return _then(_value.copyWith(
      showBalance: null == showBalance
          ? _value.showBalance
          : showBalance // ignore: cast_nullable_to_non_nullable
              as bool,
      showTransactions: null == showTransactions
          ? _value.showTransactions
          : showTransactions // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacyConfigImplCopyWith<$Res>
    implements $PrivacyConfigCopyWith<$Res> {
  factory _$$PrivacyConfigImplCopyWith(
          _$PrivacyConfigImpl value, $Res Function(_$PrivacyConfigImpl) then) =
      __$$PrivacyConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool showBalance, bool showTransactions});
}

/// @nodoc
class __$$PrivacyConfigImplCopyWithImpl<$Res>
    extends _$PrivacyConfigCopyWithImpl<$Res, _$PrivacyConfigImpl>
    implements _$$PrivacyConfigImplCopyWith<$Res> {
  __$$PrivacyConfigImplCopyWithImpl(
      _$PrivacyConfigImpl _value, $Res Function(_$PrivacyConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showBalance = null,
    Object? showTransactions = null,
  }) {
    return _then(_$PrivacyConfigImpl(
      showBalance: null == showBalance
          ? _value.showBalance
          : showBalance // ignore: cast_nullable_to_non_nullable
              as bool,
      showTransactions: null == showTransactions
          ? _value.showTransactions
          : showTransactions // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PrivacyConfigImpl extends _PrivacyConfig {
  const _$PrivacyConfigImpl(
      {this.showBalance = true, this.showTransactions = true})
      : super._();

  @override
  @JsonKey()
  final bool showBalance;
  @override
  @JsonKey()
  final bool showTransactions;

  @override
  String toString() {
    return 'PrivacyConfig(showBalance: $showBalance, showTransactions: $showTransactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacyConfigImpl &&
            (identical(other.showBalance, showBalance) ||
                other.showBalance == showBalance) &&
            (identical(other.showTransactions, showTransactions) ||
                other.showTransactions == showTransactions));
  }

  @override
  int get hashCode => Object.hash(runtimeType, showBalance, showTransactions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacyConfigImplCopyWith<_$PrivacyConfigImpl> get copyWith =>
      __$$PrivacyConfigImplCopyWithImpl<_$PrivacyConfigImpl>(this, _$identity);
}

abstract class _PrivacyConfig extends PrivacyConfig {
  const factory _PrivacyConfig(
      {final bool showBalance,
      final bool showTransactions}) = _$PrivacyConfigImpl;
  const _PrivacyConfig._() : super._();

  @override
  bool get showBalance;
  @override
  bool get showTransactions;
  @override
  @JsonKey(ignore: true)
  _$$PrivacyConfigImplCopyWith<_$PrivacyConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SettingsEntity {
  String get theme => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get exportFormat => throw _privateConstructorUsedError;
  NotificationsConfig get notifications => throw _privateConstructorUsedError;
  PrivacyConfig get privacy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsEntityCopyWith<SettingsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsEntityCopyWith<$Res> {
  factory $SettingsEntityCopyWith(
          SettingsEntity value, $Res Function(SettingsEntity) then) =
      _$SettingsEntityCopyWithImpl<$Res, SettingsEntity>;
  @useResult
  $Res call(
      {String theme,
      String language,
      String currency,
      String exportFormat,
      NotificationsConfig notifications,
      PrivacyConfig privacy});

  $NotificationsConfigCopyWith<$Res> get notifications;
  $PrivacyConfigCopyWith<$Res> get privacy;
}

/// @nodoc
class _$SettingsEntityCopyWithImpl<$Res, $Val extends SettingsEntity>
    implements $SettingsEntityCopyWith<$Res> {
  _$SettingsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? language = null,
    Object? currency = null,
    Object? exportFormat = null,
    Object? notifications = null,
    Object? privacy = null,
  }) {
    return _then(_value.copyWith(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      exportFormat: null == exportFormat
          ? _value.exportFormat
          : exportFormat // ignore: cast_nullable_to_non_nullable
              as String,
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as NotificationsConfig,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as PrivacyConfig,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationsConfigCopyWith<$Res> get notifications {
    return $NotificationsConfigCopyWith<$Res>(_value.notifications, (value) {
      return _then(_value.copyWith(notifications: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PrivacyConfigCopyWith<$Res> get privacy {
    return $PrivacyConfigCopyWith<$Res>(_value.privacy, (value) {
      return _then(_value.copyWith(privacy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettingsEntityImplCopyWith<$Res>
    implements $SettingsEntityCopyWith<$Res> {
  factory _$$SettingsEntityImplCopyWith(_$SettingsEntityImpl value,
          $Res Function(_$SettingsEntityImpl) then) =
      __$$SettingsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String theme,
      String language,
      String currency,
      String exportFormat,
      NotificationsConfig notifications,
      PrivacyConfig privacy});

  @override
  $NotificationsConfigCopyWith<$Res> get notifications;
  @override
  $PrivacyConfigCopyWith<$Res> get privacy;
}

/// @nodoc
class __$$SettingsEntityImplCopyWithImpl<$Res>
    extends _$SettingsEntityCopyWithImpl<$Res, _$SettingsEntityImpl>
    implements _$$SettingsEntityImplCopyWith<$Res> {
  __$$SettingsEntityImplCopyWithImpl(
      _$SettingsEntityImpl _value, $Res Function(_$SettingsEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? language = null,
    Object? currency = null,
    Object? exportFormat = null,
    Object? notifications = null,
    Object? privacy = null,
  }) {
    return _then(_$SettingsEntityImpl(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      exportFormat: null == exportFormat
          ? _value.exportFormat
          : exportFormat // ignore: cast_nullable_to_non_nullable
              as String,
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as NotificationsConfig,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as PrivacyConfig,
    ));
  }
}

/// @nodoc

class _$SettingsEntityImpl extends _SettingsEntity {
  const _$SettingsEntityImpl(
      {this.theme = 'dark',
      this.language = 'en',
      this.currency = 'USD',
      this.exportFormat = 'csv',
      this.notifications = const NotificationsConfig(),
      this.privacy = const PrivacyConfig()})
      : super._();

  @override
  @JsonKey()
  final String theme;
  @override
  @JsonKey()
  final String language;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final String exportFormat;
  @override
  @JsonKey()
  final NotificationsConfig notifications;
  @override
  @JsonKey()
  final PrivacyConfig privacy;

  @override
  String toString() {
    return 'SettingsEntity(theme: $theme, language: $language, currency: $currency, exportFormat: $exportFormat, notifications: $notifications, privacy: $privacy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsEntityImpl &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.exportFormat, exportFormat) ||
                other.exportFormat == exportFormat) &&
            (identical(other.notifications, notifications) ||
                other.notifications == notifications) &&
            (identical(other.privacy, privacy) || other.privacy == privacy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, theme, language, currency,
      exportFormat, notifications, privacy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsEntityImplCopyWith<_$SettingsEntityImpl> get copyWith =>
      __$$SettingsEntityImplCopyWithImpl<_$SettingsEntityImpl>(
          this, _$identity);
}

abstract class _SettingsEntity extends SettingsEntity {
  const factory _SettingsEntity(
      {final String theme,
      final String language,
      final String currency,
      final String exportFormat,
      final NotificationsConfig notifications,
      final PrivacyConfig privacy}) = _$SettingsEntityImpl;
  const _SettingsEntity._() : super._();

  @override
  String get theme;
  @override
  String get language;
  @override
  String get currency;
  @override
  String get exportFormat;
  @override
  NotificationsConfig get notifications;
  @override
  PrivacyConfig get privacy;
  @override
  @JsonKey(ignore: true)
  _$$SettingsEntityImplCopyWith<_$SettingsEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
