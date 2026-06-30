import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required double amount,
    required String type,
    required String category,
    @JsonKey(name: 'category_icon') required String categoryIcon,
    @JsonKey(name: 'category_color') required String categoryColor,
    required String description,
    required DateTime date,
    String? note,
    List<String>? tags,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

extension TransactionModelX on TransactionModel {
  Map<String, dynamic> toCreateJson() {
    return {
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
      if (note != null) 'note': note,
      if (tags != null) 'tags': tags,
    };
  }
}
