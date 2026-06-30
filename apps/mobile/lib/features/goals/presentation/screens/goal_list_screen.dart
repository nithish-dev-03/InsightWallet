import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
import '../../domain/entities/goal_entity.dart';
import '../providers/goal_provider.dart';

class GoalListScreen extends ConsumerWidget {
  const GoalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-goal'),
        backgroundColor: AppColors.darkPrimaryContainer,
        child: const Icon(Icons.add_rounded),
      ),
      body: goalsAsync.when(
        loading: () => const ListShimmer(),
        error: (e, _) => ErrorStateWidget(
          message: e.toString(),
          onRetry: () => ref.read(goalsProvider.notifier).refresh(),
        ),
        data: (goals) => goals.isEmpty
            ? const EmptyStateWidget(
                icon: Icons.flag_rounded,
                title: 'No goals yet',
                subtitle: 'Set your first savings goal',
                actionLabel: 'Create Goal',
              )
            : _GoalListContent(goals: goals),
      ),
    );
  }
}

class _GoalListContent extends ConsumerWidget {
  final List<GoalEntity> goals;

  const _GoalListContent({required this.goals});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(goalsProvider.notifier);
    final totalTarget = notifier.totalTarget;
    final totalSaved = notifier.totalSaved;
    final overallPct = totalTarget > 0 ? totalSaved / totalTarget : 0.0;

    return ListView(
      padding: const EdgeInsets.all(Insets.md),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Goals Overview', style: AppTypography.headlineSm),
              const SizedBox(height: Insets.sm),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Target',
                            style: AppTypography.bodySm.copyWith(
                                color: AppColors.darkOnSurfaceVariant)),
                        AmountText(
                            amount: totalTarget, type: AmountType.neutral),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Total Saved',
                            style: AppTypography.bodySm.copyWith(
                                color: AppColors.darkOnSurfaceVariant)),
                        AmountText(
                            amount: totalSaved, type: AmountType.income),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.sm),
              ClipRRect(
                borderRadius: AppRadius.brMd,
                child: LinearProgressIndicator(
                  value: overallPct,
                  minHeight: 8,
                  backgroundColor: AppColors.darkSurfaceVariant,
                  valueColor: const AlwaysStoppedAnimation(
                      AppColors.darkPrimary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Insets.md),
        SectionHeader(title: 'All Goals'),
        const SizedBox(height: Insets.sm),
        ...goals.map((goal) => _GoalCard(
              goal: goal,
              onTap: () => Navigator.pushNamed(
                context,
                '/goal-detail',
                arguments: goal,
              ),
              onDelete: () => notifier.deleteGoal(goal.id),
            )),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final GoalEntity goal;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _GoalCard({
    required this.goal,
    required this.onTap,
    required this.onDelete,
  });

  Color _statusColor(GoalStatus status) {
    switch (status) {
      case GoalStatus.active:
        return AppColors.darkPrimary;
      case GoalStatus.completed:
        return AppColors.success;
      case GoalStatus.cancelled:
        return AppColors.darkOnSurfaceVariant;
    }
  }

  String _statusLabel(GoalStatus status) {
    switch (status) {
      case GoalStatus.active:
        return 'Active';
      case GoalStatus.completed:
        return 'Completed';
      case GoalStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(goal.id),
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
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 30,
              lineWidth: 5,
              percent: goal.percentage,
              center: Text(
                '${(goal.percentage * 100).toStringAsFixed(0)}%',
                style: AppTypography.labelMd.copyWith(
                  fontWeight: FontWeight.bold,
                  color: goal.color,
                ),
              ),
              progressColor: goal.color,
              backgroundColor: AppColors.darkSurfaceVariant,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(goal.icon, size: 16, color: goal.color),
                      const SizedBox(width: Insets.xs),
                      Expanded(
                        child: Text(
                          goal.name,
                          style: AppTypography.bodyMd.copyWith(
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Insets.xs),
                  AmountText(
                    amount: goal.currentAmount,
                    type: AmountType.income,
                    fontSize: 14,
                  ),
                  Text(
                    '/ \$${goal.targetAmount.toStringAsFixed(0)}',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.darkOnSurfaceVariant,
                      fontFamily: 'JetBrainsMono',
                    ),
                  ),
                  const SizedBox(height: Insets.xs),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 12,
                          color: goal.isOverdue
                              ? AppColors.expense
                              : AppColors.darkOnSurfaceVariant),
                      const SizedBox(width: Insets.xs),
                      Text(
                        goal.isOverdue
                            ? 'Overdue'
                            : '${goal.daysRemaining} days left',
                        style: AppTypography.labelMd.copyWith(
                          color: goal.isOverdue
                              ? AppColors.expense
                              : AppColors.darkOnSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Insets.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(goal.status)
                              .withValues(alpha: 0.2),
                          borderRadius: AppRadius.brSm,
                        ),
                        child: Text(
                          _statusLabel(goal.status),
                          style: AppTypography.labelMd.copyWith(
                            color: _statusColor(goal.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
