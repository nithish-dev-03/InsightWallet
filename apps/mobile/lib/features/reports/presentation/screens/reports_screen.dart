import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared/widgets/amount_text.dart';
import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/error_state.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/shared/widgets/loading_shimmer.dart';
import '../../../../core/shared/widgets/section_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../providers/report_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(reportProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        centerTitle: true,
      ),
      body: reportAsync.when(
        loading: () => const ListShimmer(),
        error: (e, _) => ErrorStateWidget(message: e.toString()),
        data: (report) => _ReportsContent(report: report),
      ),
    );
  }
}

class _ReportsContent extends ConsumerWidget {
  final ReportEntity report;

  const _ReportsContent({required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedReportPeriodProvider);

    return ListView(
      padding: const EdgeInsets.all(Insets.md),
      children: [
        GlassCard(
          child: SegmentedButton<ReportPeriod>(
            segments: const [
              ButtonSegment(
                  value: ReportPeriod.weekly, label: Text('Weekly')),
              ButtonSegment(
                  value: ReportPeriod.monthly, label: Text('Monthly')),
              ButtonSegment(
                  value: ReportPeriod.yearly, label: Text('Yearly')),
            ],
            selected: {selectedPeriod},
            onSelectionChanged: (set) =>
                ref.read(selectedReportPeriodProvider.notifier).state =
                    set.first,
          ),
        ),
        const SizedBox(height: Insets.md),
        _SummaryRow(report: report),
        const SizedBox(height: Insets.md),
        const SectionHeader(title: 'Category Breakdown'),
        const SizedBox(height: Insets.sm),
        _PieChartSection(data: report.categoryBreakdown),
        const SizedBox(height: Insets.md),
        const SectionHeader(title: 'Cash Flow'),
        const SizedBox(height: Insets.sm),
        _BarChartSection(data: report.cashFlow),
        const SizedBox(height: Insets.md),
        const SectionHeader(title: 'Trend'),
        const SizedBox(height: Insets.sm),
        _LineChartSection(data: report.trend),
        const SizedBox(height: Insets.md),
        const SectionHeader(title: 'Top Categories'),
        const SizedBox(height: Insets.sm),
        _TopCategoriesSection(data: report.topCategories),
        const SizedBox(height: Insets.xl),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final ReportEntity report;

  const _SummaryRow({required this.report});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Income',
                    style: AppTypography.bodySm.copyWith(
                        color: AppColors.darkOnSurfaceVariant)),
                const SizedBox(height: Insets.xs),
                AmountText(
                    amount: report.totalIncome, type: AmountType.income),
              ],
            ),
          ),
        ),
        const SizedBox(width: Insets.sm),
        Expanded(
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Expenses',
                    style: AppTypography.bodySm.copyWith(
                        color: AppColors.darkOnSurfaceVariant)),
                const SizedBox(height: Insets.xs),
                AmountText(
                    amount: report.totalExpense, type: AmountType.expense),
              ],
            ),
          ),
        ),
        const SizedBox(width: Insets.sm),
        Expanded(
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Net Savings',
                    style: AppTypography.bodySm.copyWith(
                        color: AppColors.darkOnSurfaceVariant)),
                const SizedBox(height: Insets.xs),
                AmountText(
                  amount: report.netSavings,
                  type: report.netSavings >= 0
                      ? AmountType.income
                      : AmountType.expense,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PieChartSection extends StatelessWidget {
  final List<CategoryBreakdown> data;

  const _PieChartSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: data.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  return PieChartSectionData(
                    value: item.amount,
                    color: item.color,
                    radius: 60,
                    title:
                        '${item.percentage.toStringAsFixed(0)}%',
                    titleStyle: AppTypography.labelMd.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: Insets.md),
          ...data.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: Insets.xs),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: AppRadius.brSm,
                      ),
                    ),
                    const SizedBox(width: Insets.sm),
                    Expanded(
                        child: Text(item.category,
                            style: AppTypography.bodySm)),
                    AmountText(
                      amount: item.amount,
                      type: AmountType.expense,
                      fontSize: 14,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _BarChartSection extends StatelessWidget {
  final List<CashFlowItem> data;

  const _BarChartSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: data.fold<double>(
                    0,
                    (max, item) =>
                        [max, item.income, item.expense].reduce(
                            (a, b) => a > b ? a : b)) *
                1.2,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final item = data[groupIndex];
                  return BarTooltipItem(
                    '${rodIndex == 0 ? 'Income' : 'Expense'}\n\$${rod.toY.toStringAsFixed(0)}',
                    AppTypography.bodySm.copyWith(color: Colors.white),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx >= 0 && idx < data.length) {
                      return Text(
                        data[idx].month.length > 3
                            ? data[idx].month.substring(0, 3)
                            : data[idx].month,
                        style: AppTypography.labelMd.copyWith(
                            color: AppColors.darkOnSurfaceVariant),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval:
                  data.fold<double>(0, (max, item) => item.income > max ? item.income : max) / 4,
              getDrawingHorizontalLine: (value) => FlLine(
                color: AppColors.darkOutlineVariant.withValues(alpha: 0.2),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: data.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: item.income,
                    color: AppColors.income,
                    width: 12,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  BarChartRodData(
                    toY: item.expense,
                    color: AppColors.expense,
                    width: 12,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],

              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _LineChartSection extends StatelessWidget {
  final List<TrendPoint> data;

  const _LineChartSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: data.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.value);
                }).toList(),
                isCurved: true,
                color: AppColors.darkPrimary,
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppColors.darkPrimary,
                      strokeWidth: 2,
                      strokeColor: AppColors.darkSurface,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.darkPrimary.withValues(alpha: 0.1),
                ),
              ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final idx = value.toInt();
                    if (idx >= 0 && idx < data.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          data[idx].label.length > 3
                              ? data[idx].label.substring(0, 3)
                              : data[idx].label,
                          style: AppTypography.labelMd.copyWith(
                              color: AppColors.darkOnSurfaceVariant),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '\$${value.toInt()}',
                      style: AppTypography.labelMd.copyWith(
                          color: AppColors.darkOnSurfaceVariant),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: AppColors.darkOutlineVariant.withValues(alpha: 0.2),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            minY: 0,
          ),
        ),
      ),
    );
  }
}

class _TopCategoriesSection extends StatelessWidget {
  final List<TopCategory> data;

  const _TopCategoriesSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: data.map((item) {
          final maxAmount = data.isNotEmpty
              ? data.map((e) => e.amount).reduce(
                  (a, b) => a > b ? a : b)
              : 1.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: Insets.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: AppRadius.brSm,
                      ),
                    ),
                    const SizedBox(width: Insets.sm),
                    Expanded(
                      child: Text(item.name,
                          style: AppTypography.bodyMd.copyWith(
                              fontWeight: FontWeight.w500)),
                    ),
                    AmountText(
                      amount: item.amount,
                      type: AmountType.expense,
                      fontSize: 14,
                    ),
                    const SizedBox(width: Insets.sm),
                    Text(
                      '${item.percentage.toStringAsFixed(1)}%',
                      style: AppTypography.labelMd.copyWith(
                          color: AppColors.darkOnSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.xs),
                ClipRRect(
                  borderRadius: AppRadius.brMd,
                  child: LinearProgressIndicator(
                    value: (item.amount / maxAmount).clamp(0.0, 1.0),
                    minHeight: 4,
                    backgroundColor: AppColors.darkSurfaceVariant,
                    valueColor: AlwaysStoppedAnimation(item.color),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
