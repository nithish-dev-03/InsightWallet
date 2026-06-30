import 'package:insightwallet/features/budgets/domain/entities/budget_entity.dart';

abstract class BudgetRepository {
  Future<List<BudgetEntity>> getBudgets();
  Future<BudgetEntity> getBudgetById(String id);
  Future<BudgetEntity> createBudget(BudgetEntity budget);
  Future<BudgetEntity> updateBudget(BudgetEntity budget);
  Future<void> deleteBudget(String id);
  Future<List<BudgetEntity>> getBudgetsByPeriod(BudgetPeriod period);
}
