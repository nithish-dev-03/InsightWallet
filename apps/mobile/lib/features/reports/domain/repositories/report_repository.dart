import '../entities/report_entity.dart';

enum ReportPeriod { weekly, monthly, yearly }

abstract class ReportRepository {
  Future<ReportEntity> getReport(ReportPeriod period);
}
