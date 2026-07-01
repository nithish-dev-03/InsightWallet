import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
  String _selectedCategory = 'All';

  final _categories = [
    'All',
    'Shopping',
    'Food',
    'Transport',
    'Bills',
    'Salary',
    'Travel',
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

  void _applyFilter(String categoryName) {
    setState(() => _selectedCategory = categoryName);
    ref.read(transactionListProvider.notifier).applyFilter(
      TransactionFilter(
        category: categoryName == 'All' ? null : categoryName.toLowerCase(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textPrimary = isDark ? Colors.white : AppColors.lightOnSurface;
    final textSecondary = isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant;
    final chipBgColor = isDark ? const Color(0xFF221E28) : const Color(0xFFF0ECF9);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStitchHeader(context, isDark, textPrimary, textSecondary),
            _buildSearchAndActionsRow(context, isDark),
            _buildFilterChips(context, isDark, chipBgColor),
            const SizedBox(height: Insets.sm),
            Expanded(
              child: transactionsAsync.when(
                loading: () => const ListShimmer(itemCount: 8),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Failed to load transactions',
                        style: AppTypography.bodyMd.copyWith(color: textSecondary),
                      ),
                      const SizedBox(height: Insets.md),
                      FilledButton(
                        onPressed: () => ref.invalidate(transactionListProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.swap_horiz_rounded,
                      title: 'No transactions found',
                      subtitle: 'Try a different filter or search term.',
                    );
                  }

                  return RefreshIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    onRefresh: () => ref.read(transactionListProvider.notifier).refresh(),
                    child: ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(
                        left: Insets.md,
                        right: Insets.md,
                        bottom: Insets.xxl,
                      ),
                      children: [
                        _buildMonthlyInsightsCard(context, isDark),
                        const SizedBox(height: Insets.lg),
                        ..._buildGroupedTransactionList(context, transactions),
                        const SizedBox(height: Insets.md),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStitchHeader(BuildContext context, bool isDark, Color textPrimary, Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.md, Insets.md, Insets.md, Insets.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    'InsightWallet',
                    style: AppTypography.headlineSm.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
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
            ],
          ),
          const SizedBox(height: Insets.md),
          Text(
            'Transactions',
            style: AppTypography.displayLgMobile.copyWith(
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'October Spending: \$2,450.00',
            style: AppTypography.bodyMd.copyWith(
              color: isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndActionsRow(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1D1A24) : const Color(0xFFF0ECF9),
                borderRadius: AppRadius.brMd,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  ref.read(transactionListProvider.notifier).search(val);
                },
                style: AppTypography.bodyMd.copyWith(
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Search merchants, amounts...',
                  hintStyle: AppTypography.bodyMd.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: Insets.sm),
          _buildRoundedActionButton(context, Icons.calendar_month_outlined),
          const SizedBox(width: Insets.sm),
          _buildRoundedActionButton(context, Icons.file_download_outlined),
        ],
      ),
    );
  }

  Widget _buildRoundedActionButton(BuildContext context, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D1A24) : const Color(0xFFF0ECF9),
        borderRadius: AppRadius.brMd,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: () {},
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, bool isDark, Color chipBgColor) {
    final activeColor = isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final activeTextColor = isDark ? const Color(0xFF3F008E) : Colors.white;

    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: Insets.xs),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Insets.md),
        itemCount: _categories.length,
        itemBuilder: (ctx, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;

          return Padding(
            padding: const EdgeInsets.only(right: Insets.sm),
            child: GestureDetector(
              onTap: () => _applyFilter(cat),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : chipBgColor,
                  borderRadius: AppRadius.brFull,
                  border: Border.all(
                    color: isSelected ? activeColor : Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    if (cat != 'All') ...[
                      Icon(
                        _categoryIcon(cat.toLowerCase()),
                        size: 14,
                        color: isSelected ? activeTextColor : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      cat,
                      style: AppTypography.bodySm.copyWith(
                        color: isSelected ? activeTextColor : Theme.of(context).colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthlyInsightsCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF571BC1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.brXl,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(Insets.lg),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.auto_awesome,
              size: 80,
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 24),
                  const SizedBox(width: Insets.sm),
                  Text(
                    'Monthly Insights',
                    style: AppTypography.headlineSm.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.sm),
              Text(
                "You've saved \$420 more than last month. You're on track to hit your year-end travel goal!",
                style: AppTypography.bodyMd.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: Insets.lg),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
                  padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: 12),
                  elevation: 0,
                ),
                child: Text(
                  'VIEW ANALYSIS',
                  style: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedTransactionList(BuildContext context, List<TransactionEntity> transactions) {
    final List<Widget> widgets = [];

    final Map<String, List<TransactionEntity>> grouped = {};
    for (var t in transactions) {
      final key = FormatUtils.formatAbsoluteDate(t.date).toUpperCase();
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(t);
    }

    grouped.forEach((dateString, list) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(Insets.xs, Insets.md, Insets.xs, Insets.sm),
          child: Text(
            dateString,
            style: AppTypography.labelMd.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      );

      for (var t in list) {
        widgets.add(
          _TransactionListItemWidget(
            transaction: t,
            onTap: () => context.push('/transactions/${t.id}'),
            onDelete: () => _deleteTransaction(t.id),
          ),
        );
      }
    });

    return widgets;
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

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
      case 'dining':
        return Icons.restaurant_rounded;
      case 'transport':
      case 'travel':
        return Icons.directions_car_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'bills':
        return Icons.receipt_long_rounded;
      case 'salary':
        return Icons.work_rounded;
      default:
        return Icons.circle_rounded;
    }
  }
}

class _TransactionListItemWidget extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TransactionListItemWidget({
    required this.transaction,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final amountColor = isIncome
        ? (isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD))
        : (isDark ? const Color(0xFFFFB4AB) : const Color(0xFFBA1A1A));

    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.sm),
      child: Dismissible(
        key: ValueKey(transaction.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: Insets.md),
          decoration: BoxDecoration(
            color: const Color(0xFFBA1A1A).withValues(alpha: 0.15),
            borderRadius: AppRadius.brXl,
          ),
          child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFBA1A1A)),
        ),
        onDismissed: (_) => onDelete(),
        child: GlassCard(
          onTap: onTap,
          padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _categoryBgColor(context, transaction.category.toLowerCase()),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _categoryIcon(transaction.category.toLowerCase()),
                  size: 20,
                  color: _categoryColor(context, transaction.category.toLowerCase()),
                ),
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: AppTypography.bodyMd.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${transaction.category} • ${DateFormat('h:mm a').format(transaction.date)}',
                      style: AppTypography.bodySm.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Visa ****1234 • Palo Alto, CA',
                      style: AppTypography.bodySm.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Insets.sm),
              Text(
                '${isIncome ? '+' : '-'}${FormatUtils.formatCurrency(transaction.amount)}',
                style: AppTypography.bodyMd.copyWith(
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'food':
      case 'dining':
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
      case 'travel':
        return Icons.flight_takeoff_rounded;
      default:
        return Icons.circle_rounded;
    }
  }

  Color _categoryColor(BuildContext context, String category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (category) {
      case 'food':
      case 'dining':
        return isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
      case 'shopping':
      case 'transport':
        return isDark ? const Color(0xFFD0BCFF) : const Color(0xFF5516be);
      case 'bills':
        return isDark ? const Color(0xFFFFB4AB) : const Color(0xFFBA1A1A);
      case 'salary':
      case 'travel':
      default:
        return isDark ? const Color(0xFFFFB784) : const Color(0xFF713700);
    }
  }

  Color _categoryBgColor(BuildContext context, String category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (category) {
      case 'food':
      case 'dining':
        return (isDark ? const Color(0xFF7C3AED) : const Color(0xFF3525CD)).withValues(alpha: 0.2);
      case 'shopping':
      case 'transport':
        return (isDark ? const Color(0xFF571BC1) : const Color(0xFFe9ddff)).withValues(alpha: 0.25);
      case 'bills':
        return (isDark ? const Color(0xFF93000a) : const Color(0xFFffdad6)).withValues(alpha: 0.2);
      case 'salary':
      case 'travel':
      default:
        return (isDark ? const Color(0xFFa15100) : const Color(0xFFffdcc6)).withValues(alpha: 0.2);
    }
  }
}
