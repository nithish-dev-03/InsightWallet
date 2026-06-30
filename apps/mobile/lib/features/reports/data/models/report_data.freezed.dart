// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReportData _$ReportDataFromJson(Map<String, dynamic> json) {
  return _ReportData.fromJson(json);
}

/// @nodoc
mixin _$ReportData {
  double get totalIncome => throw _privateConstructorUsedError;
  double get totalExpense => throw _privateConstructorUsedError;
  double get netSavings => throw _privateConstructorUsedError;
  List<CategoryBreakdownData> get categoryBreakdown =>
      throw _privateConstructorUsedError;
  List<CashFlowData> get cashFlow => throw _privateConstructorUsedError;
  List<TrendData> get trend => throw _privateConstructorUsedError;
  List<TopCategoryData> get topCategories => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportDataCopyWith<ReportData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportDataCopyWith<$Res> {
  factory $ReportDataCopyWith(
          ReportData value, $Res Function(ReportData) then) =
      _$ReportDataCopyWithImpl<$Res, ReportData>;
  @useResult
  $Res call(
      {double totalIncome,
      double totalExpense,
      double netSavings,
      List<CategoryBreakdownData> categoryBreakdown,
      List<CashFlowData> cashFlow,
      List<TrendData> trend,
      List<TopCategoryData> topCategories});
}

/// @nodoc
class _$ReportDataCopyWithImpl<$Res, $Val extends ReportData>
    implements $ReportDataCopyWith<$Res> {
  _$ReportDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? netSavings = null,
    Object? categoryBreakdown = null,
    Object? cashFlow = null,
    Object? trend = null,
    Object? topCategories = null,
  }) {
    return _then(_value.copyWith(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      netSavings: null == netSavings
          ? _value.netSavings
          : netSavings // ignore: cast_nullable_to_non_nullable
              as double,
      categoryBreakdown: null == categoryBreakdown
          ? _value.categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdownData>,
      cashFlow: null == cashFlow
          ? _value.cashFlow
          : cashFlow // ignore: cast_nullable_to_non_nullable
              as List<CashFlowData>,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as List<TrendData>,
      topCategories: null == topCategories
          ? _value.topCategories
          : topCategories // ignore: cast_nullable_to_non_nullable
              as List<TopCategoryData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportDataImplCopyWith<$Res>
    implements $ReportDataCopyWith<$Res> {
  factory _$$ReportDataImplCopyWith(
          _$ReportDataImpl value, $Res Function(_$ReportDataImpl) then) =
      __$$ReportDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double totalIncome,
      double totalExpense,
      double netSavings,
      List<CategoryBreakdownData> categoryBreakdown,
      List<CashFlowData> cashFlow,
      List<TrendData> trend,
      List<TopCategoryData> topCategories});
}

/// @nodoc
class __$$ReportDataImplCopyWithImpl<$Res>
    extends _$ReportDataCopyWithImpl<$Res, _$ReportDataImpl>
    implements _$$ReportDataImplCopyWith<$Res> {
  __$$ReportDataImplCopyWithImpl(
      _$ReportDataImpl _value, $Res Function(_$ReportDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? netSavings = null,
    Object? categoryBreakdown = null,
    Object? cashFlow = null,
    Object? trend = null,
    Object? topCategories = null,
  }) {
    return _then(_$ReportDataImpl(
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      netSavings: null == netSavings
          ? _value.netSavings
          : netSavings // ignore: cast_nullable_to_non_nullable
              as double,
      categoryBreakdown: null == categoryBreakdown
          ? _value._categoryBreakdown
          : categoryBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdownData>,
      cashFlow: null == cashFlow
          ? _value._cashFlow
          : cashFlow // ignore: cast_nullable_to_non_nullable
              as List<CashFlowData>,
      trend: null == trend
          ? _value._trend
          : trend // ignore: cast_nullable_to_non_nullable
              as List<TrendData>,
      topCategories: null == topCategories
          ? _value._topCategories
          : topCategories // ignore: cast_nullable_to_non_nullable
              as List<TopCategoryData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportDataImpl implements _ReportData {
  const _$ReportDataImpl(
      {required this.totalIncome,
      required this.totalExpense,
      required this.netSavings,
      required final List<CategoryBreakdownData> categoryBreakdown,
      required final List<CashFlowData> cashFlow,
      required final List<TrendData> trend,
      required final List<TopCategoryData> topCategories})
      : _categoryBreakdown = categoryBreakdown,
        _cashFlow = cashFlow,
        _trend = trend,
        _topCategories = topCategories;

  factory _$ReportDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportDataImplFromJson(json);

  @override
  final double totalIncome;
  @override
  final double totalExpense;
  @override
  final double netSavings;
  final List<CategoryBreakdownData> _categoryBreakdown;
  @override
  List<CategoryBreakdownData> get categoryBreakdown {
    if (_categoryBreakdown is EqualUnmodifiableListView)
      return _categoryBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryBreakdown);
  }

  final List<CashFlowData> _cashFlow;
  @override
  List<CashFlowData> get cashFlow {
    if (_cashFlow is EqualUnmodifiableListView) return _cashFlow;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cashFlow);
  }

  final List<TrendData> _trend;
  @override
  List<TrendData> get trend {
    if (_trend is EqualUnmodifiableListView) return _trend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trend);
  }

  final List<TopCategoryData> _topCategories;
  @override
  List<TopCategoryData> get topCategories {
    if (_topCategories is EqualUnmodifiableListView) return _topCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topCategories);
  }

  @override
  String toString() {
    return 'ReportData(totalIncome: $totalIncome, totalExpense: $totalExpense, netSavings: $netSavings, categoryBreakdown: $categoryBreakdown, cashFlow: $cashFlow, trend: $trend, topCategories: $topCategories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportDataImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.netSavings, netSavings) ||
                other.netSavings == netSavings) &&
            const DeepCollectionEquality()
                .equals(other._categoryBreakdown, _categoryBreakdown) &&
            const DeepCollectionEquality().equals(other._cashFlow, _cashFlow) &&
            const DeepCollectionEquality().equals(other._trend, _trend) &&
            const DeepCollectionEquality()
                .equals(other._topCategories, _topCategories));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalIncome,
      totalExpense,
      netSavings,
      const DeepCollectionEquality().hash(_categoryBreakdown),
      const DeepCollectionEquality().hash(_cashFlow),
      const DeepCollectionEquality().hash(_trend),
      const DeepCollectionEquality().hash(_topCategories));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportDataImplCopyWith<_$ReportDataImpl> get copyWith =>
      __$$ReportDataImplCopyWithImpl<_$ReportDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportDataImplToJson(
      this,
    );
  }
}

abstract class _ReportData implements ReportData {
  const factory _ReportData(
      {required final double totalIncome,
      required final double totalExpense,
      required final double netSavings,
      required final List<CategoryBreakdownData> categoryBreakdown,
      required final List<CashFlowData> cashFlow,
      required final List<TrendData> trend,
      required final List<TopCategoryData> topCategories}) = _$ReportDataImpl;

  factory _ReportData.fromJson(Map<String, dynamic> json) =
      _$ReportDataImpl.fromJson;

  @override
  double get totalIncome;
  @override
  double get totalExpense;
  @override
  double get netSavings;
  @override
  List<CategoryBreakdownData> get categoryBreakdown;
  @override
  List<CashFlowData> get cashFlow;
  @override
  List<TrendData> get trend;
  @override
  List<TopCategoryData> get topCategories;
  @override
  @JsonKey(ignore: true)
  _$$ReportDataImplCopyWith<_$ReportDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryBreakdownData _$CategoryBreakdownDataFromJson(
    Map<String, dynamic> json) {
  return _CategoryBreakdownData.fromJson(json);
}

/// @nodoc
mixin _$CategoryBreakdownData {
  String get category => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  int get colorIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryBreakdownDataCopyWith<CategoryBreakdownData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryBreakdownDataCopyWith<$Res> {
  factory $CategoryBreakdownDataCopyWith(CategoryBreakdownData value,
          $Res Function(CategoryBreakdownData) then) =
      _$CategoryBreakdownDataCopyWithImpl<$Res, CategoryBreakdownData>;
  @useResult
  $Res call(
      {String category, double amount, double percentage, int colorIndex});
}

/// @nodoc
class _$CategoryBreakdownDataCopyWithImpl<$Res,
        $Val extends CategoryBreakdownData>
    implements $CategoryBreakdownDataCopyWith<$Res> {
  _$CategoryBreakdownDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percentage = null,
    Object? colorIndex = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      colorIndex: null == colorIndex
          ? _value.colorIndex
          : colorIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryBreakdownDataImplCopyWith<$Res>
    implements $CategoryBreakdownDataCopyWith<$Res> {
  factory _$$CategoryBreakdownDataImplCopyWith(
          _$CategoryBreakdownDataImpl value,
          $Res Function(_$CategoryBreakdownDataImpl) then) =
      __$$CategoryBreakdownDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String category, double amount, double percentage, int colorIndex});
}

/// @nodoc
class __$$CategoryBreakdownDataImplCopyWithImpl<$Res>
    extends _$CategoryBreakdownDataCopyWithImpl<$Res,
        _$CategoryBreakdownDataImpl>
    implements _$$CategoryBreakdownDataImplCopyWith<$Res> {
  __$$CategoryBreakdownDataImplCopyWithImpl(_$CategoryBreakdownDataImpl _value,
      $Res Function(_$CategoryBreakdownDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percentage = null,
    Object? colorIndex = null,
  }) {
    return _then(_$CategoryBreakdownDataImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      colorIndex: null == colorIndex
          ? _value.colorIndex
          : colorIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryBreakdownDataImpl implements _CategoryBreakdownData {
  const _$CategoryBreakdownDataImpl(
      {required this.category,
      required this.amount,
      required this.percentage,
      required this.colorIndex});

  factory _$CategoryBreakdownDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryBreakdownDataImplFromJson(json);

  @override
  final String category;
  @override
  final double amount;
  @override
  final double percentage;
  @override
  final int colorIndex;

  @override
  String toString() {
    return 'CategoryBreakdownData(category: $category, amount: $amount, percentage: $percentage, colorIndex: $colorIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryBreakdownDataImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.colorIndex, colorIndex) ||
                other.colorIndex == colorIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, category, amount, percentage, colorIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryBreakdownDataImplCopyWith<_$CategoryBreakdownDataImpl>
      get copyWith => __$$CategoryBreakdownDataImplCopyWithImpl<
          _$CategoryBreakdownDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryBreakdownDataImplToJson(
      this,
    );
  }
}

abstract class _CategoryBreakdownData implements CategoryBreakdownData {
  const factory _CategoryBreakdownData(
      {required final String category,
      required final double amount,
      required final double percentage,
      required final int colorIndex}) = _$CategoryBreakdownDataImpl;

  factory _CategoryBreakdownData.fromJson(Map<String, dynamic> json) =
      _$CategoryBreakdownDataImpl.fromJson;

  @override
  String get category;
  @override
  double get amount;
  @override
  double get percentage;
  @override
  int get colorIndex;
  @override
  @JsonKey(ignore: true)
  _$$CategoryBreakdownDataImplCopyWith<_$CategoryBreakdownDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CashFlowData _$CashFlowDataFromJson(Map<String, dynamic> json) {
  return _CashFlowData.fromJson(json);
}

/// @nodoc
mixin _$CashFlowData {
  String get month => throw _privateConstructorUsedError;
  double get income => throw _privateConstructorUsedError;
  double get expense => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CashFlowDataCopyWith<CashFlowData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashFlowDataCopyWith<$Res> {
  factory $CashFlowDataCopyWith(
          CashFlowData value, $Res Function(CashFlowData) then) =
      _$CashFlowDataCopyWithImpl<$Res, CashFlowData>;
  @useResult
  $Res call({String month, double income, double expense});
}

/// @nodoc
class _$CashFlowDataCopyWithImpl<$Res, $Val extends CashFlowData>
    implements $CashFlowDataCopyWith<$Res> {
  _$CashFlowDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? income = null,
    Object? expense = null,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashFlowDataImplCopyWith<$Res>
    implements $CashFlowDataCopyWith<$Res> {
  factory _$$CashFlowDataImplCopyWith(
          _$CashFlowDataImpl value, $Res Function(_$CashFlowDataImpl) then) =
      __$$CashFlowDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String month, double income, double expense});
}

/// @nodoc
class __$$CashFlowDataImplCopyWithImpl<$Res>
    extends _$CashFlowDataCopyWithImpl<$Res, _$CashFlowDataImpl>
    implements _$$CashFlowDataImplCopyWith<$Res> {
  __$$CashFlowDataImplCopyWithImpl(
      _$CashFlowDataImpl _value, $Res Function(_$CashFlowDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? income = null,
    Object? expense = null,
  }) {
    return _then(_$CashFlowDataImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashFlowDataImpl implements _CashFlowData {
  const _$CashFlowDataImpl(
      {required this.month, required this.income, required this.expense});

  factory _$CashFlowDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashFlowDataImplFromJson(json);

  @override
  final String month;
  @override
  final double income;
  @override
  final double expense;

  @override
  String toString() {
    return 'CashFlowData(month: $month, income: $income, expense: $expense)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashFlowDataImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, month, income, expense);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CashFlowDataImplCopyWith<_$CashFlowDataImpl> get copyWith =>
      __$$CashFlowDataImplCopyWithImpl<_$CashFlowDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashFlowDataImplToJson(
      this,
    );
  }
}

abstract class _CashFlowData implements CashFlowData {
  const factory _CashFlowData(
      {required final String month,
      required final double income,
      required final double expense}) = _$CashFlowDataImpl;

  factory _CashFlowData.fromJson(Map<String, dynamic> json) =
      _$CashFlowDataImpl.fromJson;

  @override
  String get month;
  @override
  double get income;
  @override
  double get expense;
  @override
  @JsonKey(ignore: true)
  _$$CashFlowDataImplCopyWith<_$CashFlowDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrendData _$TrendDataFromJson(Map<String, dynamic> json) {
  return _TrendData.fromJson(json);
}

/// @nodoc
mixin _$TrendData {
  String get label => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TrendDataCopyWith<TrendData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrendDataCopyWith<$Res> {
  factory $TrendDataCopyWith(TrendData value, $Res Function(TrendData) then) =
      _$TrendDataCopyWithImpl<$Res, TrendData>;
  @useResult
  $Res call({String label, double value});
}

/// @nodoc
class _$TrendDataCopyWithImpl<$Res, $Val extends TrendData>
    implements $TrendDataCopyWith<$Res> {
  _$TrendDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrendDataImplCopyWith<$Res>
    implements $TrendDataCopyWith<$Res> {
  factory _$$TrendDataImplCopyWith(
          _$TrendDataImpl value, $Res Function(_$TrendDataImpl) then) =
      __$$TrendDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, double value});
}

/// @nodoc
class __$$TrendDataImplCopyWithImpl<$Res>
    extends _$TrendDataCopyWithImpl<$Res, _$TrendDataImpl>
    implements _$$TrendDataImplCopyWith<$Res> {
  __$$TrendDataImplCopyWithImpl(
      _$TrendDataImpl _value, $Res Function(_$TrendDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
  }) {
    return _then(_$TrendDataImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrendDataImpl implements _TrendData {
  const _$TrendDataImpl({required this.label, required this.value});

  factory _$TrendDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrendDataImplFromJson(json);

  @override
  final String label;
  @override
  final double value;

  @override
  String toString() {
    return 'TrendData(label: $label, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrendDataImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, label, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrendDataImplCopyWith<_$TrendDataImpl> get copyWith =>
      __$$TrendDataImplCopyWithImpl<_$TrendDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrendDataImplToJson(
      this,
    );
  }
}

abstract class _TrendData implements TrendData {
  const factory _TrendData(
      {required final String label,
      required final double value}) = _$TrendDataImpl;

  factory _TrendData.fromJson(Map<String, dynamic> json) =
      _$TrendDataImpl.fromJson;

  @override
  String get label;
  @override
  double get value;
  @override
  @JsonKey(ignore: true)
  _$$TrendDataImplCopyWith<_$TrendDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopCategoryData _$TopCategoryDataFromJson(Map<String, dynamic> json) {
  return _TopCategoryData.fromJson(json);
}

/// @nodoc
mixin _$TopCategoryData {
  String get name => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  int get colorIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TopCategoryDataCopyWith<TopCategoryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopCategoryDataCopyWith<$Res> {
  factory $TopCategoryDataCopyWith(
          TopCategoryData value, $Res Function(TopCategoryData) then) =
      _$TopCategoryDataCopyWithImpl<$Res, TopCategoryData>;
  @useResult
  $Res call({String name, double amount, double percentage, int colorIndex});
}

/// @nodoc
class _$TopCategoryDataCopyWithImpl<$Res, $Val extends TopCategoryData>
    implements $TopCategoryDataCopyWith<$Res> {
  _$TopCategoryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
    Object? percentage = null,
    Object? colorIndex = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      colorIndex: null == colorIndex
          ? _value.colorIndex
          : colorIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopCategoryDataImplCopyWith<$Res>
    implements $TopCategoryDataCopyWith<$Res> {
  factory _$$TopCategoryDataImplCopyWith(_$TopCategoryDataImpl value,
          $Res Function(_$TopCategoryDataImpl) then) =
      __$$TopCategoryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double amount, double percentage, int colorIndex});
}

/// @nodoc
class __$$TopCategoryDataImplCopyWithImpl<$Res>
    extends _$TopCategoryDataCopyWithImpl<$Res, _$TopCategoryDataImpl>
    implements _$$TopCategoryDataImplCopyWith<$Res> {
  __$$TopCategoryDataImplCopyWithImpl(
      _$TopCategoryDataImpl _value, $Res Function(_$TopCategoryDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
    Object? percentage = null,
    Object? colorIndex = null,
  }) {
    return _then(_$TopCategoryDataImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      colorIndex: null == colorIndex
          ? _value.colorIndex
          : colorIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopCategoryDataImpl implements _TopCategoryData {
  const _$TopCategoryDataImpl(
      {required this.name,
      required this.amount,
      required this.percentage,
      required this.colorIndex});

  factory _$TopCategoryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopCategoryDataImplFromJson(json);

  @override
  final String name;
  @override
  final double amount;
  @override
  final double percentage;
  @override
  final int colorIndex;

  @override
  String toString() {
    return 'TopCategoryData(name: $name, amount: $amount, percentage: $percentage, colorIndex: $colorIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopCategoryDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.colorIndex, colorIndex) ||
                other.colorIndex == colorIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, amount, percentage, colorIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TopCategoryDataImplCopyWith<_$TopCategoryDataImpl> get copyWith =>
      __$$TopCategoryDataImplCopyWithImpl<_$TopCategoryDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopCategoryDataImplToJson(
      this,
    );
  }
}

abstract class _TopCategoryData implements TopCategoryData {
  const factory _TopCategoryData(
      {required final String name,
      required final double amount,
      required final double percentage,
      required final int colorIndex}) = _$TopCategoryDataImpl;

  factory _TopCategoryData.fromJson(Map<String, dynamic> json) =
      _$TopCategoryDataImpl.fromJson;

  @override
  String get name;
  @override
  double get amount;
  @override
  double get percentage;
  @override
  int get colorIndex;
  @override
  @JsonKey(ignore: true)
  _$$TopCategoryDataImplCopyWith<_$TopCategoryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
