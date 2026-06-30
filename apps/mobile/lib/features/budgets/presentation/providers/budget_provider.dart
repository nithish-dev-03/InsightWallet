import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../data/repositories/budget_repository_impl.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return BudgetRepositoryImpl(api);
});

final budgetsProvider =
    AsyncNotifierProvider<BudgetsNotifier, List<BudgetEntity>>(
  BudgetsNotifier.new,
);

class BudgetsNotifier extends AsyncNotifier<List<BudgetEntity>> {
  @override
  Future<List<BudgetEntity>> build() async {
    final repo = ref.read(budgetRepositoryProvider);
    return repo.getBudgets();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> addBudget(BudgetEntity budget) async {
    final repo = ref.read(budgetRepositoryProvider);
    final created = await repo.createBudget(budget);
    state.whenData((list) => state = AsyncData([...list, created]));
  }

  Future<void> updateBudget(BudgetEntity budget) async {
    final repo = ref.read(budgetRepositoryProvider);
    final updated = await repo.updateBudget(budget);
    state.whenData((list) {
      state = AsyncData(
        list.map((b) => b.id == updated.id ? updated : b).toList(),
      );
    });
  }

  Future<void> deleteBudget(String id) async {
    final repo = ref.read(budgetRepositoryProvider);
    await repo.deleteBudget(id);
    state.whenData(
        (list) => state = AsyncData(list.where((b) => b.id != id).toList()));
  }

  double get totalBudgeted {
    return state.whenOrNull(data: (list) {
      return list.fold<double>(0, (sum, b) => sum + b.amount);
    }) ?? 0;
  }

  double get totalSpent {
    return state.whenOrNull(data: (list) {
      return list.fold<double>(0, (sum, b) => sum + b.spent);
    }) ?? 0;
  }
}
