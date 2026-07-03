import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/budget_entity.dart';
import 'budget_provider.dart';

class BudgetAlert {
  final BudgetEntity budget;
  final double percentage;
  final AlertSeverity severity;
  final String message;

  const BudgetAlert({
    required this.budget,
    required this.percentage,
    required this.severity,
    required this.message,
  });
}

enum AlertSeverity { warning, danger, safe }

final budgetAlertsProvider = Provider<List<BudgetAlert>>((ref) {
  final budgetsAsync = ref.watch(budgetsProvider);
  return budgetsAsync.whenOrNull(data: (budgets) {
        return budgets.map((budget) {
          final pct = budget.percentage * 100;
          AlertSeverity severity;
          String message;

          if (pct >= 100) {
            severity = AlertSeverity.danger;
            message =
                'You have exceeded your ${budget.categoryName} budget by \$${(budget.spent - budget.amount).toStringAsFixed(0)}';
          } else if (pct >= 80) {
            severity = AlertSeverity.warning;
            message =
                'You are close to exceeding your ${budget.categoryName} budget (${pct.toStringAsFixed(0)}% used)';
          } else {
            severity = AlertSeverity.safe;
            message =
                'Your ${budget.categoryName} budget is on track (${pct.toStringAsFixed(0)}% used)';
          }

          return BudgetAlert(
            budget: budget,
            percentage: pct,
            severity: severity,
            message: message,
          );
        }).toList();
      }) ??
      [];
});

final activeAlertsProvider = Provider<List<BudgetAlert>>((ref) {
  final alerts = ref.watch(budgetAlertsProvider);
  return alerts
      .where((a) =>
          a.severity == AlertSeverity.warning ||
          a.severity == AlertSeverity.danger)
      .toList();
});
