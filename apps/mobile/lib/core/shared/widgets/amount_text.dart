import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../utils/format_utils.dart';
import '../../../features/profile/presentation/providers/profile_provider.dart';

enum AmountType { income, expense, neutral }

class AmountText extends ConsumerWidget {
  final double amount;
  final AmountType type;
  final double? fontSize;
  final bool showCents;
  final bool showSign;
  final String? currencySymbol;
  final TextStyle? style;

  const AmountText({
    super.key,
    required this.amount,
    this.type = AmountType.neutral,
    this.fontSize,
    this.showCents = true,
    this.showSign = false,
    this.currencySymbol,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color = switch (type) {
      AmountType.income => AppColors.income,
      AmountType.expense => AppColors.expense,
      AmountType.neutral => AppColors.darkOnSurface,
    };

    final sign = switch (type) {
      AmountType.income => '+',
      AmountType.expense => '-',
      AmountType.neutral => '',
    };

    final activeSymbol = currencySymbol ?? ref.watch(currencySymbolProvider);

    final formatted = FormatUtils.formatCurrency(
      amount,
      showCents: showCents,
      currencySymbol: activeSymbol,
    );

    final textStyle = style ??
        AppTypography.numberXl.copyWith(
          color: color,
          fontSize: fontSize,
        );

    return Text(
      showSign ? '$sign$formatted' : formatted,
      style: textStyle,
    );
  }
}
