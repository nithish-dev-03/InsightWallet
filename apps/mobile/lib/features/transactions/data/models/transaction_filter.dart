import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_filter.freezed.dart';

@freezed
class TransactionFilter with _$TransactionFilter {
  const factory TransactionFilter({
    String? type,
    String? category,
    DateTime? dateFrom,
    DateTime? dateTo,
    @Default('date') String sortBy,
    @Default('desc') String sortOrder,
    String? search,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _TransactionFilter;
}
