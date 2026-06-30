import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../data/repositories/goal_repository_impl.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return GoalRepositoryImpl(api);
});

final goalsProvider = AsyncNotifierProvider<GoalsNotifier, List<GoalEntity>>(
  GoalsNotifier.new,
);

class GoalsNotifier extends AsyncNotifier<List<GoalEntity>> {
  @override
  Future<List<GoalEntity>> build() async {
    final repo = ref.read(goalRepositoryProvider);
    return repo.getGoals();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> addGoal(GoalEntity goal) async {
    final repo = ref.read(goalRepositoryProvider);
    final created = await repo.createGoal(goal);
    state.whenData((list) => state = AsyncData([...list, created]));
  }

  Future<void> updateGoal(GoalEntity goal) async {
    final repo = ref.read(goalRepositoryProvider);
    final updated = await repo.updateGoal(goal);
    state.whenData((list) {
      state = AsyncData(
        list.map((g) => g.id == updated.id ? updated : g).toList(),
      );
    });
  }

  Future<void> deleteGoal(String id) async {
    final repo = ref.read(goalRepositoryProvider);
    await repo.deleteGoal(id);
    state.whenData(
        (list) => state = AsyncData(list.where((g) => g.id != id).toList()));
  }

  double get totalTarget {
    return state.whenOrNull(data: (list) {
      return list.fold<double>(0, (sum, g) => sum + g.targetAmount);
    }) ?? 0;
  }

  double get totalSaved {
    return state.whenOrNull(data: (list) {
      return list.fold<double>(0, (sum, g) => sum + g.currentAmount);
    }) ?? 0;
  }
}
