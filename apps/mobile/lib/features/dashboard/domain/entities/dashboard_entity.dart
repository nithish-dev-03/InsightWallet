import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_entity.freezed.dart';

@freezed
class DashboardEntity with _$DashboardEntity {
  const factory DashboardEntity({
    required double balance,
    required double monthlyIncome,
    required double monthlyExpense,
    required double savings,
    required double budgetRemaining,
    required List<TransactionSummaryEntity> recentTransactions,
    required String insight,
    required List<double> chartData,
    required List<CategoryBreakdownEntity> spendingBreakdown,
  }) = _DashboardEntity;
}

@freezed
class TransactionSummaryEntity with _$TransactionSummaryEntity {
  const factory TransactionSummaryEntity({
    required String id,
    required String description,
    required double amount,
    required String type,
    required String category,
    required String categoryIcon,
    required DateTime date,
  }) = _TransactionSummaryEntity;
}

@freezed
class CategoryBreakdownEntity with _$CategoryBreakdownEntity {
  const factory CategoryBreakdownEntity({
    required String category,
    required double amount,
    required double percentage,
    required String color,
  }) = _CategoryBreakdownEntity;
}
