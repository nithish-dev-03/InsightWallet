import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../data/repositories/insight_repository_impl.dart';
import '../../domain/entities/insight_entity.dart';
import '../../domain/repositories/insight_repository.dart';

final insightRepositoryProvider = Provider<InsightRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return InsightRepositoryImpl(api);
});

final insightProvider = FutureProvider<InsightEntity>((ref) {
  final repo = ref.watch(insightRepositoryProvider);
  return repo.getInsights();
});
