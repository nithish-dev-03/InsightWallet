import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared/widgets/amount_text.dart';
import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/empty_state.dart';
import '../../../../core/shared/widgets/error_state.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/shared/widgets/loading_shimmer.dart';
import '../../../../core/shared/widgets/section_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/budget_entity.dart';
import '../providers/budget_provider.dart';

class BudgetListScreen extends ConsumerWidget {
  const BudgetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-budget'),
        backgroundColor: AppColors.darkPrimaryContainer,
        child: const Icon(Icons.add_rounded),
      ),
      body: budgetsAsync.when(
        loading: () => const ListShimmer(),
        error: (e, _) => ErrorStateWidget(
          message: e.toString(),
          onRetry: () => ref.read(budgetsProvider.notifier).refresh(),
        ),
        data: (budgets) => budgets.isEmpty
            ? const EmptyStateWidget(
                icon: Icons.account_balance_wallet_rounded,
                title: 'No budgets yet',
                subtitle: 'Create your first budget to start tracking',
                actionLabel: 'Create Budget',
              )
            : _BudgetListContent(budgets: budgets),
      ),
    );
  }
}

class _BudgetListContent extends ConsumerWidget {
  final List<BudgetEntity> budgets;

  const _BudgetListContent({required this.budgets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(budgetsProvider.notifier);
    final totalBudgeted = notifier.totalBudgeted;
    final totalSpent = notifier.totalSpent;
    final overallPct = totalBudgeted > 0 ? totalSpent / totalBudgeted : 0.0;

    return ListView(
      padding: const EdgeInsets.all(Insets.md),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Budget Overview', style: AppTypography.headlineSm),
              const SizedBox(height: Insets.sm),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Budgeted',
                            style: AppTypography.bodySm.copyWith(
                                color: AppColors.darkOnSurfaceVariant)),
                        AmountText(
                            amount: totalBudgeted, type: AmountType.neutral),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Total Spent',
                            style: AppTypography.bodySm.copyWith(
                                color: AppColors.darkOnSurfaceVariant)),
                        AmountText(
                            amount: totalSpent, type: AmountType.expense),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.sm),
              ClipRRect(
                borderRadius: AppRadius.brMd,
                child: LinearProgressIndicator(
                  value: overallPct.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: AppColors.darkSurfaceVariant,
                  valueColor: AlwaysStoppedAnimation(
                    overallPct >= 1.0
                        ? AppColors.expense
                        : overallPct >= 0.8
                            ? AppColors.warning
                            : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Insets.md),
        const SectionHeader(title: 'All Budgets'),
        const SizedBox(height: Insets.sm),
        ...budgets.map((budget) => _BudgetCard(
              budget: budget,
              onTap: () => Navigator.pushNamed(
                context,
                '/edit-budget',
                arguments: budget,
              ),
              onDelete: () => notifier.deleteBudget(budget.id),
            )),
      ],
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final BudgetEntity budget;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budget,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final pct = budget.percentage.clamp(0.0, 1.0);
    final pctDisplay = (budget.percentage * 100).clamp(0.0, 100.0);
    final Color progressColor = budget.isOverBudget
        ? AppColors.expense
        : pct >= 0.8
            ? AppColors.warning
            : AppColors.success;

    return Dismissible(
      key: ValueKey(budget.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Insets.md),
        margin: const EdgeInsets.only(bottom: Insets.sm),
        decoration: BoxDecoration(
          color: AppColors.expense.withValues(alpha: 0.2),
          borderRadius: AppRadius.brXl,
        ),
        child: const Icon(Icons.delete_rounded, color: AppColors.expense),
      ),
      onDismissed: (_) => onDelete(),
      child: GlassCard(
        margin: const EdgeInsets.only(bottom: Insets.sm),
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(Insets.sm),
                  decoration: BoxDecoration(
                    color:
                        AppColors.darkPrimaryContainer.withValues(alpha: 0.2),
                    borderRadius: AppRadius.brMd,
                  ),
                  child: Icon(
                    _categoryIcon(budget.categoryName),
                    color: AppColors.darkPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(budget.categoryName,
                          style: AppTypography.bodyMd
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text(
                        '${budget.period.name.toUpperCase()} • ${_periodLabel(budget.period)}',
                        style: AppTypography.bodySm
                            .copyWith(color: AppColors.darkOnSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AmountText(amount: budget.spent, type: AmountType.expense),
                    Text(
                      '\$${budget.amount.toStringAsFixed(0)}',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.darkOnSurfaceVariant,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Insets.sm),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadius.brMd,
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 6,
                      backgroundColor: AppColors.darkSurfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                ),
                const SizedBox(width: Insets.sm),
                Text(
                  '${pctDisplay.toStringAsFixed(0)}%',
                  style: AppTypography.labelMd.copyWith(color: progressColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'food':
      case 'dining':
        return Icons.restaurant_rounded;
      case 'transport':
      case 'transportation':
        return Icons.directions_car_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'bills':
      case 'utilities':
        return Icons.receipt_long_rounded;
      case 'health':
      case 'healthcare':
        return Icons.local_hospital_rounded;
      case 'education':
        return Icons.school_rounded;
      case 'housing':
      case 'rent':
        return Icons.home_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  String _periodLabel(BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.weekly:
        return 'This Week';
      case BudgetPeriod.monthly:
        return 'This Month';
      case BudgetPeriod.yearly:
        return 'This Year';
    }
  }
}
