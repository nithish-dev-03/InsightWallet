import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/shared/widgets/glass_card.dart';
import '../../../../core/shared/widgets/loading_shimmer.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/format_utils.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../providers/dashboard_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../profile/domain/entities/profile_entity.dart';
import '../widgets/statement_import_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
          child: dashboardAsync.when(
            loading: () => const ListShimmer(itemCount: 6),
            error: (e, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Something went wrong',
                    style: AppTypography.bodyMd.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Insets.md),
                  FilledButton(
                    onPressed: () => ref.invalidate(dashboardProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            data: (data) {
              final currencySymbol = ref.watch(currencySymbolProvider);
              final profile = profileAsync.valueOrNull;
              return _DashboardContent(
                data: data,
                currencySymbol: currencySymbol,
                profile: profile,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatefulWidget {
  final DashboardEntity data;
  final String currencySymbol;
  final ProfileEntity? profile;

  const _DashboardContent({
    required this.data,
    required this.currencySymbol,
    this.profile,
  });

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          Insets.md, Insets.sm, Insets.md, Insets.xxl),
      children: [
        _buildAppBar(context),
        const SizedBox(height: Insets.md),
        _buildGreeting(context),
        const SizedBox(height: Insets.lg),
        _buildBalanceCard(context),
        const SizedBox(height: Insets.lg),
        _buildQuickActions(context),
        const SizedBox(height: Insets.lg),
        _buildWeeklySpendingChart(context),
        const SizedBox(height: Insets.lg),
        _buildMonthlyBudget(context),
        const SizedBox(height: Insets.lg),
        _buildRecentTransactions(context),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.menu,
            color: isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: Insets.xs),
        Text(
          'InsightWallet',
          style: AppTypography.headlineMd.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD),
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed: () => context.push('/notifications'),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: Insets.xs),
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? const Color(0xFFD2BBFF).withValues(alpha: 0.2)
                    : const Color(0xFF3525CD).withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: AppRadius.brFull,
              child: widget.profile?.avatar != null &&
                      widget.profile!.avatar!.isNotEmpty
                  ? Image.network(
                      widget.profile!.avatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark
                            ? const Color(0xFF221E28)
                            : const Color(0xFFF0ECF9),
                        alignment: Alignment.center,
                        child: Text(
                          widget.profile?.name.isNotEmpty == true
                              ? widget.profile!.name[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFFD2BBFF)
                                : const Color(0xFF3525CD),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: isDark
                          ? const Color(0xFF221E28)
                          : const Color(0xFFF0ECF9),
                      alignment: Alignment.center,
                      child: Text(
                        widget.profile?.name.isNotEmpty == true
                            ? widget.profile!.name[0].toUpperCase()
                            : 'U',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFD2BBFF)
                              : const Color(0xFF3525CD),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final name = widget.profile?.name;
    final greetingName = name != null && name.trim().isNotEmpty
        ? name.trim().split(' ').first
        : 'User';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, $greetingName',
          style: AppTypography.headlineMd.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ready to optimize your financial intelligence today?',
          style: AppTypography.bodySm.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    final hasBalance = widget.data.balance != 0.0;
    final balanceText = hasBalance
        ? FormatUtils.formatCurrency(widget.data.balance,
            currencySymbol: widget.currencySymbol)
        : '0.00';
    final dotIndex = balanceText.indexOf('.');
    final dollarPart =
        dotIndex != -1 ? balanceText.substring(0, dotIndex) : balanceText;
    final centsPart = dotIndex != -1 ? balanceText.substring(dotIndex) : '';

    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF571BC1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.brXl,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 130,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL BALANCE',
                style: AppTypography.labelMd.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: Insets.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    dollarPart,
                    style: AppTypography.displayLg.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 38,
                    ),
                  ),
                  Text(
                    centsPart,
                    style: AppTypography.headlineSm.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.lg),
              Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.15),
              ),
              const SizedBox(height: Insets.lg),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: AppRadius.brMd,
                          ),
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: Insets.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Income',
                              style: AppTypography.labelMd.copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            Text(
                              widget.data.monthlyIncome != 0.0
                                  ? FormatUtils.formatCurrency(
                                      widget.data.monthlyIncome,
                                      currencySymbol: widget.currencySymbol)
                                  : '--',
                              style: AppTypography.bodyMd.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: AppRadius.brMd,
                          ),
                          child: const Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: Insets.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expenses',
                              style: AppTypography.labelMd.copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            Text(
                              widget.data.monthlyExpense != 0.0
                                  ? FormatUtils.formatCurrency(
                                      widget.data.monthlyExpense,
                                      currencySymbol: widget.currencySymbol)
                                  : '--',
                              style: AppTypography.bodyMd.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        _buildActionRow(
          context,
          icon: Icons.add,
          label: 'Add Transaction',
          iconColor: isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD),
          bgColor: (isDark ? const Color(0xFF7C3AED) : const Color(0xFF3525CD))
              .withValues(alpha: 0.2),
          onTap: () => context.push('/transactions/add'),
        ),
        const SizedBox(height: Insets.sm),
        _buildActionRow(
          context,
          icon: Icons.document_scanner_outlined,
          label: 'Scan Receipt',
          iconColor: isDark ? const Color(0xFFFFB784) : const Color(0xFF713700),
          bgColor: (isDark ? const Color(0xFFa15100) : const Color(0xFFffdcc6))
              .withValues(alpha: 0.25),
          onTap: () => context.push('/transactions/add', extra: true),
        ),
        const SizedBox(height: Insets.sm),
        _buildActionRow(
          context,
          icon: Icons.upload_file_rounded,
          label: 'Import Bank Statement',
          iconColor: isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD),
          bgColor: (isDark ? const Color(0xFF7C3AED) : const Color(0xFF3525CD))
              .withValues(alpha: 0.2),
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const StatementImportDialog(),
            );
          },
        ),
        const SizedBox(height: Insets.sm),
        // _buildActionRow(
        //   context,
        //   icon: Icons.sync_alt,
        //   label: 'Transfer Funds',
        //   iconColor: isDark ? const Color(0xFFD0BCFF) : const Color(0xFF5516be),
        //   bgColor: (isDark ? const Color(0xFF571BC1) : const Color(0xFFe9ddff))
        //       .withValues(alpha: 0.25),
        //   onTap: () {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Transfer feature coming soon!')),
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _buildActionRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
          horizontal: Insets.md, vertical: Insets.md),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: Insets.md),
          Text(
            label,
            style: AppTypography.headlineSm.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.chevron_right,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant
                .withValues(alpha: 0.5),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySpendingChart(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);

    return GlassCard(
      padding: const EdgeInsets.all(Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Weekly Spending',
                  style: AppTypography.headlineSm.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: AppRadius.brFull,
                ),
                child: Text(
                  '+12% vs last week',
                  style: AppTypography.labelMd.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.xl),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
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
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun'
                        ];
                        final index = value.toInt();
                        if (index >= 0 && index < days.length) {
                          return Text(
                            days[index],
                            style: AppTypography.labelMd.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
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
                    spots: const [
                      FlSpot(0, 120),
                      FlSpot(1, 110),
                      FlSpot(2, 60),
                      FlSpot(3, 80),
                      FlSpot(4, 40),
                      FlSpot(5, 70),
                      FlSpot(6, 30),
                    ],
                    isCurved: true,
                    color: const Color(0xFF7C3AED),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: const Color(0xFF7C3AED),
                        strokeWidth: 0,
                      ),
                      checkToShowDot: (spot, barData) {
                        return spot.x == 1 ||
                            spot.x == 3 ||
                            spot.x == 4 ||
                            spot.x == 5 ||
                            spot.x == 6;
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF7C3AED).withValues(alpha: 0.3),
                          const Color(0xFF7C3AED).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyBudget(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? const Color(0xFFD2BBFF) : const Color(0xFF3525CD);
    final secondaryColor =
        isDark ? const Color(0xFFD0BCFF) : const Color(0xFF5516be);
    final tertiaryColor =
        isDark ? const Color(0xFFFFB784) : const Color(0xFF713700);

    return GlassCard(
      padding: const EdgeInsets.all(Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Budget',
            style: AppTypography.headlineSm.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: Insets.lg),
          _buildBudgetProgressRow(
            context,
            category: 'Dining & Drinks',
            spent: 450,
            total: 600,
            color: primaryColor,
          ),
          const SizedBox(height: Insets.md),
          _buildBudgetProgressRow(
            context,
            category: 'Entertainment',
            spent: 120,
            total: 300,
            color: secondaryColor,
          ),
          const SizedBox(height: Insets.md),
          _buildBudgetProgressRow(
            context,
            category: 'Shopping',
            spent: 890,
            total: 1000,
            color: tertiaryColor,
          ),
          const SizedBox(height: Insets.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.brMd,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'MANAGE BUDGETS',
                style: AppTypography.labelMd.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetProgressRow(
    BuildContext context, {
    required String category,
    required double spent,
    required double total,
    required Color color,
  }) {
    final progress = (spent / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: AppTypography.bodySm.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${FormatUtils.formatCurrency(spent, currencySymbol: widget.currencySymbol)} / ${FormatUtils.formatCurrency(total, currencySymbol: widget.currencySymbol)}',
              style: AppTypography.labelMd.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: AppRadius.brFull,
          child: Container(
            height: 8,
            width: double.infinity,
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.3),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    final transactions = widget.data.recentTransactions;

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: AppTypography.headlineSm.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/transactions'),
                  child: Text(
                    'VIEW ALL',
                    style: AppTypography.labelMd.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: 0.1),
          ),
          if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Insets.lg, vertical: Insets.xl),
              child: Center(
                child: Text(
                  '--',
                  style: AppTypography.headlineMd.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.4),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => Container(
                height: 1,
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withValues(alpha: 0.1),
              ),
              itemBuilder: (context, index) {
                final t = transactions[index];
                final isIncome = t.type == 'income';
                final isDark = Theme.of(context).brightness == Brightness.dark;

                Color containerBg;
                Color iconColor;

                switch (t.category.toLowerCase()) {
                  case 'technology':
                    containerBg = (isDark
                            ? const Color(0xFF571BC1)
                            : const Color(0xFFe9ddff))
                        .withValues(alpha: 0.2);
                    iconColor = isDark
                        ? const Color(0xFFD0BCFF)
                        : const Color(0xFF5516be);
                    break;
                  case 'salary':
                    containerBg = (isDark
                            ? const Color(0xFF7C3AED)
                            : const Color(0xFF3525CD))
                        .withValues(alpha: 0.2);
                    iconColor = isDark
                        ? const Color(0xFFD2BBFF)
                        : const Color(0xFF3525CD);
                    break;
                  case 'dining':
                  default:
                    containerBg = (isDark
                            ? const Color(0xFFa15100)
                            : const Color(0xFFffdcc6))
                        .withValues(alpha: 0.2);
                    iconColor = isDark
                        ? const Color(0xFFFFB784)
                        : const Color(0xFF713700);
                    break;
                }

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: Insets.lg, vertical: 8),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: containerBg,
                      borderRadius: AppRadius.brMd,
                    ),
                    child: Icon(
                      _categoryIcon(t.categoryIcon),
                      color: iconColor,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    t.description,
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    FormatUtils.formatRelativeDate(t.date),
                    style: AppTypography.bodySm.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isIncome ? '+' : '-'}${FormatUtils.formatCurrency(t.amount.abs(), currencySymbol: widget.currencySymbol)}',
                        style: AppTypography.headlineSm.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isIncome
                              ? (isDark
                                  ? const Color(0xFFD2BBFF)
                                  : const Color(0xFF3525CD))
                              : (isDark
                                  ? const Color(0xFFFFB4AB)
                                  : const Color(0xFFBA1A1A)),
                        ),
                      ),
                      Text(
                        t.category,
                        style: AppTypography.labelMd.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'shopping_bag':
      case 'shopping_cart':
        return Icons.shopping_bag_outlined;
      case 'work':
        return Icons.work_outline;
      case 'restaurant':
      case 'dining':
        return Icons.restaurant_outlined;
      case 'coffee':
        return Icons.coffee_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
