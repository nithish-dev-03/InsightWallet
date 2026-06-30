// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      category: json['category'] as String,
      categoryIcon: json['category_icon'] as String,
      categoryColor: json['category_color'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      receiptUrl: json['receipt_url'] as String?,
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': instance.type,
      'category': instance.category,
      'category_icon': instance.categoryIcon,
      'category_color': instance.categoryColor,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'note': instance.note,
      'tags': instance.tags,
      'receipt_url': instance.receiptUrl,
    };
