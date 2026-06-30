import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/shared/widgets/loading_shimmer.dart';
import '../../../../core/shared/widgets/section_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
        child: dashboardAsync.when(
          loading: () => const ListShimmer(itemCount: 6),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Something went wrong',
                  style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: Insets.md),
                FilledButton(
                  onPressed: () => ref.invalidate(dashboardProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (data) => _DashboardContent(data: data),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardEntity data;

  const _DashboardContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: Insets.xl),
      children: [
        _buildAppBar(context),
        _buildBalanceCard(context),
        const SizedBox(height: Insets.md),
        _buildIncomeExpenseRow(context),
        const SizedBox(height: Insets.md),
        _buildQuickActions(context),
        const SizedBox(height: Insets.md),
        _buildInsightBanner(context),
        const SizedBox(height: Insets.lg),
        const SectionHeader(title: 'Spending Breakdown'),
        const SizedBox(height: Insets.sm),
        _buildPieChart(context),
        const SizedBox(height: Insets.lg),
        const SectionHeader(title: 'Recent Transactions', actionLabel: 'See All'),
        const SizedBox(height: Insets.sm),
        _buildRecentTransactions(context),
        const SizedBox(height: Insets.lg),
        const SectionHeader(title: 'Monthly Trend'),
        const SizedBox(height: Insets.sm),
        _buildLineChart(context),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.md, Insets.sm, Insets.md, Insets.sm),
      child: Row(
        children: [
          Text(
            'InsightWallet',
            style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: Insets.sm),
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryContainer,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: Container(
        padding: const EdgeInsets.all(Insets.lg),
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppRadius.brXl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Total Balance',
                  style: AppTypography.bodyMd.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.visibility_rounded,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ],
            ),
            const SizedBox(height: Insets.sm),
            Text(
              FormatUtils.formatCurrency(data.balance),
              style: AppTypography.numberXl.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: Row(
        children: [
          Expanded(
            child: _MiniStatCard(
              label: 'Income',
              amount: data.monthlyIncome,
              gradient: AppColors.incomeGradient,
            ),
          ),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: _MiniStatCard(
              label: 'Expense',
              amount: data.monthlyExpense,
              gradient: AppColors.expenseGradient,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickActionButton(
            icon: Icons.swap_horiz_rounded,
            label: 'Transfer',
            onTap: () {},
          ),
          _QuickActionButton(
            icon: Icons.wallet_rounded,
            label: 'Top Up',
            onTap: () {},
          ),
          _QuickActionButton(
            icon: Icons.receipt_long_rounded,
            label: 'Bills',
            onTap: () {},
          ),
          _QuickActionButton(
            icon: Icons.document_scanner_rounded,
            label: 'Scan',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildInsightBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.2),
                borderRadius: AppRadius.brMd,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: Insets.sm),
            Expanded(
              child: Text(
                data.insight,
                style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final breakdown = data.spendingBreakdown;
    if (breakdown.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No spending data')),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GlassCard(
        child: SizedBox(
          height: 220,
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: List.generate(
                      breakdown.length,
                      (i) {
                        final c = breakdown[i];
                        final colorIndex = i % AppColors.chartColors.length;
                        return PieChartSectionData(
                          value: c.percentage,
                          color: AppColors.chartColors[colorIndex],
                          radius: 30,
                          title: '${c.percentage.toStringAsFixed(0)}%',
                          titleStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Insets.md),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  breakdown.length,
                  (i) {
                    final c = breakdown[i];
                    final colorIndex = i % AppColors.chartColors.length;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.chartColors[colorIndex],
                              borderRadius: AppRadius.brSm,
                            ),
                          ),
                          const SizedBox(width: Insets.sm),
                          Text(
                            c.category,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    final transactions = data.recentTransactions;
    if (transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(Insets.md),
        child: Center(child: Text('No recent transactions')),
      );
    }

    return Column(
      children: List.generate(
        transactions.length,
        (i) {
          final t = transactions[i];
          final isIncome = t.type == 'income';
          return Padding(
            padding: EdgeInsets.only(
              left: Insets.md,
              right: Insets.md,
              bottom: i < transactions.length - 1 ? Insets.sm : 0,
            ),
            child: GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (isIncome
                              ? AppColors.income
                              : AppColors.expense)
                          .withValues(alpha: 0.15),
                      borderRadius: AppRadius.brMd,
                    ),
                    child: Icon(
                      _categoryIcon(t.categoryIcon),
                      size: 20,
                      color: isIncome ? AppColors.income : AppColors.expense,
                    ),
                  ),
                  const SizedBox(width: Insets.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.description,
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          FormatUtils.formatRelativeDate(t.date),
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${isIncome ? '+' : '-'}${FormatUtils.formatCurrency(t.amount)}',
                    style: AppTypography.labelMd.copyWith(
                      color: isIncome ? AppColors.income : AppColors.expense,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLineChart(BuildContext context) {
    final chartData = data.chartData;
    if (chartData.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No trend data')),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: GlassCard(
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppColors.outline.withValues(alpha: 0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final months = [
                        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                      ];
                      final index = value.toInt();
                      if (index >= 0 && index < months.length) {
                        return Text(
                          months[index],
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.onSurfaceVariant,
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
                  spots: List.generate(
                    chartData.length,
                    (i) => FlSpot(i.toDouble(), chartData[i]),
                  ),
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String iconName) {
    switch (iconName) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'bills':
        return Icons.receipt_long_rounded;
      case 'salary':
        return Icons.work_rounded;
      case 'freelance':
        return Icons.code_rounded;
      case 'investment':
        return Icons.trending_up_rounded;
      default:
        return Icons.circle_rounded;
    }
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final double amount;
  final LinearGradient gradient;

  const _MiniStatCard({
    required this.label,
    required this.amount,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: AppRadius.brXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: Insets.sm),
          Text(
            FormatUtils.formatCurrency(amount),
            style: AppTypography.labelMd.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.brXl,
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: Insets.xs),
          Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
