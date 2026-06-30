import '../../../../core/config/api_config.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../models/report_data.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ApiService _api;

  ReportRepositoryImpl(this._api);

  @override
  Future<ReportEntity> getReport(ReportPeriod period) async {
    final response = await _api.get(
      ApiConfig.reportsSummary,
      queryParameters: {'period': period.name},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ReportData.fromJson(data).toEntity();
  }
}
