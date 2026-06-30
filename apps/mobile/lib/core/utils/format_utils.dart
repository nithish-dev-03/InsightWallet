import 'package:intl/intl.dart';

class FormatUtils {
  FormatUtils._();

  static final _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _currencyNoCents = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  static final _percentFormat = NumberFormat.percentPattern('en_US');

  static final _compactFormat = NumberFormat.compact(locale: 'en_US');

  static String formatCurrency(
    double amount, {
    bool showCents = true,
    String? currencySymbol,
  }) {
    final format = showCents ? _currencyFormat : _currencyNoCents;
    if (currencySymbol != null && currencySymbol != '\$') {
      return NumberFormat.currency(
        symbol: currencySymbol,
        decimalDigits: showCents ? 2 : 0,
      ).format(amount);
    }
    return format.format(amount);
  }

  static String formatCompact(double amount) {
    return _compactFormat.format(amount);
  }

  static String formatPercentage(double value) {
    return _percentFormat.format(value / 100);
  }

  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '${months}mo ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  static String formatAbsoluteDate(DateTime date, {bool withTime = false}) {
    if (withTime) {
      return DateFormat('MMM d, yyyy - h:mm a').format(date);
    }
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static String formatDayMonth(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  static String abbreviateNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }
}
