import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../providers/transaction_list_provider.dart';
import '../providers/transaction_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync =
        ref.watch(singleTransactionProvider(transactionId));
    final currencySymbol = ref.watch(currencySymbolProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: transactionAsync is AsyncData
                ? () => context.push(
                      '/transactions/${transactionAsync.requireValue.id}/edit',
                      extra: transactionAsync.requireValue,
                    )
                : null,
          ),
        ],
      ),
      body: transactionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load transaction',
                style: AppTypography.bodyMd.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Insets.md),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(singleTransactionProvider(transactionId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (transaction) {
          final isIncome = transaction.type == 'income';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.md),
            child: Column(
              children: [
                GlassCard(
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color:
                              (isIncome ? AppColors.income : AppColors.expense)
                                  .withValues(alpha: 0.15),
                          borderRadius: AppRadius.brXl,
                        ),
                        child: Icon(
                          _categoryIcon(transaction.categoryIcon),
                          size: 32,
                          color:
                              isIncome ? AppColors.income : AppColors.expense,
                        ),
                      ),
                      const SizedBox(height: Insets.md),
                      Text(
                        transaction.category,
                        style: AppTypography.bodyMd.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Insets.sm),
                      Text(
                        '${isIncome ? '+' : '-'}${FormatUtils.formatCurrency(transaction.amount, currencySymbol: currencySymbol)}',
                        style: AppTypography.numberXl.copyWith(
                          color:
                              isIncome ? AppColors.income : AppColors.expense,
                        ),
                      ),
                      const SizedBox(height: Insets.sm),
                      Text(
                        transaction.description,
                        style: AppTypography.headlineSm.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Insets.sm),
                      _buildDetailRow(
                        context,
                        Icons.calendar_today_rounded,
                        'Date',
                        FormatUtils.formatAbsoluteDate(transaction.date),
                      ),
                      if (transaction.note != null &&
                          transaction.note!.isNotEmpty)
                        _buildDetailRow(
                          context,
                          Icons.notes_rounded,
                          'Note',
                          transaction.note!,
                        ),
                      if (transaction.tags != null &&
                          transaction.tags!.isNotEmpty)
                        _buildDetailRow(
                          context,
                          Icons.label_outline_rounded,
                          'Tags',
                          transaction.tags!.join(', '),
                        ),
                    ],
                  ),
                ),
                if (transaction.receiptUrl != null) ...[
                  const SizedBox(height: Insets.md),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Receipt',
                          style: AppTypography.bodyMd.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: Insets.sm),
                        ClipRRect(
                          borderRadius: AppRadius.brMd,
                          child: Image.network(
                            transaction.receiptUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              color: AppColors.surfaceContainerHighest,
                              child: Center(
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: Insets.lg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Transaction'),
                          content: const Text(
                            'Are you sure you want to delete this transaction? This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: AppColors.expense),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        ref.read(deleteTransactionProvider(transactionId));
                        ref.invalidate(transactionListProvider);
                        if (context.mounted) context.pop();
                      }
                    },
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Delete Transaction'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.expense,
                      side: BorderSide(
                          color: AppColors.expense.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.brMd,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: Insets.sm),
      child: Row(
        children: [
          Icon(icon,
              size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: Insets.sm),
          Text(
            '$label: ',
            style: AppTypography.bodySm.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySm.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
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
