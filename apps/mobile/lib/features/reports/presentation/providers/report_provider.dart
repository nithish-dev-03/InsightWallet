import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/sample_data_service.dart';
import '../../../../core/providers/providers.dart';
import '../../data/models/report_data.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  return ReportRepositoryImpl(api);
});

final selectedReportPeriodProvider = StateProvider<ReportPeriod>(
  (ref) => ReportPeriod.monthly,
);

final reportProvider = FutureProvider<ReportEntity>((ref) async {
  if (isLoadSampleData) {
    final json = await SampleDataService.getReportsData();
    final data = json['data'] as Map<String, dynamic>;
    return ReportData.fromJson(data).toEntity();
  }
  final period = ref.watch(selectedReportPeriodProvider);
  final repo = ref.watch(reportRepositoryProvider);
  return repo.getReport(period);
});
