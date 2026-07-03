import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final repo = ref.watch(insightRepositoryProvider);

  Future<InsightEntity> loadSample() async {
    final json = await SampleDataService.getInsightsData();
    final data = json['data'] as Map<String, dynamic>;
    return InsightModel.fromJson(data).toEntity();
  }

  try {
    final insights = await repo.getInsights();
    if (insights.monthlySummary.income != 0.0 || insights.monthlySummary.expense != 0.0) {
      return insights;
    }
    throw Exception('Insights is empty');
  } catch (e) {
    return loadSample();
  }
});
