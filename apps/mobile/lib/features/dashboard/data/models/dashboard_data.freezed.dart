// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) {
  return _DashboardData.fromJson(json);
}

/// @nodoc
mixin _$DashboardData {
  double get balance => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_income')
  double get monthlyIncome => throw _privateConstructorUsedError;
  @JsonKey(name: 'monthly_expense')
  double get monthlyExpense => throw _privateConstructorUsedError;
  double get savings => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_remaining')
  double get budgetRemaining => throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_transactions')
  List<TransactionSummary> get recentTransactions =>
      throw _privateConstructorUsedError;
  String get insight => throw _privateConstructorUsedError;
  @JsonKey(name: 'chart_data')
  List<double> get chartData => throw _privateConstructorUsedError;
  @JsonKey(name: 'spending_breakdown')
  List<CategoryBreakdown> get spendingBreakdown =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardDataCopyWith<DashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardDataCopyWith<$Res> {
  factory $DashboardDataCopyWith(
          DashboardData value, $Res Function(DashboardData) then) =
      _$DashboardDataCopyWithImpl<$Res, DashboardData>;
  @useResult
  $Res call(
      {double balance,
      @JsonKey(name: 'monthly_income') double monthlyIncome,
      @JsonKey(name: 'monthly_expense') double monthlyExpense,
      double savings,
      @JsonKey(name: 'budget_remaining') double budgetRemaining,
      @JsonKey(name: 'recent_transactions')
      List<TransactionSummary> recentTransactions,
      String insight,
      @JsonKey(name: 'chart_data') List<double> chartData,
      @JsonKey(name: 'spending_breakdown')
      List<CategoryBreakdown> spendingBreakdown});
}

/// @nodoc
class _$DashboardDataCopyWithImpl<$Res, $Val extends DashboardData>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balance = null,
    Object? monthlyIncome = null,
    Object? monthlyExpense = null,
    Object? savings = null,
    Object? budgetRemaining = null,
    Object? recentTransactions = null,
    Object? insight = null,
    Object? chartData = null,
    Object? spendingBreakdown = null,
  }) {
    return _then(_value.copyWith(
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyIncome: null == monthlyIncome
          ? _value.monthlyIncome
          : monthlyIncome // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyExpense: null == monthlyExpense
          ? _value.monthlyExpense
          : monthlyExpense // ignore: cast_nullable_to_non_nullable
              as double,
      savings: null == savings
          ? _value.savings
          : savings // ignore: cast_nullable_to_non_nullable
              as double,
      budgetRemaining: null == budgetRemaining
          ? _value.budgetRemaining
          : budgetRemaining // ignore: cast_nullable_to_non_nullable
              as double,
      recentTransactions: null == recentTransactions
          ? _value.recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionSummary>,
      insight: null == insight
          ? _value.insight
          : insight // ignore: cast_nullable_to_non_nullable
              as String,
      chartData: null == chartData
          ? _value.chartData
          : chartData // ignore: cast_nullable_to_non_nullable
              as List<double>,
      spendingBreakdown: null == spendingBreakdown
          ? _value.spendingBreakdown
          : spendingBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdown>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardDataImplCopyWith<$Res>
    implements $DashboardDataCopyWith<$Res> {
  factory _$$DashboardDataImplCopyWith(
          _$DashboardDataImpl value, $Res Function(_$DashboardDataImpl) then) =
      __$$DashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double balance,
      @JsonKey(name: 'monthly_income') double monthlyIncome,
      @JsonKey(name: 'monthly_expense') double monthlyExpense,
      double savings,
      @JsonKey(name: 'budget_remaining') double budgetRemaining,
      @JsonKey(name: 'recent_transactions')
      List<TransactionSummary> recentTransactions,
      String insight,
      @JsonKey(name: 'chart_data') List<double> chartData,
      @JsonKey(name: 'spending_breakdown')
      List<CategoryBreakdown> spendingBreakdown});
}

/// @nodoc
class __$$DashboardDataImplCopyWithImpl<$Res>
    extends _$DashboardDataCopyWithImpl<$Res, _$DashboardDataImpl>
    implements _$$DashboardDataImplCopyWith<$Res> {
  __$$DashboardDataImplCopyWithImpl(
      _$DashboardDataImpl _value, $Res Function(_$DashboardDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balance = null,
    Object? monthlyIncome = null,
    Object? monthlyExpense = null,
    Object? savings = null,
    Object? budgetRemaining = null,
    Object? recentTransactions = null,
    Object? insight = null,
    Object? chartData = null,
    Object? spendingBreakdown = null,
  }) {
    return _then(_$DashboardDataImpl(
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyIncome: null == monthlyIncome
          ? _value.monthlyIncome
          : monthlyIncome // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyExpense: null == monthlyExpense
          ? _value.monthlyExpense
          : monthlyExpense // ignore: cast_nullable_to_non_nullable
              as double,
      savings: null == savings
          ? _value.savings
          : savings // ignore: cast_nullable_to_non_nullable
              as double,
      budgetRemaining: null == budgetRemaining
          ? _value.budgetRemaining
          : budgetRemaining // ignore: cast_nullable_to_non_nullable
              as double,
      recentTransactions: null == recentTransactions
          ? _value._recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<TransactionSummary>,
      insight: null == insight
          ? _value.insight
          : insight // ignore: cast_nullable_to_non_nullable
              as String,
      chartData: null == chartData
          ? _value._chartData
          : chartData // ignore: cast_nullable_to_non_nullable
              as List<double>,
      spendingBreakdown: null == spendingBreakdown
          ? _value._spendingBreakdown
          : spendingBreakdown // ignore: cast_nullable_to_non_nullable
              as List<CategoryBreakdown>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardDataImpl implements _DashboardData {
  const _$DashboardDataImpl(
      {required this.balance,
      @JsonKey(name: 'monthly_income') required this.monthlyIncome,
      @JsonKey(name: 'monthly_expense') required this.monthlyExpense,
      required this.savings,
      @JsonKey(name: 'budget_remaining') required this.budgetRemaining,
      @JsonKey(name: 'recent_transactions')
      required final List<TransactionSummary> recentTransactions,
      required this.insight,
      @JsonKey(name: 'chart_data') required final List<double> chartData,
      @JsonKey(name: 'spending_breakdown')
      required final List<CategoryBreakdown> spendingBreakdown})
      : _recentTransactions = recentTransactions,
        _chartData = chartData,
        _spendingBreakdown = spendingBreakdown;

  factory _$DashboardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardDataImplFromJson(json);

  @override
  final double balance;
  @override
  @JsonKey(name: 'monthly_income')
  final double monthlyIncome;
  @override
  @JsonKey(name: 'monthly_expense')
  final double monthlyExpense;
  @override
  final double savings;
  @override
  @JsonKey(name: 'budget_remaining')
  final double budgetRemaining;
  final List<TransactionSummary> _recentTransactions;
  @override
  @JsonKey(name: 'recent_transactions')
  List<TransactionSummary> get recentTransactions {
    if (_recentTransactions is EqualUnmodifiableListView)
      return _recentTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTransactions);
  }

  @override
  final String insight;
  final List<double> _chartData;
  @override
  @JsonKey(name: 'chart_data')
  List<double> get chartData {
    if (_chartData is EqualUnmodifiableListView) return _chartData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chartData);
  }

  final List<CategoryBreakdown> _spendingBreakdown;
  @override
  @JsonKey(name: 'spending_breakdown')
  List<CategoryBreakdown> get spendingBreakdown {
    if (_spendingBreakdown is EqualUnmodifiableListView)
      return _spendingBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_spendingBreakdown);
  }

  @override
  String toString() {
    return 'DashboardData(balance: $balance, monthlyIncome: $monthlyIncome, monthlyExpense: $monthlyExpense, savings: $savings, budgetRemaining: $budgetRemaining, recentTransactions: $recentTransactions, insight: $insight, chartData: $chartData, spendingBreakdown: $spendingBreakdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardDataImpl &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.monthlyIncome, monthlyIncome) ||
                other.monthlyIncome == monthlyIncome) &&
            (identical(other.monthlyExpense, monthlyExpense) ||
                other.monthlyExpense == monthlyExpense) &&
            (identical(other.savings, savings) || other.savings == savings) &&
            (identical(other.budgetRemaining, budgetRemaining) ||
                other.budgetRemaining == budgetRemaining) &&
            const DeepCollectionEquality()
                .equals(other._recentTransactions, _recentTransactions) &&
            (identical(other.insight, insight) || other.insight == insight) &&
            const DeepCollectionEquality()
                .equals(other._chartData, _chartData) &&
            const DeepCollectionEquality()
                .equals(other._spendingBreakdown, _spendingBreakdown));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      balance,
      monthlyIncome,
      monthlyExpense,
      savings,
      budgetRemaining,
      const DeepCollectionEquality().hash(_recentTransactions),
      insight,
      const DeepCollectionEquality().hash(_chartData),
      const DeepCollectionEquality().hash(_spendingBreakdown));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      __$$DashboardDataImplCopyWithImpl<_$DashboardDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardDataImplToJson(
      this,
    );
  }
}

abstract class _DashboardData implements DashboardData {
  const factory _DashboardData(
      {required final double balance,
      @JsonKey(name: 'monthly_income') required final double monthlyIncome,
      @JsonKey(name: 'monthly_expense') required final double monthlyExpense,
      required final double savings,
      @JsonKey(name: 'budget_remaining') required final double budgetRemaining,
      @JsonKey(name: 'recent_transactions')
      required final List<TransactionSummary> recentTransactions,
      required final String insight,
      @JsonKey(name: 'chart_data') required final List<double> chartData,
      @JsonKey(name: 'spending_breakdown')
      required final List<CategoryBreakdown>
          spendingBreakdown}) = _$DashboardDataImpl;

  factory _DashboardData.fromJson(Map<String, dynamic> json) =
      _$DashboardDataImpl.fromJson;

  @override
  double get balance;
  @override
  @JsonKey(name: 'monthly_income')
  double get monthlyIncome;
  @override
  @JsonKey(name: 'monthly_expense')
  double get monthlyExpense;
  @override
  double get savings;
  @override
  @JsonKey(name: 'budget_remaining')
  double get budgetRemaining;
  @override
  @JsonKey(name: 'recent_transactions')
  List<TransactionSummary> get recentTransactions;
  @override
  String get insight;
  @override
  @JsonKey(name: 'chart_data')
  List<double> get chartData;
  @override
  @JsonKey(name: 'spending_breakdown')
  List<CategoryBreakdown> get spendingBreakdown;
  @override
  @JsonKey(ignore: true)
  _$$DashboardDataImplCopyWith<_$DashboardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionSummary _$TransactionSummaryFromJson(Map<String, dynamic> json) {
  return _TransactionSummary.fromJson(json);
}

/// @nodoc
mixin _$TransactionSummary {
  String get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_icon')
  String get categoryIcon => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionSummaryCopyWith<TransactionSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionSummaryCopyWith<$Res> {
  factory $TransactionSummaryCopyWith(
          TransactionSummary value, $Res Function(TransactionSummary) then) =
      _$TransactionSummaryCopyWithImpl<$Res, TransactionSummary>;
  @useResult
  $Res call(
      {String id,
      String description,
      double amount,
      String type,
      String category,
      @JsonKey(name: 'category_icon') String categoryIcon,
      DateTime date});
}

/// @nodoc
class _$TransactionSummaryCopyWithImpl<$Res, $Val extends TransactionSummary>
    implements $TransactionSummaryCopyWith<$Res> {
  _$TransactionSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? amount = null,
    Object? type = null,
    Object? category = null,
    Object? categoryIcon = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIcon: null == categoryIcon
          ? _value.categoryIcon
          : categoryIcon // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionSummaryImplCopyWith<$Res>
    implements $TransactionSummaryCopyWith<$Res> {
  factory _$$TransactionSummaryImplCopyWith(_$TransactionSummaryImpl value,
          $Res Function(_$TransactionSummaryImpl) then) =
      __$$TransactionSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String description,
      double amount,
      String type,
      String category,
      @JsonKey(name: 'category_icon') String categoryIcon,
      DateTime date});
}

/// @nodoc
class __$$TransactionSummaryImplCopyWithImpl<$Res>
    extends _$TransactionSummaryCopyWithImpl<$Res, _$TransactionSummaryImpl>
    implements _$$TransactionSummaryImplCopyWith<$Res> {
  __$$TransactionSummaryImplCopyWithImpl(_$TransactionSummaryImpl _value,
      $Res Function(_$TransactionSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? amount = null,
    Object? type = null,
    Object? category = null,
    Object? categoryIcon = null,
    Object? date = null,
  }) {
    return _then(_$TransactionSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      categoryIcon: null == categoryIcon
          ? _value.categoryIcon
          : categoryIcon // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionSummaryImpl implements _TransactionSummary {
  const _$TransactionSummaryImpl(
      {required this.id,
      required this.description,
      required this.amount,
      required this.type,
      required this.category,
      @JsonKey(name: 'category_icon') required this.categoryIcon,
      required this.date});

  factory _$TransactionSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String description;
  @override
  final double amount;
  @override
  final String type;
  @override
  final String category;
  @override
  @JsonKey(name: 'category_icon')
  final String categoryIcon;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'TransactionSummary(id: $id, description: $description, amount: $amount, type: $type, category: $category, categoryIcon: $categoryIcon, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.categoryIcon, categoryIcon) ||
                other.categoryIcon == categoryIcon) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, description, amount, type, category, categoryIcon, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionSummaryImplCopyWith<_$TransactionSummaryImpl> get copyWith =>
      __$$TransactionSummaryImplCopyWithImpl<_$TransactionSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionSummaryImplToJson(
      this,
    );
  }
}

abstract class _TransactionSummary implements TransactionSummary {
  const factory _TransactionSummary(
      {required final String id,
      required final String description,
      required final double amount,
      required final String type,
      required final String category,
      @JsonKey(name: 'category_icon') required final String categoryIcon,
      required final DateTime date}) = _$TransactionSummaryImpl;

  factory _TransactionSummary.fromJson(Map<String, dynamic> json) =
      _$TransactionSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get description;
  @override
  double get amount;
  @override
  String get type;
  @override
  String get category;
  @override
  @JsonKey(name: 'category_icon')
  String get categoryIcon;
  @override
  DateTime get date;
  @override
  @JsonKey(ignore: true)
  _$$TransactionSummaryImplCopyWith<_$TransactionSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryBreakdown _$CategoryBreakdownFromJson(Map<String, dynamic> json) {
  return _CategoryBreakdown.fromJson(json);
}

/// @nodoc
mixin _$CategoryBreakdown {
  String get category => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryBreakdownCopyWith<CategoryBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryBreakdownCopyWith<$Res> {
  factory $CategoryBreakdownCopyWith(
          CategoryBreakdown value, $Res Function(CategoryBreakdown) then) =
      _$CategoryBreakdownCopyWithImpl<$Res, CategoryBreakdown>;
  @useResult
  $Res call({String category, double amount, double percentage, String color});
}

/// @nodoc
class _$CategoryBreakdownCopyWithImpl<$Res, $Val extends CategoryBreakdown>
    implements $CategoryBreakdownCopyWith<$Res> {
  _$CategoryBreakdownCopyWithImpl(this._value, this._then);

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
    Object? color = null,
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
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryBreakdownImplCopyWith<$Res>
    implements $CategoryBreakdownCopyWith<$Res> {
  factory _$$CategoryBreakdownImplCopyWith(_$CategoryBreakdownImpl value,
          $Res Function(_$CategoryBreakdownImpl) then) =
      __$$CategoryBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, double amount, double percentage, String color});
}

/// @nodoc
class __$$CategoryBreakdownImplCopyWithImpl<$Res>
    extends _$CategoryBreakdownCopyWithImpl<$Res, _$CategoryBreakdownImpl>
    implements _$$CategoryBreakdownImplCopyWith<$Res> {
  __$$CategoryBreakdownImplCopyWithImpl(_$CategoryBreakdownImpl _value,
      $Res Function(_$CategoryBreakdownImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? amount = null,
    Object? percentage = null,
    Object? color = null,
  }) {
    return _then(_$CategoryBreakdownImpl(
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
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryBreakdownImpl implements _CategoryBreakdown {
  const _$CategoryBreakdownImpl(
      {required this.category,
      required this.amount,
      required this.percentage,
      required this.color});

  factory _$CategoryBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryBreakdownImplFromJson(json);

  @override
  final String category;
  @override
  final double amount;
  @override
  final double percentage;
  @override
  final String color;

  @override
  String toString() {
    return 'CategoryBreakdown(category: $category, amount: $amount, percentage: $percentage, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryBreakdownImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, category, amount, percentage, color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryBreakdownImplCopyWith<_$CategoryBreakdownImpl> get copyWith =>
      __$$CategoryBreakdownImplCopyWithImpl<_$CategoryBreakdownImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryBreakdownImplToJson(
      this,
    );
  }
}

abstract class _CategoryBreakdown implements CategoryBreakdown {
  const factory _CategoryBreakdown(
      {required final String category,
      required final double amount,
      required final double percentage,
      required final String color}) = _$CategoryBreakdownImpl;

  factory _CategoryBreakdown.fromJson(Map<String, dynamic> json) =
      _$CategoryBreakdownImpl.fromJson;

  @override
  String get category;
  @override
  double get amount;
  @override
  double get percentage;
  @override
  String get color;
  @override
  @JsonKey(ignore: true)
  _$$CategoryBreakdownImplCopyWith<_$CategoryBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
