import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/sample_data_service.dart';
import '../../../../core/providers/providers.dart';
import '../../data/models/insight_model.dart';
import '../../data/repositories/insight_repository_impl.dart';
import '../../domain/entities/insight_entity.dart';
import '../../domain/repositories/insight_repository.dart';

final insightRepositoryProvider = Provider<InsightRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return InsightRepositoryImpl(api);
});

final insightProvider = FutureProvider<InsightEntity>((ref) async {
  if (isLoadSampleData) {
    final json = await SampleDataService.getInsightsData();
    final data = json['data'] as Map<String, dynamic>;
    return InsightModel.fromJson(data).toEntity();
  }
  final repo = ref.watch(insightRepositoryProvider);
  return repo.getInsights();
});
