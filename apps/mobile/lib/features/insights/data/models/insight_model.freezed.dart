// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insight_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InsightModel _$InsightModelFromJson(Map<String, dynamic> json) {
  return _InsightModel.fromJson(json);
}

/// @nodoc
mixin _$InsightModel {
  MonthlySummaryData get monthlySummary => throw _privateConstructorUsedError;
  SpendingPredictionData get spendingPrediction =>
      throw _privateConstructorUsedError;
  List<BudgetSuggestionData> get budgetSuggestions =>
      throw _privateConstructorUsedError;
  List<ExpenseTrendData> get expenseTrends =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InsightModelCopyWith<InsightModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightModelCopyWith<$Res> {
  factory $InsightModelCopyWith(
          InsightModel value, $Res Function(InsightModel) then) =
      _$InsightModelCopyWithImpl<$Res, InsightModel>;
  @useResult
  $Res call(
      {MonthlySummaryData monthlySummary,
      SpendingPredictionData spendingPrediction,
      List<BudgetSuggestionData> budgetSuggestions,
      List<ExpenseTrendData> expenseTrends});

  $MonthlySummaryDataCopyWith<$Res> get monthlySummary;
  $SpendingPredictionDataCopyWith<$Res> get spendingPrediction;
}

/// @nodoc
class _$InsightModelCopyWithImpl<$Res, $Val extends InsightModel>
    implements $InsightModelCopyWith<$Res> {
  _$InsightModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monthlySummary = null,
    Object? spendingPrediction = null,
    Object? budgetSuggestions = null,
    Object? expenseTrends = null,
  }) {
    return _then(_value.copyWith(
      monthlySummary: null == monthlySummary
          ? _value.monthlySummary
          : monthlySummary // ignore: cast_nullable_to_non_nullable
              as MonthlySummaryData,
      spendingPrediction: null == spendingPrediction
          ? _value.spendingPrediction
          : spendingPrediction // ignore: cast_nullable_to_non_nullable
              as SpendingPredictionData,
      budgetSuggestions: null == budgetSuggestions
          ? _value.budgetSuggestions
          : budgetSuggestions // ignore: cast_nullable_to_non_nullable
              as List<BudgetSuggestionData>,
      expenseTrends: null == expenseTrends
          ? _value.expenseTrends
          : expenseTrends // ignore: cast_nullable_to_non_nullable
              as List<ExpenseTrendData>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MonthlySummaryDataCopyWith<$Res> get monthlySummary {
    return $MonthlySummaryDataCopyWith<$Res>(_value.monthlySummary, (value) {
      return _then(_value.copyWith(monthlySummary: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SpendingPredictionDataCopyWith<$Res> get spendingPrediction {
    return $SpendingPredictionDataCopyWith<$Res>(_value.spendingPrediction,
        (value) {
      return _then(_value.copyWith(spendingPrediction: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InsightModelImplCopyWith<$Res>
    implements $InsightModelCopyWith<$Res> {
  factory _$$InsightModelImplCopyWith(
          _$InsightModelImpl value, $Res Function(_$InsightModelImpl) then) =
      __$$InsightModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MonthlySummaryData monthlySummary,
      SpendingPredictionData spendingPrediction,
      List<BudgetSuggestionData> budgetSuggestions,
      List<ExpenseTrendData> expenseTrends});

  @override
  $MonthlySummaryDataCopyWith<$Res> get monthlySummary;
  @override
  $SpendingPredictionDataCopyWith<$Res> get spendingPrediction;
}

/// @nodoc
class __$$InsightModelImplCopyWithImpl<$Res>
    extends _$InsightModelCopyWithImpl<$Res, _$InsightModelImpl>
    implements _$$InsightModelImplCopyWith<$Res> {
  __$$InsightModelImplCopyWithImpl(
      _$InsightModelImpl _value, $Res Function(_$InsightModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monthlySummary = null,
    Object? spendingPrediction = null,
    Object? budgetSuggestions = null,
    Object? expenseTrends = null,
  }) {
    return _then(_$InsightModelImpl(
      monthlySummary: null == monthlySummary
          ? _value.monthlySummary
          : monthlySummary // ignore: cast_nullable_to_non_nullable
              as MonthlySummaryData,
      spendingPrediction: null == spendingPrediction
          ? _value.spendingPrediction
          : spendingPrediction // ignore: cast_nullable_to_non_nullable
              as SpendingPredictionData,
      budgetSuggestions: null == budgetSuggestions
          ? _value._budgetSuggestions
          : budgetSuggestions // ignore: cast_nullable_to_non_nullable
              as List<BudgetSuggestionData>,
      expenseTrends: null == expenseTrends
          ? _value._expenseTrends
          : expenseTrends // ignore: cast_nullable_to_non_nullable
              as List<ExpenseTrendData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InsightModelImpl implements _InsightModel {
  const _$InsightModelImpl(
      {required this.monthlySummary,
      required this.spendingPrediction,
      required final List<BudgetSuggestionData> budgetSuggestions,
      required final List<ExpenseTrendData> expenseTrends})
      : _budgetSuggestions = budgetSuggestions,
        _expenseTrends = expenseTrends;

  factory _$InsightModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InsightModelImplFromJson(json);

  @override
  final MonthlySummaryData monthlySummary;
  @override
  final SpendingPredictionData spendingPrediction;
  final List<BudgetSuggestionData> _budgetSuggestions;
  @override
  List<BudgetSuggestionData> get budgetSuggestions {
    if (_budgetSuggestions is EqualUnmodifiableListView)
      return _budgetSuggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_budgetSuggestions);
  }

  final List<ExpenseTrendData> _expenseTrends;
  @override
  List<ExpenseTrendData> get expenseTrends {
    if (_expenseTrends is EqualUnmodifiableListView) return _expenseTrends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenseTrends);
  }

  @override
  String toString() {
    return 'InsightModel(monthlySummary: $monthlySummary, spendingPrediction: $spendingPrediction, budgetSuggestions: $budgetSuggestions, expenseTrends: $expenseTrends)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightModelImpl &&
            (identical(other.monthlySummary, monthlySummary) ||
                other.monthlySummary == monthlySummary) &&
            (identical(other.spendingPrediction, spendingPrediction) ||
                other.spendingPrediction == spendingPrediction) &&
            const DeepCollectionEquality()
                .equals(other._budgetSuggestions, _budgetSuggestions) &&
            const DeepCollectionEquality()
                .equals(other._expenseTrends, _expenseTrends));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      monthlySummary,
      spendingPrediction,
      const DeepCollectionEquality().hash(_budgetSuggestions),
      const DeepCollectionEquality().hash(_expenseTrends));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightModelImplCopyWith<_$InsightModelImpl> get copyWith =>
      __$$InsightModelImplCopyWithImpl<_$InsightModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InsightModelImplToJson(
      this,
    );
  }
}

abstract class _InsightModel implements InsightModel {
  const factory _InsightModel(
          {required final MonthlySummaryData monthlySummary,
          required final SpendingPredictionData spendingPrediction,
          required final List<BudgetSuggestionData> budgetSuggestions,
          required final List<ExpenseTrendData> expenseTrends}) =
      _$InsightModelImpl;

  factory _InsightModel.fromJson(Map<String, dynamic> json) =
      _$InsightModelImpl.fromJson;

  @override
  MonthlySummaryData get monthlySummary;
  @override
  SpendingPredictionData get spendingPrediction;
  @override
  List<BudgetSuggestionData> get budgetSuggestions;
  @override
  List<ExpenseTrendData> get expenseTrends;
  @override
  @JsonKey(ignore: true)
  _$$InsightModelImplCopyWith<_$InsightModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthlySummaryData _$MonthlySummaryDataFromJson(Map<String, dynamic> json) {
  return _MonthlySummaryData.fromJson(json);
}

/// @nodoc
mixin _$MonthlySummaryData {
  double get income => throw _privateConstructorUsedError;
  double get expense => throw _privateConstructorUsedError;
  double get lastMonthIncome => throw _privateConstructorUsedError;
  double get lastMonthExpense => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MonthlySummaryDataCopyWith<MonthlySummaryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlySummaryDataCopyWith<$Res> {
  factory $MonthlySummaryDataCopyWith(
          MonthlySummaryData value, $Res Function(MonthlySummaryData) then) =
      _$MonthlySummaryDataCopyWithImpl<$Res, MonthlySummaryData>;
  @useResult
  $Res call(
      {double income,
      double expense,
      double lastMonthIncome,
      double lastMonthExpense});
}

/// @nodoc
class _$MonthlySummaryDataCopyWithImpl<$Res, $Val extends MonthlySummaryData>
    implements $MonthlySummaryDataCopyWith<$Res> {
  _$MonthlySummaryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? lastMonthIncome = null,
    Object? lastMonthExpense = null,
  }) {
    return _then(_value.copyWith(
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
      lastMonthIncome: null == lastMonthIncome
          ? _value.lastMonthIncome
          : lastMonthIncome // ignore: cast_nullable_to_non_nullable
              as double,
      lastMonthExpense: null == lastMonthExpense
          ? _value.lastMonthExpense
          : lastMonthExpense // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlySummaryDataImplCopyWith<$Res>
    implements $MonthlySummaryDataCopyWith<$Res> {
  factory _$$MonthlySummaryDataImplCopyWith(_$MonthlySummaryDataImpl value,
          $Res Function(_$MonthlySummaryDataImpl) then) =
      __$$MonthlySummaryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double income,
      double expense,
      double lastMonthIncome,
      double lastMonthExpense});
}

/// @nodoc
class __$$MonthlySummaryDataImplCopyWithImpl<$Res>
    extends _$MonthlySummaryDataCopyWithImpl<$Res, _$MonthlySummaryDataImpl>
    implements _$$MonthlySummaryDataImplCopyWith<$Res> {
  __$$MonthlySummaryDataImplCopyWithImpl(_$MonthlySummaryDataImpl _value,
      $Res Function(_$MonthlySummaryDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? lastMonthIncome = null,
    Object? lastMonthExpense = null,
  }) {
    return _then(_$MonthlySummaryDataImpl(
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
      lastMonthIncome: null == lastMonthIncome
          ? _value.lastMonthIncome
          : lastMonthIncome // ignore: cast_nullable_to_non_nullable
              as double,
      lastMonthExpense: null == lastMonthExpense
          ? _value.lastMonthExpense
          : lastMonthExpense // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlySummaryDataImpl implements _MonthlySummaryData {
  const _$MonthlySummaryDataImpl(
      {required this.income,
      required this.expense,
      required this.lastMonthIncome,
      required this.lastMonthExpense});

  factory _$MonthlySummaryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlySummaryDataImplFromJson(json);

  @override
  final double income;
  @override
  final double expense;
  @override
  final double lastMonthIncome;
  @override
  final double lastMonthExpense;

  @override
  String toString() {
    return 'MonthlySummaryData(income: $income, expense: $expense, lastMonthIncome: $lastMonthIncome, lastMonthExpense: $lastMonthExpense)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlySummaryDataImpl &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.lastMonthIncome, lastMonthIncome) ||
                other.lastMonthIncome == lastMonthIncome) &&
            (identical(other.lastMonthExpense, lastMonthExpense) ||
                other.lastMonthExpense == lastMonthExpense));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, income, expense, lastMonthIncome, lastMonthExpense);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlySummaryDataImplCopyWith<_$MonthlySummaryDataImpl> get copyWith =>
      __$$MonthlySummaryDataImplCopyWithImpl<_$MonthlySummaryDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlySummaryDataImplToJson(
      this,
    );
  }
}

abstract class _MonthlySummaryData implements MonthlySummaryData {
  const factory _MonthlySummaryData(
      {required final double income,
      required final double expense,
      required final double lastMonthIncome,
      required final double lastMonthExpense}) = _$MonthlySummaryDataImpl;

  factory _MonthlySummaryData.fromJson(Map<String, dynamic> json) =
      _$MonthlySummaryDataImpl.fromJson;

  @override
  double get income;
  @override
  double get expense;
  @override
  double get lastMonthIncome;
  @override
  double get lastMonthExpense;
  @override
  @JsonKey(ignore: true)
  _$$MonthlySummaryDataImplCopyWith<_$MonthlySummaryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpendingPredictionData _$SpendingPredictionDataFromJson(
    Map<String, dynamic> json) {
  return _SpendingPredictionData.fromJson(json);
}

/// @nodoc
mixin _$SpendingPredictionData {
  double get predictedAmount => throw _privateConstructorUsedError;
  double get currentAverage => throw _privateConstructorUsedError;
  String get trend => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpendingPredictionDataCopyWith<SpendingPredictionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpendingPredictionDataCopyWith<$Res> {
  factory $SpendingPredictionDataCopyWith(SpendingPredictionData value,
          $Res Function(SpendingPredictionData) then) =
      _$SpendingPredictionDataCopyWithImpl<$Res, SpendingPredictionData>;
  @useResult
  $Res call({double predictedAmount, double currentAverage, String trend});
}

/// @nodoc
class _$SpendingPredictionDataCopyWithImpl<$Res,
        $Val extends SpendingPredictionData>
    implements $SpendingPredictionDataCopyWith<$Res> {
  _$SpendingPredictionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? predictedAmount = null,
    Object? currentAverage = null,
    Object? trend = null,
  }) {
    return _then(_value.copyWith(
      predictedAmount: null == predictedAmount
          ? _value.predictedAmount
          : predictedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAverage: null == currentAverage
          ? _value.currentAverage
          : currentAverage // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpendingPredictionDataImplCopyWith<$Res>
    implements $SpendingPredictionDataCopyWith<$Res> {
  factory _$$SpendingPredictionDataImplCopyWith(
          _$SpendingPredictionDataImpl value,
          $Res Function(_$SpendingPredictionDataImpl) then) =
      __$$SpendingPredictionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double predictedAmount, double currentAverage, String trend});
}

/// @nodoc
class __$$SpendingPredictionDataImplCopyWithImpl<$Res>
    extends _$SpendingPredictionDataCopyWithImpl<$Res,
        _$SpendingPredictionDataImpl>
    implements _$$SpendingPredictionDataImplCopyWith<$Res> {
  __$$SpendingPredictionDataImplCopyWithImpl(
      _$SpendingPredictionDataImpl _value,
      $Res Function(_$SpendingPredictionDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? predictedAmount = null,
    Object? currentAverage = null,
    Object? trend = null,
  }) {
    return _then(_$SpendingPredictionDataImpl(
      predictedAmount: null == predictedAmount
          ? _value.predictedAmount
          : predictedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAverage: null == currentAverage
          ? _value.currentAverage
          : currentAverage // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpendingPredictionDataImpl implements _SpendingPredictionData {
  const _$SpendingPredictionDataImpl(
      {required this.predictedAmount,
      required this.currentAverage,
      required this.trend});

  factory _$SpendingPredictionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpendingPredictionDataImplFromJson(json);

  @override
  final double predictedAmount;
  @override
  final double currentAverage;
  @override
  final String trend;

  @override
  String toString() {
    return 'SpendingPredictionData(predictedAmount: $predictedAmount, currentAverage: $currentAverage, trend: $trend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpendingPredictionDataImpl &&
            (identical(other.predictedAmount, predictedAmount) ||
                other.predictedAmount == predictedAmount) &&
            (identical(other.currentAverage, currentAverage) ||
                other.currentAverage == currentAverage) &&
            (identical(other.trend, trend) || other.trend == trend));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, predictedAmount, currentAverage, trend);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpendingPredictionDataImplCopyWith<_$SpendingPredictionDataImpl>
      get copyWith => __$$SpendingPredictionDataImplCopyWithImpl<
          _$SpendingPredictionDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpendingPredictionDataImplToJson(
      this,
    );
  }
}

abstract class _SpendingPredictionData implements SpendingPredictionData {
  const factory _SpendingPredictionData(
      {required final double predictedAmount,
      required final double currentAverage,
      required final String trend}) = _$SpendingPredictionDataImpl;

  factory _SpendingPredictionData.fromJson(Map<String, dynamic> json) =
      _$SpendingPredictionDataImpl.fromJson;

  @override
  double get predictedAmount;
  @override
  double get currentAverage;
  @override
  String get trend;
  @override
  @JsonKey(ignore: true)
  _$$SpendingPredictionDataImplCopyWith<_$SpendingPredictionDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BudgetSuggestionData _$BudgetSuggestionDataFromJson(Map<String, dynamic> json) {
  return _BudgetSuggestionData.fromJson(json);
}

/// @nodoc
mixin _$BudgetSuggestionData {
  String get category => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get urgency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BudgetSuggestionDataCopyWith<BudgetSuggestionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetSuggestionDataCopyWith<$Res> {
  factory $BudgetSuggestionDataCopyWith(BudgetSuggestionData value,
          $Res Function(BudgetSuggestionData) then) =
      _$BudgetSuggestionDataCopyWithImpl<$Res, BudgetSuggestionData>;
  @useResult
  $Res call({String category, String message, String urgency});
}

/// @nodoc
class _$BudgetSuggestionDataCopyWithImpl<$Res,
        $Val extends BudgetSuggestionData>
    implements $BudgetSuggestionDataCopyWith<$Res> {
  _$BudgetSuggestionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? message = null,
    Object? urgency = null,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      urgency: null == urgency
          ? _value.urgency
          : urgency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetSuggestionDataImplCopyWith<$Res>
    implements $BudgetSuggestionDataCopyWith<$Res> {
  factory _$$BudgetSuggestionDataImplCopyWith(_$BudgetSuggestionDataImpl value,
          $Res Function(_$BudgetSuggestionDataImpl) then) =
      __$$BudgetSuggestionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, String message, String urgency});
}

/// @nodoc
class __$$BudgetSuggestionDataImplCopyWithImpl<$Res>
    extends _$BudgetSuggestionDataCopyWithImpl<$Res, _$BudgetSuggestionDataImpl>
    implements _$$BudgetSuggestionDataImplCopyWith<$Res> {
  __$$BudgetSuggestionDataImplCopyWithImpl(_$BudgetSuggestionDataImpl _value,
      $Res Function(_$BudgetSuggestionDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? message = null,
    Object? urgency = null,
  }) {
    return _then(_$BudgetSuggestionDataImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      urgency: null == urgency
          ? _value.urgency
          : urgency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetSuggestionDataImpl implements _BudgetSuggestionData {
  const _$BudgetSuggestionDataImpl(
      {required this.category, required this.message, required this.urgency});

  factory _$BudgetSuggestionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetSuggestionDataImplFromJson(json);

  @override
  final String category;
  @override
  final String message;
  @override
  final String urgency;

  @override
  String toString() {
    return 'BudgetSuggestionData(category: $category, message: $message, urgency: $urgency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetSuggestionDataImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.urgency, urgency) || other.urgency == urgency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, category, message, urgency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetSuggestionDataImplCopyWith<_$BudgetSuggestionDataImpl>
      get copyWith =>
          __$$BudgetSuggestionDataImplCopyWithImpl<_$BudgetSuggestionDataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetSuggestionDataImplToJson(
      this,
    );
  }
}

abstract class _BudgetSuggestionData implements BudgetSuggestionData {
  const factory _BudgetSuggestionData(
      {required final String category,
      required final String message,
      required final String urgency}) = _$BudgetSuggestionDataImpl;

  factory _BudgetSuggestionData.fromJson(Map<String, dynamic> json) =
      _$BudgetSuggestionDataImpl.fromJson;

  @override
  String get category;
  @override
  String get message;
  @override
  String get urgency;
  @override
  @JsonKey(ignore: true)
  _$$BudgetSuggestionDataImplCopyWith<_$BudgetSuggestionDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ExpenseTrendData _$ExpenseTrendDataFromJson(Map<String, dynamic> json) {
  return _ExpenseTrendData.fromJson(json);
}

/// @nodoc
mixin _$ExpenseTrendData {
  String get month => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExpenseTrendDataCopyWith<ExpenseTrendData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseTrendDataCopyWith<$Res> {
  factory $ExpenseTrendDataCopyWith(
          ExpenseTrendData value, $Res Function(ExpenseTrendData) then) =
      _$ExpenseTrendDataCopyWithImpl<$Res, ExpenseTrendData>;
  @useResult
  $Res call({String month, double amount});
}

/// @nodoc
class _$ExpenseTrendDataCopyWithImpl<$Res, $Val extends ExpenseTrendData>
    implements $ExpenseTrendDataCopyWith<$Res> {
  _$ExpenseTrendDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseTrendDataImplCopyWith<$Res>
    implements $ExpenseTrendDataCopyWith<$Res> {
  factory _$$ExpenseTrendDataImplCopyWith(_$ExpenseTrendDataImpl value,
          $Res Function(_$ExpenseTrendDataImpl) then) =
      __$$ExpenseTrendDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String month, double amount});
}

/// @nodoc
class __$$ExpenseTrendDataImplCopyWithImpl<$Res>
    extends _$ExpenseTrendDataCopyWithImpl<$Res, _$ExpenseTrendDataImpl>
    implements _$$ExpenseTrendDataImplCopyWith<$Res> {
  __$$ExpenseTrendDataImplCopyWithImpl(_$ExpenseTrendDataImpl _value,
      $Res Function(_$ExpenseTrendDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? amount = null,
  }) {
    return _then(_$ExpenseTrendDataImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseTrendDataImpl implements _ExpenseTrendData {
  const _$ExpenseTrendDataImpl({required this.month, required this.amount});

  factory _$ExpenseTrendDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseTrendDataImplFromJson(json);

  @override
  final String month;
  @override
  final double amount;

  @override
  String toString() {
    return 'ExpenseTrendData(month: $month, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseTrendDataImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, month, amount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseTrendDataImplCopyWith<_$ExpenseTrendDataImpl> get copyWith =>
      __$$ExpenseTrendDataImplCopyWithImpl<_$ExpenseTrendDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseTrendDataImplToJson(
      this,
    );
  }
}

abstract class _ExpenseTrendData implements ExpenseTrendData {
  const factory _ExpenseTrendData(
      {required final String month,
      required final double amount}) = _$ExpenseTrendDataImpl;

  factory _ExpenseTrendData.fromJson(Map<String, dynamic> json) =
      _$ExpenseTrendDataImpl.fromJson;

  @override
  String get month;
  @override
  double get amount;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseTrendDataImplCopyWith<_$ExpenseTrendDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
