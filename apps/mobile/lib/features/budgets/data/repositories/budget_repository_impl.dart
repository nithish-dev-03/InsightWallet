import '../../../../core/config/api_config.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final ApiService _api;

  BudgetRepositoryImpl(this._api);

  @override
  Future<List<BudgetEntity>> getBudgets() async {
    final response = await _api.get(ApiConfig.budgets);
    final list = response.data['data'] as List;
    return list
        .map((json) =>
            BudgetModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }

  @override
  Future<BudgetEntity> getBudgetById(String id) async {
    final response = await _api.get(ApiConfig.budgetById(id));
    final data = response.data['data'] as Map<String, dynamic>;
    return BudgetModel.fromJson(data).toEntity();
  }

  @override
  Future<BudgetEntity> createBudget(BudgetEntity budget) async {
    final model = BudgetEntityX(budget).toModel();
    final response = await _api.post(
      ApiConfig.budgets,
      data: model.toJson(),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return BudgetModel.fromJson(data).toEntity();
  }

  @override
  Future<BudgetEntity> updateBudget(BudgetEntity budget) async {
    final model = BudgetEntityX(budget).toModel();
    final response = await _api.put(
      ApiConfig.budgetById(budget.id),
      data: model.toJson(),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return BudgetModel.fromJson(data).toEntity();
  }

  @override
  Future<void> deleteBudget(String id) async {
    await _api.delete(ApiConfig.budgetById(id));
  }

  @override
  Future<List<BudgetEntity>> getBudgetsByPeriod(BudgetPeriod period) async {
    final response = await _api.get(
      ApiConfig.budgets,
      queryParameters: {'period': period.name},
    );
    final list = response.data['data'] as List;
    return list
        .map((json) =>
            BudgetModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }
}
