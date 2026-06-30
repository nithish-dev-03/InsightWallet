import '../../../../core/config/api_config.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/insight_entity.dart';
import '../../domain/repositories/insight_repository.dart';
import '../models/insight_model.dart';

class InsightRepositoryImpl implements InsightRepository {
  final ApiService _api;

  InsightRepositoryImpl(this._api);

  @override
  Future<InsightEntity> getInsights() async {
    final response = await _api.get(ApiConfig.insights);
    final data = response.data['data'] as Map<String, dynamic>;
    return InsightModel.fromJson(data).toEntity();
  }
}
