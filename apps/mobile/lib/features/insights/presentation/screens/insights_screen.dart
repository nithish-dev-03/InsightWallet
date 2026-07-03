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
import '../../domain/entities/insight_entity.dart';
import '../providers/insight_provider.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(insightProvider);

    return AppScaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome_rounded,
                size: 20, color: AppColors.darkPrimary),
            const SizedBox(width: Insets.sm),
            const Text('AI Insights'),
          ],
        ),
        centerTitle: true,
      ),
      body: insightsAsync.when(
        loading: () => const ListShimmer(),
        error: (e, _) => ErrorStateWidget(message: e.toString()),
        data: (insights) => _InsightsContent(insights: insights),
      ),
    );
  }
}

class _InsightsContent extends StatelessWidget {
  final InsightEntity insights;

  const _InsightsContent({required this.insights});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Insets.md),
      children: [
        _MonthlySummaryCard(summary: insights.monthlySummary),
        const SizedBox(height: Insets.md),
        _SpendingPredictionCard(prediction: insights.spendingPrediction),
        const SizedBox(height: Insets.md),
        const SectionHeader(title: 'Budget Suggestions'),
        const SizedBox(height: Insets.sm),
        ...insights.budgetSuggestions.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm),
              child: _SuggestionCard(suggestion: s),
            )),
        const SizedBox(height: Insets.md),
        const SectionHeader(title: 'Expense Trends'),
        const SizedBox(height: Insets.sm),
        _TrendCard(trends: insights.expenseTrends),
        const SizedBox(height: Insets.xl),
      ],
    );
  }
}

class _MonthlySummaryCard extends StatelessWidget {
  final MonthlySummary summary;

  const _MonthlySummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Insets.sm),
                decoration: BoxDecoration(
                  color: AppColors.darkPrimaryContainer.withValues(alpha: 0.2),
                  borderRadius: AppRadius.brMd,
                ),
                child: const Icon(Icons.calendar_month_rounded,
                    color: AppColors.darkPrimary, size: 20),
              ),
              const SizedBox(width: Insets.sm),
              Text('Monthly Summary', style: AppTypography.headlineSm),
            ],
          ),
          const SizedBox(height: Insets.md),
          Row(
            children: [
              Expanded(
                child: _SummaryLine(
                  label: 'Income',
                  amount: summary.income,
                  change: summary.incomeChange,
                  isExpense: false,
                ),
              ),
              const SizedBox(width: Insets.sm),
              Expanded(
                child: _SummaryLine(
                  label: 'Expenses',
                  amount: summary.expense,
                  change: summary.expenseChange,
                  isExpense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final double amount;
  final double change;
  final bool isExpense;

  const _SummaryLine({
    required this.label,
    required this.amount,
    required this.change,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    final arrowIcon = isExpense
        ? (isPositive
            ? Icons.arrow_upward_rounded
            : Icons.arrow_downward_rounded)
        : (isPositive
            ? Icons.arrow_upward_rounded
            : Icons.arrow_downward_rounded);
    final arrowColor = isExpense
        ? (isPositive ? AppColors.expense : AppColors.success)
        : (isPositive ? AppColors.success : AppColors.expense);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.bodySm
                .copyWith(color: AppColors.darkOnSurfaceVariant)),
        const SizedBox(height: Insets.xs),
        AmountText(
          amount: amount,
          type: isExpense ? AmountType.expense : AmountType.income,
        ),
        const SizedBox(height: Insets.xs),
        Row(
          children: [
            Icon(arrowIcon, size: 14, color: arrowColor),
            const SizedBox(width: 2),
            Text(
              '${change.abs().toStringAsFixed(1)}% vs last month',
              style: AppTypography.labelMd.copyWith(color: arrowColor),
            ),
          ],
        ),
      ],
    );
  }
}

class _SpendingPredictionCard extends StatelessWidget {
  final SpendingPrediction prediction;

  const _SpendingPredictionCard({required this.prediction});

  @override
  Widget build(BuildContext context) {
    final Color trendColor = switch (prediction.trend) {
      TrendDirection.up => AppColors.expense,
      TrendDirection.down => AppColors.success,
      TrendDirection.stable => AppColors.warning,
    };
    final IconData trendIcon = switch (prediction.trend) {
      TrendDirection.up => Icons.trending_up_rounded,
      TrendDirection.down => Icons.trending_down_rounded,
      TrendDirection.stable => Icons.trending_flat_rounded,
    };
    final String trendLabel = switch (prediction.trend) {
      TrendDirection.up => 'Expected to increase',
      TrendDirection.down => 'Expected to decrease',
      TrendDirection.stable => 'Expected to remain stable',
    };

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Insets.sm),
                decoration: BoxDecoration(
                  color: AppColors.darkPrimaryContainer.withValues(alpha: 0.2),
                  borderRadius: AppRadius.brMd,
                ),
                child: const Icon(Icons.insights_rounded,
                    color: AppColors.darkPrimary, size: 20),
              ),
              const SizedBox(width: Insets.sm),
              Text('Spending Prediction', style: AppTypography.headlineSm),
            ],
          ),
          const SizedBox(height: Insets.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Predicted Next Month',
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.darkOnSurfaceVariant)),
                    const SizedBox(height: Insets.xs),
                    AmountText(
                        amount: prediction.predictedAmount,
                        type: AmountType.expense),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Current Average',
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.darkOnSurfaceVariant)),
                    const SizedBox(height: Insets.xs),
                    AmountText(
                        amount: prediction.currentAverage,
                        type: AmountType.neutral),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.sm),
          Row(
            children: [
              Icon(trendIcon, size: 18, color: trendColor),
              const SizedBox(width: Insets.xs),
              Text(trendLabel,
                  style: AppTypography.bodySm.copyWith(
                      color: trendColor, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final BudgetSuggestion suggestion;

  const _SuggestionCard({required this.suggestion});

  Color _urgencyColor(SuggestionUrgency urgency) {
    switch (urgency) {
      case SuggestionUrgency.high:
        return AppColors.expense;
      case SuggestionUrgency.medium:
        return AppColors.warning;
      case SuggestionUrgency.low:
        return AppColors.success;
    }
  }

  IconData _urgencyIcon(SuggestionUrgency urgency) {
    switch (urgency) {
      case SuggestionUrgency.high:
        return Icons.error_rounded;
      case SuggestionUrgency.medium:
        return Icons.warning_amber_rounded;
      case SuggestionUrgency.low:
        return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final urgColor = _urgencyColor(suggestion.urgency);

    return GlassCard(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: urgColor, width: 3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_urgencyIcon(suggestion.urgency), color: urgColor, size: 20),
            const SizedBox(width: Insets.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(suggestion.category,
                      style: AppTypography.bodyMd
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(suggestion.message,
                      style: AppTypography.bodySm
                          .copyWith(color: AppColors.darkOnSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  final List<ExpenseTrendPoint> trends;

  const _TrendCard({required this.trends});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: trends.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: Insets.lg),
              child: Center(
                child: Text('No trend data available',
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.darkOnSurfaceVariant)),
              ),
            )
          : SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: trends.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.amount);
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
                          if (idx >= 0 && idx < trends.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                trends[idx].month.length > 3
                                    ? trends[idx].month.substring(0, 3)
                                    : trends[idx].month,
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
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color:
                          AppColors.darkOutlineVariant.withValues(alpha: 0.2),
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
