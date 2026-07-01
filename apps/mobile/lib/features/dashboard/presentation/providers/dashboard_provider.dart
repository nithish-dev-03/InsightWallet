import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/sample_data_service.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/models/dashboard_data.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

final _dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final storage = StorageService();
  final api = ApiService(storage);
  return DashboardRepositoryImpl(api);
});

final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardEntity>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AsyncNotifier<DashboardEntity> {
  @override
  Future<DashboardEntity> build() async {
    return _fetchDashboard();
  }

  Future<DashboardEntity> _fetchDashboard() async {
    if (isLoadSampleData) {
      final json = await SampleDataService.getDashboardData();
      final data = json['data'] as Map<String, dynamic>;
      final dashboardData = DashboardData.fromJson(data);
      return DashboardEntity(
        balance: dashboardData.balance,
        monthlyIncome: dashboardData.monthlyIncome,
        monthlyExpense: dashboardData.monthlyExpense,
        savings: dashboardData.savings,
        budgetRemaining: dashboardData.budgetRemaining,
        recentTransactions: dashboardData.recentTransactions
            .map((t) => TransactionSummaryEntity(
                  id: t.id,
                  description: t.description,
                  amount: t.amount,
                  type: t.type,
                  category: t.category,
                  categoryIcon: t.categoryIcon,
                  date: t.date,
                ))
            .toList(),
        insight: dashboardData.insight,
        chartData: dashboardData.chartData,
        spendingBreakdown: dashboardData.spendingBreakdown
            .map((c) => CategoryBreakdownEntity(
                  category: c.category,
                  amount: c.amount,
                  percentage: c.percentage,
                  color: c.color,
                ))
            .toList(),
      );
    }
    final repository = ref.read(_dashboardRepositoryProvider);
    return repository.getDashboardData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchDashboard);
  }
}
