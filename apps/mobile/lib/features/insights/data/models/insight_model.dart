import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/insight_entity.dart';

part 'insight_model.freezed.dart';
part 'insight_model.g.dart';

@freezed
class InsightModel with _$InsightModel {
  const factory InsightModel({
    required MonthlySummaryData monthlySummary,
    required SpendingPredictionData spendingPrediction,
    required List<BudgetSuggestionData> budgetSuggestions,
    required List<ExpenseTrendData> expenseTrends,
  }) = _InsightModel;

  factory InsightModel.fromJson(Map<String, dynamic> json) =>
      _$InsightModelFromJson(json);
}

@freezed
class MonthlySummaryData with _$MonthlySummaryData {
  const factory MonthlySummaryData({
    required double income,
    required double expense,
    required double lastMonthIncome,
    required double lastMonthExpense,
  }) = _MonthlySummaryData;

  factory MonthlySummaryData.fromJson(Map<String, dynamic> json) =>
      _$MonthlySummaryDataFromJson(json);
}

@freezed
class SpendingPredictionData with _$SpendingPredictionData {
  const factory SpendingPredictionData({
    required double predictedAmount,
    required double currentAverage,
    required String trend,
  }) = _SpendingPredictionData;

  factory SpendingPredictionData.fromJson(Map<String, dynamic> json) =>
      _$SpendingPredictionDataFromJson(json);
}

@freezed
class BudgetSuggestionData with _$BudgetSuggestionData {
  const factory BudgetSuggestionData({
    required String category,
    required String message,
    required String urgency,
  }) = _BudgetSuggestionData;

  factory BudgetSuggestionData.fromJson(Map<String, dynamic> json) =>
      _$BudgetSuggestionDataFromJson(json);
}

@freezed
class ExpenseTrendData with _$ExpenseTrendData {
  const factory ExpenseTrendData({
    required String month,
    required double amount,
  }) = _ExpenseTrendData;

  factory ExpenseTrendData.fromJson(Map<String, dynamic> json) =>
      _$ExpenseTrendDataFromJson(json);
}

extension InsightModelX on InsightModel {
  InsightEntity toEntity() => InsightEntity(
        monthlySummary: MonthlySummary(
          income: monthlySummary.income,
          expense: monthlySummary.expense,
          lastMonthIncome: monthlySummary.lastMonthIncome,
          lastMonthExpense: monthlySummary.lastMonthExpense,
        ),
        spendingPrediction: SpendingPrediction(
          predictedAmount: spendingPrediction.predictedAmount,
          currentAverage: spendingPrediction.currentAverage,
          trend: _trendFromString(spendingPrediction.trend),
        ),
        budgetSuggestions: budgetSuggestions
            .map((s) => BudgetSuggestion(
                  category: s.category,
                  message: s.message,
                  urgency: _urgencyFromString(s.urgency),
                ))
            .toList(),
        expenseTrends: expenseTrends
            .map((t) => ExpenseTrendPoint(
                  month: t.month,
                  amount: t.amount,
                ))
            .toList(),
      );

  static TrendDirection _trendFromString(String value) {
    switch (value) {
      case 'up':
        return TrendDirection.up;
      case 'down':
        return TrendDirection.down;
      default:
        return TrendDirection.stable;
    }
  }

  static SuggestionUrgency _urgencyFromString(String value) {
    switch (value) {
      case 'high':
        return SuggestionUrgency.high;
      case 'medium':
        return SuggestionUrgency.medium;
      default:
        return SuggestionUrgency.low;
    }
  }
}

extension InsightEntityX on InsightEntity {
  InsightModel toModel() => InsightModel(
        monthlySummary: MonthlySummaryData(
          income: monthlySummary.income,
          expense: monthlySummary.expense,
          lastMonthIncome: monthlySummary.lastMonthIncome,
          lastMonthExpense: monthlySummary.lastMonthExpense,
        ),
        spendingPrediction: SpendingPredictionData(
          predictedAmount: spendingPrediction.predictedAmount,
          currentAverage: spendingPrediction.currentAverage,
          trend: spendingPrediction.trend.name,
        ),
        budgetSuggestions: budgetSuggestions
            .map((s) => BudgetSuggestionData(
                  category: s.category,
                  message: s.message,
                  urgency: s.urgency.name,
                ))
            .toList(),
        expenseTrends: expenseTrends
            .map((t) => ExpenseTrendData(
                  month: t.month,
                  amount: t.amount,
                ))
            .toList(),
      );
}
