import '../entities/insight_entity.dart';

abstract class InsightRepository {
  Future<InsightEntity> getInsights();
}
