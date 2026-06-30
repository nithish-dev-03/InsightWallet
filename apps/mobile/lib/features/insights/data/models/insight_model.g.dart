// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InsightModelImpl _$$InsightModelImplFromJson(Map<String, dynamic> json) =>
    _$InsightModelImpl(
      monthlySummary: MonthlySummaryData.fromJson(
          json['monthlySummary'] as Map<String, dynamic>),
      spendingPrediction: SpendingPredictionData.fromJson(
          json['spendingPrediction'] as Map<String, dynamic>),
      budgetSuggestions: (json['budgetSuggestions'] as List<dynamic>)
          .map((e) => BudgetSuggestionData.fromJson(e as Map<String, dynamic>))
          .toList(),
      expenseTrends: (json['expenseTrends'] as List<dynamic>)
          .map((e) => ExpenseTrendData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$InsightModelImplToJson(_$InsightModelImpl instance) =>
    <String, dynamic>{
      'monthlySummary': instance.monthlySummary,
      'spendingPrediction': instance.spendingPrediction,
      'budgetSuggestions': instance.budgetSuggestions,
      'expenseTrends': instance.expenseTrends,
    };

_$MonthlySummaryDataImpl _$$MonthlySummaryDataImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlySummaryDataImpl(
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      lastMonthIncome: (json['lastMonthIncome'] as num).toDouble(),
      lastMonthExpense: (json['lastMonthExpense'] as num).toDouble(),
    );

Map<String, dynamic> _$$MonthlySummaryDataImplToJson(
        _$MonthlySummaryDataImpl instance) =>
    <String, dynamic>{
      'income': instance.income,
      'expense': instance.expense,
      'lastMonthIncome': instance.lastMonthIncome,
      'lastMonthExpense': instance.lastMonthExpense,
    };

_$SpendingPredictionDataImpl _$$SpendingPredictionDataImplFromJson(
        Map<String, dynamic> json) =>
    _$SpendingPredictionDataImpl(
      predictedAmount: (json['predictedAmount'] as num).toDouble(),
      currentAverage: (json['currentAverage'] as num).toDouble(),
      trend: json['trend'] as String,
    );

Map<String, dynamic> _$$SpendingPredictionDataImplToJson(
        _$SpendingPredictionDataImpl instance) =>
    <String, dynamic>{
      'predictedAmount': instance.predictedAmount,
      'currentAverage': instance.currentAverage,
      'trend': instance.trend,
    };

_$BudgetSuggestionDataImpl _$$BudgetSuggestionDataImplFromJson(
        Map<String, dynamic> json) =>
    _$BudgetSuggestionDataImpl(
      category: json['category'] as String,
      message: json['message'] as String,
      urgency: json['urgency'] as String,
    );

Map<String, dynamic> _$$BudgetSuggestionDataImplToJson(
        _$BudgetSuggestionDataImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'message': instance.message,
      'urgency': instance.urgency,
    };

_$ExpenseTrendDataImpl _$$ExpenseTrendDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ExpenseTrendDataImpl(
      month: json['month'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$$ExpenseTrendDataImplToJson(
        _$ExpenseTrendDataImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'amount': instance.amount,
    };
