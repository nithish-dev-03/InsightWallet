import '../../../../core/config/api_config.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import '../models/goal_model.dart';

class GoalRepositoryImpl implements GoalRepository {
  final ApiService _api;

  GoalRepositoryImpl(this._api);

  @override
  Future<List<GoalEntity>> getGoals() async {
    final response = await _api.get(ApiConfig.goals);
    final list = response.data['data'] as List;
    return list
        .map((json) =>
            GoalModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }

  @override
  Future<GoalEntity> getGoalById(String id) async {
    final response = await _api.get(ApiConfig.goalById(id));
    final data = response.data['data'] as Map<String, dynamic>;
    return GoalModel.fromJson(data).toEntity();
  }

  @override
  Future<GoalEntity> createGoal(GoalEntity goal) async {
    final model = GoalEntityX(goal).toModel();
    final response = await _api.post(
      ApiConfig.goals,
      data: model.toJson(),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return GoalModel.fromJson(data).toEntity();
  }

  @override
  Future<GoalEntity> updateGoal(GoalEntity goal) async {
    final model = GoalEntityX(goal).toModel();
    final response = await _api.put(
      ApiConfig.goalById(goal.id),
      data: model.toJson(),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return GoalModel.fromJson(data).toEntity();
  }

  @override
  Future<void> deleteGoal(String id) async {
    await _api.delete(ApiConfig.goalById(id));
  }
}
