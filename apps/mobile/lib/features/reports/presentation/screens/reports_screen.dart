import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/shared/widgets/loading_shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../providers/report_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(reportProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () => ref.refresh(reportProvider.future),
          child: reportAsync.when(
            loading: () => const ListShimmer(itemCount: 6),
            error: (e, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Failed to load analytics',
                    style: AppTypography.bodyMd.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Insets.md),
                  FilledButton(
                    onPressed: () => ref.invalidate(reportProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (report) => _ReportsContent(report: report),
          ),
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textPrimary = isDark ? Colors.white : AppColors.lightOnSurface;
    final textSecondary = isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant;

    return ListView(
      padding: const EdgeInsets.only(bottom: Insets.xxl),
      children: [
        _buildHeader(context, isDark, textPrimary, textSecondary),
        _buildPeriodSelector(context, ref, selectedPeriod, isDark),
        const SizedBox(height: Insets.lg),
        _buildCashFlowTrendSection(context, isDark),
        const SizedBox(height: Insets.lg),
        _buildExpenseBreakdownSection(context, isDark),
        const SizedBox(height: Insets.lg),
        _buildTopCategoriesSection(context, isDark),
        const SizedBox(height: Insets.lg),
        _buildAISmartInsights(context, isDark),
        const SizedBox(height: Insets.lg),
        _buildYearlyComparisonSection(context, isDark),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, Color textPrimary, Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.md, Insets.md, Insets.md, Insets.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD),
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: Insets.sm),
                    Text(
                      'Analytics & Reports',
                      style: AppTypography.headlineSm.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.sm),
                Text(
                  'Visualizing your financial flow for October 2023',
                  style: AppTypography.bodySm.copyWith(
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: Insets.xs),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? const Color(0xFFD2BBFF).withValues(alpha: 0.2) : const Color(0xFF3525CD).withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: const ClipRRect(
              borderRadius: AppRadius.brFull,
              child: Image(
                image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDc4P91ASw0u4e7bnbpZ9-x-GF05UH8kSUPdR07iBoKzIMmVgLRm-lwjIGKLmfG8_oPxiEt2qy0WiUtwg1n0KeSiFDsiBnCNFHx4xD99Yuc13RzEK9zlXCW30ByP9f0LhYj5oBjmfbYxatzpqjaB7Afu6NUZnEryTpGKksFV5-46hIXezwFTuyyaqBEeGIlGJDD2Kz0TBLbXw0zxeqyuDnu3k9d9kxXp6qwh5OVwin6XNftIQlu1DNP745qXNRLEFZSjDL1EPctMEC6',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(
    BuildContext context,
    WidgetRef ref,
    ReportPeriod selectedPeriod,
    bool isDark,
  ) {
    final activeBgColor = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final activeTextColor = isDark ? const Color(0xFF3F008E) : Colors.white;
    final inactiveBgColor = isDark ? const Color(0xFF221E28) : const Color(0xFFF0ECF9);

    final periods = [
      {'label': 'Week', 'val': ReportPeriod.weekly},
      {'label': 'Month', 'val': ReportPeriod.monthly},
      {'label': 'Year', 'val': ReportPeriod.yearly},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: inactiveBgColor,
          borderRadius: AppRadius.brFull,
        ),
        child: Row(
          children: periods.map((p) {
            final isSelected = selectedPeriod == p['val'];
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(selectedReportPeriodProvider.notifier).state = p['val'] as ReportPeriod;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? activeBgColor : Colors.transparent,
                    borderRadius: AppRadius.brFull,
                  ),
                  child: Text(
                    p['label'] as String,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMd.copyWith(
                      color: isSelected ? activeTextColor : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCashFlowTrendSection(BuildContext context, bool isDark) {
    final primaryColor = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final tertiaryColor = isDark ? const Color(0xFFFFB784) : const Color(0xFF713700);

    final displayIncome = report.totalIncome == 0.0 ? 12450.00 : report.totalIncome;
    final displayExpense = report.totalExpense == 0.0 ? 8210.45 : report.totalExpense;

    const incomeSpots = [
      FlSpot(0, 10000),
      FlSpot(1, 11500),
      FlSpot(2, 12800),
      FlSpot(3, 12450),
      FlSpot(4, 13100),
    ];
    const expenseSpots = [
      FlSpot(0, 7200),
      FlSpot(1, 8900),
      FlSpot(2, 7900),
      FlSpot(3, 8210),
      FlSpot(4, 8050),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cash Flow Trend',
                  style: AppTypography.headlineSm.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _buildLegendItem(context, 'Income', primaryColor),
                    const SizedBox(width: Insets.sm),
                    _buildLegendItem(context, 'Expense', tertiaryColor),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Insets.lg),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const dates = ['Oct 01', 'Oct 08', 'Oct 15', 'Oct 22', 'Oct 31'];
                          final idx = value.toInt();
                          if (idx >= 0 && idx < dates.length) {
                            return Text(
                              dates[idx],
                              style: AppTypography.labelMd.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                fontSize: 10,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: incomeSpots,
                      isCurved: true,
                      color: primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 4,
                          color: primaryColor,
                          strokeWidth: 0,
                        ),
                        checkToShowDot: (spot, barData) => spot.x == 1 || spot.x == 4,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withValues(alpha: 0.25),
                            primaryColor.withValues(alpha: 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    LineChartBarData(
                      spots: expenseSpots,
                      isCurved: true,
                      color: tertiaryColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Insets.md),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Income',
                        style: AppTypography.bodySm.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        FormatUtils.formatCurrency(displayIncome),
                        style: AppTypography.headlineSm.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.15),
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Spent',
                        style: AppTypography.bodySm.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        FormatUtils.formatCurrency(displayExpense),
                        style: AppTypography.headlineSm.copyWith(
                          fontWeight: FontWeight.bold,
                          color: tertiaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseBreakdownSection(BuildContext context, bool isDark) {
    final primaryColor = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final tertiaryColor = isDark ? const Color(0xFFFFB784) : const Color(0xFF713700);
    final secondaryContainer = isDark ? const Color(0xFF7C3AED) : const Color(0xFF4F46E5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense Breakdown',
              style: AppTypography.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Insets.lg),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 42,
                          sections: [
                            PieChartSectionData(
                              value: 45,
                              color: primaryColor,
                              radius: 12,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 28,
                              color: tertiaryColor,
                              radius: 12,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 27,
                              color: secondaryContainer,
                              radius: 12,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total Spent',
                              style: AppTypography.bodySm.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$8.2k',
                              style: AppTypography.bodyMd.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Insets.lg),
                Expanded(
                  child: Column(
                    children: [
                      _buildBreakdownLegend(context, 'Housing', '45%', primaryColor),
                      const Divider(height: 16, thickness: 0.5),
                      _buildBreakdownLegend(context, 'Food', '28%', tertiaryColor),
                      const Divider(height: 16, thickness: 0.5),
                      _buildBreakdownLegend(context, 'Other', '27%', secondaryContainer),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownLegend(BuildContext context, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: Insets.sm),
            Text(
              label,
              style: AppTypography.bodyMd.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: AppTypography.bodyMd.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTopCategoriesSection(BuildContext context, bool isDark) {
    final primaryColor = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final tertiaryColor = isDark ? const Color(0xFFFFB784) : const Color(0xFF713700);
    final secondaryContainerColor = isDark ? const Color(0xFF7C3AED) : const Color(0xFF4F46E5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Categories',
              style: AppTypography.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Insets.lg),
            _buildCategoryRow(
              context,
              icon: Icons.restaurant_outlined,
              label: 'Food & Dining',
              spent: 2340,
              budget: 2500,
              color: primaryColor,
              iconBg: primaryColor.withValues(alpha: 0.15),
            ),
            const SizedBox(height: Insets.md),
            _buildCategoryRow(
              context,
              icon: Icons.shopping_bag_outlined,
              label: 'Shopping',
              spent: 1120,
              budget: 1500,
              color: tertiaryColor,
              iconBg: tertiaryColor.withValues(alpha: 0.15),
            ),
            const SizedBox(height: Insets.md),
            _buildCategoryRow(
              context,
              icon: Icons.commute_outlined,
              label: 'Transportation',
              spent: 650,
              budget: 1000,
              color: secondaryContainerColor,
              iconBg: secondaryContainerColor.withValues(alpha: 0.15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double spent,
    required double budget,
    required Color color,
    required Color iconBg,
  }) {
    final progress = (spent / budget).clamp(0.0, 1.0);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: AppRadius.brMd,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: Insets.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodyMd.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${spent.toInt()} / \$${budget.toInt()}',
                    style: AppTypography.bodySm.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: AppRadius.brFull,
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAISmartInsights(BuildContext context, bool isDark) {
    final primaryColor = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final tertiaryColor = isDark ? const Color(0xFFFFB784) : const Color(0xFF713700);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.smart_toy_outlined,
                  color: primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI Smart Insights',
                  style: AppTypography.headlineSm.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Insets.xs),
          _buildInsightCard(
            context,
            icon: Icons.trending_up,
            iconColor: primaryColor,
            title: 'Spending Alert',
            body: 'You spent 18% more on Food this month compared to your 3-month average.',
            bgColor: primaryColor.withValues(alpha: 0.05),
            borderColor: primaryColor.withValues(alpha: 0.15),
          ),
          const SizedBox(height: Insets.sm),
          _buildInsightCard(
            context,
            icon: Icons.savings_outlined,
            iconColor: tertiaryColor,
            title: 'Saving Opportunity',
            body: "Switching to the 'Premium Plus' savings plan could earn you \$125 extra in interest this year.",
            bgColor: tertiaryColor.withValues(alpha: 0.05),
            borderColor: tertiaryColor.withValues(alpha: 0.15),
          ),
          const SizedBox(height: Insets.sm),
          _buildInsightCard(
            context,
            icon: Icons.event_repeat,
            iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
            title: 'Upcoming Subscription',
            body: "InsightStream renews tomorrow. You haven't used this service in 3 weeks.",
            bgColor: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.05),
            borderColor: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.15),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String body,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodySm.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: AppTypography.bodySm.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyComparisonSection(BuildContext context, bool isDark) {
    final primaryColor = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final tertiaryColor = isDark ? const Color(0xFFFFB784) : const Color(0xFF713700);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yearly Comparison',
              style: AppTypography.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Insets.lg),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          final months = ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];
                          final idx = value.toInt();
                          if (idx >= 0 && idx < months.length) {
                            return Text(
                              months[idx],
                              style: AppTypography.labelMd.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                fontSize: 10,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    _makeBarGroup(0, 6.0, 4.0, primaryColor, tertiaryColor),
                    _makeBarGroup(1, 8.0, 5.5, primaryColor, tertiaryColor),
                    _makeBarGroup(2, 7.0, 6.5, primaryColor, tertiaryColor),
                    _makeBarGroup(3, 9.0, 4.5, primaryColor, tertiaryColor),
                    _makeBarGroup(4, 7.5, 5.0, primaryColor, tertiaryColor),
                    _makeBarGroup(5, 8.5, 6.0, primaryColor, tertiaryColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double income, double expense, Color primary, Color tertiary) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: income,
          color: primary,
          width: 8,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        BarChartRodData(
          toY: expense,
          color: tertiary,
          width: 8,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
}
