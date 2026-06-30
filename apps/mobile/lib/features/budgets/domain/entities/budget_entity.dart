import 'package:equatable/equatable.dart';

enum BudgetPeriod { weekly, monthly, yearly }

class BudgetEntity extends Equatable {
  final String id;
  final String categoryId;
  final String categoryName;
  final double amount;
  final double spent;
  final BudgetPeriod period;
  final DateTime startDate;
  final DateTime endDate;
  final bool notifications;

  const BudgetEntity({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    this.spent = 0,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.notifications = true,
  });

  double get percentage => amount > 0 ? (spent / amount) : 0;
  double get remaining => amount - spent;
  bool get isOverBudget => spent > amount;

  BudgetEntity copyWith({
    String? id,
    String? categoryId,
    String? categoryName,
    double? amount,
    double? spent,
    BudgetPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    bool? notifications,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [
        id,
        categoryId,
        categoryName,
        amount,
        spent,
        period,
        startDate,
        endDate,
        notifications,
      ];
}
