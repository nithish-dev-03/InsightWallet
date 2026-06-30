import 'package:flutter/painting.dart';
import 'package:equatable/equatable.dart';

class CategoryBreakdown extends Equatable {
  final String category;
  final double amount;
  final double percentage;
  final Color color;

  const CategoryBreakdown({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  @override
  List<Object?> get props => [category, amount, percentage, color];
}

class CashFlowItem extends Equatable {
  final String month;
  final double income;
  final double expense;

  const CashFlowItem({
    required this.month,
    required this.income,
    required this.expense,
  });

  @override
  List<Object?> get props => [month, income, expense];
}

class TrendPoint extends Equatable {
  final String label;
  final double value;

  const TrendPoint({required this.label, required this.value});

  @override
  List<Object?> get props => [label, value];
}

class TopCategory extends Equatable {
  final String name;
  final double amount;
  final double percentage;
  final Color color;

  const TopCategory({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  @override
  List<Object?> get props => [name, amount, percentage, color];
}

class ReportEntity extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double netSavings;
  final List<CategoryBreakdown> categoryBreakdown;
  final List<CashFlowItem> cashFlow;
  final List<TrendPoint> trend;
  final List<TopCategory> topCategories;

  const ReportEntity({
    required this.totalIncome,
    required this.totalExpense,
    required this.netSavings,
    required this.categoryBreakdown,
    required this.cashFlow,
    required this.trend,
    required this.topCategories,
  });

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        netSavings,
        categoryBreakdown,
        cashFlow,
        trend,
        topCategories,
      ];
}
