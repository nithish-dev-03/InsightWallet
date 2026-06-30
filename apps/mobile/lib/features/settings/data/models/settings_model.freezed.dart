// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationsConfigModel _$NotificationsConfigModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationsConfigModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationsConfigModel {
  bool get budgetAlerts => throw _privateConstructorUsedError;
  bool get goalReminders => throw _privateConstructorUsedError;
  bool get monthlySummary => throw _privateConstructorUsedError;
  bool get insights => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationsConfigModelCopyWith<NotificationsConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsConfigModelCopyWith<$Res> {
  factory $NotificationsConfigModelCopyWith(NotificationsConfigModel value,
          $Res Function(NotificationsConfigModel) then) =
      _$NotificationsConfigModelCopyWithImpl<$Res, NotificationsConfigModel>;
  @useResult
  $Res call(
      {bool budgetAlerts,
      bool goalReminders,
      bool monthlySummary,
      bool insights});
}

/// @nodoc
class _$NotificationsConfigModelCopyWithImpl<$Res,
        $Val extends NotificationsConfigModel>
    implements $NotificationsConfigModelCopyWith<$Res> {
  _$NotificationsConfigModelCopyWithImpl(this._value, this._then);

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
abstract class _$$NotificationsConfigModelImplCopyWith<$Res>
    implements $NotificationsConfigModelCopyWith<$Res> {
  factory _$$NotificationsConfigModelImplCopyWith(
          _$NotificationsConfigModelImpl value,
          $Res Function(_$NotificationsConfigModelImpl) then) =
      __$$NotificationsConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool budgetAlerts,
      bool goalReminders,
      bool monthlySummary,
      bool insights});
}

/// @nodoc
class __$$NotificationsConfigModelImplCopyWithImpl<$Res>
    extends _$NotificationsConfigModelCopyWithImpl<$Res,
        _$NotificationsConfigModelImpl>
    implements _$$NotificationsConfigModelImplCopyWith<$Res> {
  __$$NotificationsConfigModelImplCopyWithImpl(
      _$NotificationsConfigModelImpl _value,
      $Res Function(_$NotificationsConfigModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgetAlerts = null,
    Object? goalReminders = null,
    Object? monthlySummary = null,
    Object? insights = null,
  }) {
    return _then(_$NotificationsConfigModelImpl(
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
@JsonSerializable()
class _$NotificationsConfigModelImpl extends _NotificationsConfigModel {
  const _$NotificationsConfigModelImpl(
      {this.budgetAlerts = true,
      this.goalReminders = true,
      this.monthlySummary = true,
      this.insights = true})
      : super._();

  factory _$NotificationsConfigModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationsConfigModelImplFromJson(json);

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
    return 'NotificationsConfigModel(budgetAlerts: $budgetAlerts, goalReminders: $goalReminders, monthlySummary: $monthlySummary, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsConfigModelImpl &&
            (identical(other.budgetAlerts, budgetAlerts) ||
                other.budgetAlerts == budgetAlerts) &&
            (identical(other.goalReminders, goalReminders) ||
                other.goalReminders == goalReminders) &&
            (identical(other.monthlySummary, monthlySummary) ||
                other.monthlySummary == monthlySummary) &&
            (identical(other.insights, insights) ||
                other.insights == insights));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, budgetAlerts, goalReminders, monthlySummary, insights);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsConfigModelImplCopyWith<_$NotificationsConfigModelImpl>
      get copyWith => __$$NotificationsConfigModelImplCopyWithImpl<
          _$NotificationsConfigModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationsConfigModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationsConfigModel extends NotificationsConfigModel {
  const factory _NotificationsConfigModel(
      {final bool budgetAlerts,
      final bool goalReminders,
      final bool monthlySummary,
      final bool insights}) = _$NotificationsConfigModelImpl;
  const _NotificationsConfigModel._() : super._();

  factory _NotificationsConfigModel.fromJson(Map<String, dynamic> json) =
      _$NotificationsConfigModelImpl.fromJson;

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
  _$$NotificationsConfigModelImplCopyWith<_$NotificationsConfigModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PrivacyConfigModel _$PrivacyConfigModelFromJson(Map<String, dynamic> json) {
  return _PrivacyConfigModel.fromJson(json);
}

/// @nodoc
mixin _$PrivacyConfigModel {
  bool get showBalance => throw _privateConstructorUsedError;
  bool get showTransactions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrivacyConfigModelCopyWith<PrivacyConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyConfigModelCopyWith<$Res> {
  factory $PrivacyConfigModelCopyWith(
          PrivacyConfigModel value, $Res Function(PrivacyConfigModel) then) =
      _$PrivacyConfigModelCopyWithImpl<$Res, PrivacyConfigModel>;
  @useResult
  $Res call({bool showBalance, bool showTransactions});
}

/// @nodoc
class _$PrivacyConfigModelCopyWithImpl<$Res, $Val extends PrivacyConfigModel>
    implements $PrivacyConfigModelCopyWith<$Res> {
  _$PrivacyConfigModelCopyWithImpl(this._value, this._then);

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
abstract class _$$PrivacyConfigModelImplCopyWith<$Res>
    implements $PrivacyConfigModelCopyWith<$Res> {
  factory _$$PrivacyConfigModelImplCopyWith(_$PrivacyConfigModelImpl value,
          $Res Function(_$PrivacyConfigModelImpl) then) =
      __$$PrivacyConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool showBalance, bool showTransactions});
}

/// @nodoc
class __$$PrivacyConfigModelImplCopyWithImpl<$Res>
    extends _$PrivacyConfigModelCopyWithImpl<$Res, _$PrivacyConfigModelImpl>
    implements _$$PrivacyConfigModelImplCopyWith<$Res> {
  __$$PrivacyConfigModelImplCopyWithImpl(_$PrivacyConfigModelImpl _value,
      $Res Function(_$PrivacyConfigModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showBalance = null,
    Object? showTransactions = null,
  }) {
    return _then(_$PrivacyConfigModelImpl(
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
@JsonSerializable()
class _$PrivacyConfigModelImpl extends _PrivacyConfigModel {
  const _$PrivacyConfigModelImpl(
      {this.showBalance = true, this.showTransactions = true})
      : super._();

  factory _$PrivacyConfigModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacyConfigModelImplFromJson(json);

  @override
  @JsonKey()
  final bool showBalance;
  @override
  @JsonKey()
  final bool showTransactions;

  @override
  String toString() {
    return 'PrivacyConfigModel(showBalance: $showBalance, showTransactions: $showTransactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacyConfigModelImpl &&
            (identical(other.showBalance, showBalance) ||
                other.showBalance == showBalance) &&
            (identical(other.showTransactions, showTransactions) ||
                other.showTransactions == showTransactions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, showBalance, showTransactions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacyConfigModelImplCopyWith<_$PrivacyConfigModelImpl> get copyWith =>
      __$$PrivacyConfigModelImplCopyWithImpl<_$PrivacyConfigModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacyConfigModelImplToJson(
      this,
    );
  }
}

abstract class _PrivacyConfigModel extends PrivacyConfigModel {
  const factory _PrivacyConfigModel(
      {final bool showBalance,
      final bool showTransactions}) = _$PrivacyConfigModelImpl;
  const _PrivacyConfigModel._() : super._();

  factory _PrivacyConfigModel.fromJson(Map<String, dynamic> json) =
      _$PrivacyConfigModelImpl.fromJson;

  @override
  bool get showBalance;
  @override
  bool get showTransactions;
  @override
  @JsonKey(ignore: true)
  _$$PrivacyConfigModelImplCopyWith<_$PrivacyConfigModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) {
  return _SettingsModel.fromJson(json);
}

/// @nodoc
mixin _$SettingsModel {
  String get theme => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get exportFormat => throw _privateConstructorUsedError;
  NotificationsConfigModel get notifications =>
      throw _privateConstructorUsedError;
  PrivacyConfigModel get privacy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingsModelCopyWith<SettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsModelCopyWith<$Res> {
  factory $SettingsModelCopyWith(
          SettingsModel value, $Res Function(SettingsModel) then) =
      _$SettingsModelCopyWithImpl<$Res, SettingsModel>;
  @useResult
  $Res call(
      {String theme,
      String language,
      String currency,
      String exportFormat,
      NotificationsConfigModel notifications,
      PrivacyConfigModel privacy});

  $NotificationsConfigModelCopyWith<$Res> get notifications;
  $PrivacyConfigModelCopyWith<$Res> get privacy;
}

/// @nodoc
class _$SettingsModelCopyWithImpl<$Res, $Val extends SettingsModel>
    implements $SettingsModelCopyWith<$Res> {
  _$SettingsModelCopyWithImpl(this._value, this._then);

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
              as NotificationsConfigModel,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as PrivacyConfigModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationsConfigModelCopyWith<$Res> get notifications {
    return $NotificationsConfigModelCopyWith<$Res>(_value.notifications,
        (value) {
      return _then(_value.copyWith(notifications: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PrivacyConfigModelCopyWith<$Res> get privacy {
    return $PrivacyConfigModelCopyWith<$Res>(_value.privacy, (value) {
      return _then(_value.copyWith(privacy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SettingsModelImplCopyWith<$Res>
    implements $SettingsModelCopyWith<$Res> {
  factory _$$SettingsModelImplCopyWith(
          _$SettingsModelImpl value, $Res Function(_$SettingsModelImpl) then) =
      __$$SettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String theme,
      String language,
      String currency,
      String exportFormat,
      NotificationsConfigModel notifications,
      PrivacyConfigModel privacy});

  @override
  $NotificationsConfigModelCopyWith<$Res> get notifications;
  @override
  $PrivacyConfigModelCopyWith<$Res> get privacy;
}

/// @nodoc
class __$$SettingsModelImplCopyWithImpl<$Res>
    extends _$SettingsModelCopyWithImpl<$Res, _$SettingsModelImpl>
    implements _$$SettingsModelImplCopyWith<$Res> {
  __$$SettingsModelImplCopyWithImpl(
      _$SettingsModelImpl _value, $Res Function(_$SettingsModelImpl) _then)
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
    return _then(_$SettingsModelImpl(
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
              as NotificationsConfigModel,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as PrivacyConfigModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingsModelImpl extends _SettingsModel {
  const _$SettingsModelImpl(
      {this.theme = 'dark',
      this.language = 'en',
      this.currency = 'USD',
      this.exportFormat = 'csv',
      this.notifications = const NotificationsConfigModel(),
      this.privacy = const PrivacyConfigModel()})
      : super._();

  factory _$SettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingsModelImplFromJson(json);

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
  final NotificationsConfigModel notifications;
  @override
  @JsonKey()
  final PrivacyConfigModel privacy;

  @override
  String toString() {
    return 'SettingsModel(theme: $theme, language: $language, currency: $currency, exportFormat: $exportFormat, notifications: $notifications, privacy: $privacy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsModelImpl &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, theme, language, currency,
      exportFormat, notifications, privacy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsModelImplCopyWith<_$SettingsModelImpl> get copyWith =>
      __$$SettingsModelImplCopyWithImpl<_$SettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingsModelImplToJson(
      this,
    );
  }
}

abstract class _SettingsModel extends SettingsModel {
  const factory _SettingsModel(
      {final String theme,
      final String language,
      final String currency,
      final String exportFormat,
      final NotificationsConfigModel notifications,
      final PrivacyConfigModel privacy}) = _$SettingsModelImpl;
  const _SettingsModel._() : super._();

  factory _SettingsModel.fromJson(Map<String, dynamic> json) =
      _$SettingsModelImpl.fromJson;

  @override
  String get theme;
  @override
  String get language;
  @override
  String get currency;
  @override
  String get exportFormat;
  @override
  NotificationsConfigModel get notifications;
  @override
  PrivacyConfigModel get privacy;
  @override
  @JsonKey(ignore: true)
  _$$SettingsModelImplCopyWith<_$SettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
