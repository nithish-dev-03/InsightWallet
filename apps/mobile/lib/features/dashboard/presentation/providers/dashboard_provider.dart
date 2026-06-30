import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
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
    final repository = ref.read(_dashboardRepositoryProvider);
    return repository.getDashboardData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchDashboard);
  }
}
