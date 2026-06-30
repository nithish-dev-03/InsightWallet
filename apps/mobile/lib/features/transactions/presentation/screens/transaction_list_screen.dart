import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/empty_state.dart';
import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/shared/widgets/loading_shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../data/models/transaction_filter.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/transaction_list_provider.dart';
import '../providers/transaction_provider.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _selectedType = 'all';

  final _categories = [
    'All',
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Salary',
    'Freelance',
    'Investment',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(transactionListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTypeFilter(),
          if (_selectedType != 'all') _buildCategoryFilter(),
          Expanded(
            child: transactionsAsync.when(
              loading: () => const ListShimmer(),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Failed to load transactions',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: Insets.md),
                    FilledButton(
                      onPressed: () =>
                          ref.invalidate(transactionListProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.swap_horiz_rounded,
                    title: 'No transactions yet',
                    subtitle: 'Start by adding your first transaction.',
                    actionLabel: 'Add Transaction',
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () =>
                      ref.read(transactionListProvider.notifier).refresh(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      left: Insets.md,
                      right: Insets.md,
                      bottom: 80,
                    ),
                    itemCount: transactions.length + 1,
                    itemBuilder: (_, index) {
                      if (index == transactions.length) {
                        return const Padding(
                          padding: EdgeInsets.all(Insets.md),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      return _TransactionItem(
                        transaction: transactions[index],
                        onTap: () => context.push(
                          '/transactions/${transactions[index].id}',
                        ),
                        onDelete: () => _deleteTransaction(transactions[index].id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/transactions/add'),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.md, Insets.sm, Insets.md, Insets.sm),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          ref.read(transactionListProvider.notifier).search(value);
        },
        style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
        decoration: InputDecoration(
          hintText: 'Search transactions...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(transactionListProvider.notifier).search('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.surface,
          border: const OutlineInputBorder(
            borderRadius: AppRadius.brXl,
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildTypeFilter() {
    return Padding(
      padding: const EdgeInsets.only(left: Insets.md, right: Insets.md, bottom: Insets.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ['all', 'income', 'expense'].map((type) {
            final selected = _selectedType == type;
            final label = type == 'all' ? 'All' : type == 'income' ? 'Income' : 'Expense';
            return Padding(
              padding: const EdgeInsets.only(right: Insets.sm),
              child: FilterChip(
                label: Text(label),
                selected: selected,
                onSelected: (_) {
                  setState(() => _selectedType = type);
                  ref.read(transactionListProvider.notifier).applyFilter(
                    TransactionFilter(type: type == 'all' ? null : type),
                  );
                },
                selectedColor: type == 'income'
                    ? AppColors.income.withValues(alpha: 0.2)
                    : type == 'expense'
                        ? AppColors.expense.withValues(alpha: 0.2)
                        : AppColors.primaryContainer.withValues(alpha: 0.3),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.only(left: Insets.md, right: Insets.md, bottom: Insets.sm),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: Insets.sm),
          itemBuilder: (_, index) {
            final category = _categories[index];
            final isAll = category == 'All';
            return ActionChip(
              label: Text(
                category,
                style: AppTypography.bodySm.copyWith(
                  color: isAll ? AppColors.primary : AppColors.onSurfaceVariant,
                ),
              ),
              onPressed: () {
                ref.read(transactionListProvider.notifier).applyFilter(
                  TransactionFilter(
                    type: _selectedType == 'all' ? null : _selectedType,
                    category: isAll ? null : category.toLowerCase(),
                  ),
                );
              },
              side: BorderSide.none,
              backgroundColor: AppColors.surface,
            );
          },
        ),
      ),
    );
  }

  Future<void> _deleteTransaction(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.expense)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref.read(deleteTransactionProvider(id));
      ref.read(transactionListProvider.notifier).refresh();
    }
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TransactionItem({
    required this.transaction,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';

    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Insets.md),
        margin: const EdgeInsets.only(bottom: Insets.sm),
        decoration: BoxDecoration(
          color: AppColors.expense.withValues(alpha: 0.2),
          borderRadius: AppRadius.brXl,
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.expense),
      ),
      onDismissed: (_) => onDelete(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: Insets.sm),
        child: GlassCard(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (isIncome ? AppColors.income : AppColors.expense)
                      .withValues(alpha: 0.15),
                  borderRadius: AppRadius.brMd,
                ),
                child: Icon(
                  _categoryIcon(transaction.categoryIcon),
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
                      transaction.description,
                      style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          transaction.category,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        if (transaction.tags != null && transaction.tags!.isNotEmpty) ...[
                          const SizedBox(width: Insets.sm),
                          Text(
                            '• ${transaction.tags!.first}',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '${isIncome ? '+' : '-'}${FormatUtils.formatCurrency(transaction.amount)}',
                style: AppTypography.labelMd.copyWith(
                  color: isIncome ? AppColors.income : AppColors.expense,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
