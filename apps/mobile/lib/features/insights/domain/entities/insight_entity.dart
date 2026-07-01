import 'package:equatable/equatable.dart';

class MonthlySummary extends Equatable {
  final double income;
  final double expense;
  final double lastMonthIncome;
  final double lastMonthExpense;

  const MonthlySummary({
    required this.income,
    required this.expense,
    required this.lastMonthIncome,
    required this.lastMonthExpense,
  });

  double get incomeChange =>
      lastMonthIncome > 0 ? ((income - lastMonthIncome) / lastMonthIncome * 100) : 0;
  double get expenseChange =>
      lastMonthExpense > 0 ? ((expense - lastMonthExpense) / lastMonthExpense * 100) : 0;

  @override
  List<Object?> get props =>
      [income, expense, lastMonthIncome, lastMonthExpense];
}

class SpendingPrediction extends Equatable {
  final double predictedAmount;
  final double currentAverage;
  final TrendDirection trend;

  const SpendingPrediction({
    required this.predictedAmount,
    required this.currentAverage,
    required this.trend,
  });

  @override
  List<Object?> get props => [predictedAmount, currentAverage, trend];
}

enum TrendDirection { up, down, stable }

class BudgetSuggestion extends Equatable {
  final String category;
  final String message;
  final SuggestionUrgency urgency;

  const BudgetSuggestion({
    required this.category,
    required this.message,
    required this.urgency,
  });

  @override
  List<Object?> get props => [category, message, urgency];
}

enum SuggestionUrgency { low, medium, high }

class ExpenseTrendPoint extends Equatable {
  final String month;
  final double amount;

  const ExpenseTrendPoint({required this.month, required this.amount});

  @override
  List<Object?> get props => [month, amount];
}

class InsightEntity extends Equatable {
  final MonthlySummary monthlySummary;
  final SpendingPrediction spendingPrediction;
  final List<BudgetSuggestion> budgetSuggestions;
  final List<ExpenseTrendPoint> expenseTrends;

  const InsightEntity({
    required this.monthlySummary,
    required this.spendingPrediction,
    required this.budgetSuggestions,
    required this.expenseTrends,
  });

  @override
  List<Object?> get props =>
      [monthlySummary, spendingPrediction, budgetSuggestions, expenseTrends];
}
