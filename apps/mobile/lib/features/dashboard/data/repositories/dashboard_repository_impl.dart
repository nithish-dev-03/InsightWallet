import '../../../../core/services/storage_service.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/dashboard_data.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/config/api_config.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiService _api;

  DashboardRepositoryImpl(this._api);

  @override
  Future<DashboardEntity> getDashboardData() async {
    final response = await _api.get(ApiConfig.dashboard);
    final data = DashboardData.fromJson(response.data['data']);
    return data.toEntity();
  }
}

extension _DashboardDataX on DashboardData {
  DashboardEntity toEntity() {
    return DashboardEntity(
      balance: balance,
      monthlyIncome: monthlyIncome,
      monthlyExpense: monthlyExpense,
      savings: savings,
      budgetRemaining: budgetRemaining,
      recentTransactions: recentTransactions.map((t) => t.toEntity()).toList(),
      insight: insight,
      chartData: chartData,
      spendingBreakdown: spendingBreakdown.map((c) => c.toEntity()).toList(),
    );
  }
}

extension _TransactionSummaryX on TransactionSummary {
  TransactionSummaryEntity toEntity() {
    return TransactionSummaryEntity(
      id: id,
      description: description,
      amount: amount,
      type: type,
      category: category,
      categoryIcon: categoryIcon,
      date: date,
    );
  }
}

extension _CategoryBreakdownX on CategoryBreakdown {
  CategoryBreakdownEntity toEntity() {
    return CategoryBreakdownEntity(
      category: category,
      amount: amount,
      percentage: percentage,
      color: color,
    );
  }
}
