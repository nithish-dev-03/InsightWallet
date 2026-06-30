import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_data.freezed.dart';
part 'dashboard_data.g.dart';

@freezed
class DashboardData with _$DashboardData {
  const factory DashboardData({
    required double balance,
    @JsonKey(name: 'monthly_income') required double monthlyIncome,
    @JsonKey(name: 'monthly_expense') required double monthlyExpense,
    required double savings,
    @JsonKey(name: 'budget_remaining') required double budgetRemaining,
    @JsonKey(name: 'recent_transactions') required List<TransactionSummary> recentTransactions,
    required String insight,
    @JsonKey(name: 'chart_data') required List<double> chartData,
    @JsonKey(name: 'spending_breakdown') required List<CategoryBreakdown> spendingBreakdown,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
}

@freezed
class TransactionSummary with _$TransactionSummary {
  const factory TransactionSummary({
    required String id,
    required String description,
    required double amount,
    required String type,
    required String category,
    @JsonKey(name: 'category_icon') required String categoryIcon,
    required DateTime date,
  }) = _TransactionSummary;

  factory TransactionSummary.fromJson(Map<String, dynamic> json) =>
      _$TransactionSummaryFromJson(json);
}

@freezed
class CategoryBreakdown with _$CategoryBreakdown {
  const factory CategoryBreakdown({
    required String category,
    required double amount,
    required double percentage,
    required String color,
  }) = _CategoryBreakdown;

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownFromJson(json);
}
