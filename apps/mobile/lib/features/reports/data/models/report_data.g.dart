// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportDataImpl _$$ReportDataImplFromJson(Map<String, dynamic> json) =>
    _$ReportDataImpl(
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      netSavings: (json['netSavings'] as num).toDouble(),
      categoryBreakdown: (json['categoryBreakdown'] as List<dynamic>)
          .map((e) => CategoryBreakdownData.fromJson(e as Map<String, dynamic>))
          .toList(),
      cashFlow: (json['cashFlow'] as List<dynamic>)
          .map((e) => CashFlowData.fromJson(e as Map<String, dynamic>))
          .toList(),
      trend: (json['trend'] as List<dynamic>)
          .map((e) => TrendData.fromJson(e as Map<String, dynamic>))
          .toList(),
      topCategories: (json['topCategories'] as List<dynamic>)
          .map((e) => TopCategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ReportDataImplToJson(_$ReportDataImpl instance) =>
    <String, dynamic>{
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'netSavings': instance.netSavings,
      'categoryBreakdown': instance.categoryBreakdown,
      'cashFlow': instance.cashFlow,
      'trend': instance.trend,
      'topCategories': instance.topCategories,
    };

_$CategoryBreakdownDataImpl _$$CategoryBreakdownDataImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryBreakdownDataImpl(
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      colorIndex: (json['colorIndex'] as num).toInt(),
    );

Map<String, dynamic> _$$CategoryBreakdownDataImplToJson(
        _$CategoryBreakdownDataImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'amount': instance.amount,
      'percentage': instance.percentage,
      'colorIndex': instance.colorIndex,
    };

_$CashFlowDataImpl _$$CashFlowDataImplFromJson(Map<String, dynamic> json) =>
    _$CashFlowDataImpl(
      month: json['month'] as String,
      income: (json['income'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
    );

Map<String, dynamic> _$$CashFlowDataImplToJson(_$CashFlowDataImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'income': instance.income,
      'expense': instance.expense,
    };

_$TrendDataImpl _$$TrendDataImplFromJson(Map<String, dynamic> json) =>
    _$TrendDataImpl(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$$TrendDataImplToJson(_$TrendDataImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
    };

_$TopCategoryDataImpl _$$TopCategoryDataImplFromJson(
        Map<String, dynamic> json) =>
    _$TopCategoryDataImpl(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      colorIndex: (json['colorIndex'] as num).toInt(),
    );

Map<String, dynamic> _$$TopCategoryDataImplToJson(
        _$TopCategoryDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
      'percentage': instance.percentage,
      'colorIndex': instance.colorIndex,
    };
