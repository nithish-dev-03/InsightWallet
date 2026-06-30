import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../core/shared/widgets/amount_text.dart';
import '../../../../core/shared/widgets/app_scaffold.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goal_provider.dart';

class GoalDetailScreen extends ConsumerStatefulWidget {
  final GoalEntity goal;

  const GoalDetailScreen({super.key, required this.goal});

  @override
  ConsumerState<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends ConsumerState<GoalDetailScreen> {
  late GoalEntity _goal;
  final _milestoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;
  }

  @override
  void dispose() {
    _milestoneController.dispose();
    super.dispose();
  }

  void _addMilestone() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
        title: const Text('Add Milestone'),
        content: TextField(
          controller: _milestoneController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g., Save \$500',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (_milestoneController.text.trim().isNotEmpty) {
                final milestone = Milestone(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _milestoneController.text.trim(),
                );
                setState(() {
                  _goal = _goal.copyWith(
                    milestones: [..._goal.milestones, milestone],
                  );
                });
                _milestoneController.clear();
                Navigator.pop(ctx);
                _saveGoal();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _toggleMilestone(int index) {
    setState(() {
      final milestones = [..._goal.milestones];
      milestones[index] = milestones[index].copyWith(
        isCompleted: !milestones[index].isCompleted,
      );
      _goal = _goal.copyWith(milestones: milestones);
    });
    _saveGoal();
  }

  void _deleteMilestone(int index) {
    setState(() {
      final milestones = [..._goal.milestones];
      milestones.removeAt(index);
      _goal = _goal.copyWith(milestones: milestones);
    });
    _saveGoal();
  }

  Future<void> _saveGoal() async {
    await ref.read(goalsProvider.notifier).updateGoal(_goal);
  }

  @override
  Widget build(BuildContext context) {
    final completedMilestones =
        _goal.milestones.where((m) => m.isCompleted).length;

    return AppScaffold(
      appBar: AppBar(
        title: Text(_goal.name),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                await ref.read(goalsProvider.notifier).deleteGoal(_goal.id);
                if (context.mounted) Navigator.pop(context);
              } else if (value == 'toggle_status') {
                final newStatus = _goal.status == GoalStatus.active
                    ? GoalStatus.completed
                    : GoalStatus.active;
                await ref
                    .read(goalsProvider.notifier)
                    .updateGoal(_goal.copyWith(status: newStatus));
                if (context.mounted) {
                  setState(() => _goal = _goal.copyWith(status: newStatus));
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'toggle_status',
                child: Text(_goal.status == GoalStatus.active
                    ? 'Mark Complete'
                    : 'Reactivate'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Goal'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Insets.md),
        children: [
          GlassCard(
            child: Column(
              children: [
                CircularPercentIndicator(
                  radius: 60,
                  lineWidth: 10,
                  percent: _goal.percentage,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(_goal.percentage * 100).toStringAsFixed(0)}%',
                        style: AppTypography.headlineSm.copyWith(
                          color: _goal.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Complete',
                        style: AppTypography.bodySm.copyWith(
                            color: AppColors.darkOnSurfaceVariant),
                      ),
                    ],
                  ),
                  progressColor: _goal.color,
                  backgroundColor: AppColors.darkSurfaceVariant,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(height: Insets.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AmountText(
                        amount: _goal.currentAmount,
                        type: AmountType.income),
                    Text(
                      ' / \$${_goal.targetAmount.toStringAsFixed(0)}',
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.darkOnSurfaceVariant,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatChip(
                      icon: Icons.monetization_on_rounded,
                      label: '\$${_goal.remaining.toStringAsFixed(0)}',
                      sublabel: 'Remaining',
                    ),
                    _StatChip(
                      icon: Icons.access_time_rounded,
                      label: '${_goal.daysRemaining} days',
                      sublabel: _goal.isOverdue ? 'Overdue' : 'Left',
                      color: _goal.isOverdue
                          ? AppColors.expense
                          : AppColors.darkOnSurface,
                    ),
                    _StatChip(
                      icon: Icons.flag_rounded,
                      label: '${_goal.milestones.length}',
                      sublabel: 'Milestones',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Insets.md),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Milestones',
                        style: AppTypography.headlineSm),
                    TextButton.icon(
                      onPressed: _addMilestone,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.sm),
                if (_goal.milestones.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Insets.md),
                    child: Center(
                      child: Text(
                        'No milestones yet. Add one to track progress.',
                        style: AppTypography.bodySm.copyWith(
                            color: AppColors.darkOnSurfaceVariant),
                      ),
                    ),
                  )
                else ...[
                  Text(
                    '$completedMilestones / ${_goal.milestones.length} completed',
                    style: AppTypography.bodySm.copyWith(
                        color: AppColors.darkOnSurfaceVariant),
                  ),
                  const SizedBox(height: Insets.sm),
                  ..._goal.milestones.asMap().entries.map((entry) {
                    final i = entry.key;
                    final milestone = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Insets.xs),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Insets.md,
                          vertical: Insets.sm,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleMilestone(i),
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: milestone.isCompleted
                                      ? AppColors.success
                                      : AppColors.darkSurfaceVariant,
                                  borderRadius: AppRadius.brSm,
                                  border: Border.all(
                                    color: milestone.isCompleted
                                        ? AppColors.success
                                        : AppColors.darkOutline,
                                  ),
                                ),
                                child: milestone.isCompleted
                                    ? const Icon(Icons.check_rounded,
                                        size: 16, color: Colors.white)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: Insets.sm),
                            Expanded(
                              child: Text(
                                milestone.title,
                                style: AppTypography.bodyMd.copyWith(
                                  decoration: milestone.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: milestone.isCompleted
                                      ? AppColors.darkOnSurfaceVariant
                                      : AppColors.darkOnSurface,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _deleteMilestone(i),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: AppColors.darkOnSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
          const SizedBox(height: Insets.md),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: _addMilestone,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Milestone'),
              style: FilledButton.styleFrom(
                backgroundColor:
                    AppColors.darkPrimaryContainer.withValues(alpha: 0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.brMd,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color? color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.sublabel,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color ?? AppColors.darkPrimary),
        const SizedBox(height: Insets.xs),
        Text(
          label,
          style: AppTypography.labelMd.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'JetBrainsMono',
            color: color ?? AppColors.darkOnSurface,
          ),
        ),
        Text(
          sublabel,
          style: AppTypography.bodySm.copyWith(
              color: AppColors.darkOnSurfaceVariant),
        ),
      ],
    );
  }
}
