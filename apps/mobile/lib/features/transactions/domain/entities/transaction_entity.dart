import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_entity.freezed.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    required double amount,
    required String type,
    required String category,
    required String categoryIcon,
    required String categoryColor,
    required String description,
    required DateTime date,
    String? note,
    List<String>? tags,
    String? receiptUrl,
  }) = _TransactionEntity;
}
