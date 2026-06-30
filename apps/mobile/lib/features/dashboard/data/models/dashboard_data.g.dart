// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardDataImpl _$$DashboardDataImplFromJson(Map<String, dynamic> json) =>
    _$DashboardDataImpl(
      balance: (json['balance'] as num).toDouble(),
      monthlyIncome: (json['monthly_income'] as num).toDouble(),
      monthlyExpense: (json['monthly_expense'] as num).toDouble(),
      savings: (json['savings'] as num).toDouble(),
      budgetRemaining: (json['budget_remaining'] as num).toDouble(),
      recentTransactions: (json['recent_transactions'] as List<dynamic>)
          .map((e) => TransactionSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      insight: json['insight'] as String,
      chartData: (json['chart_data'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      spendingBreakdown: (json['spending_breakdown'] as List<dynamic>)
          .map((e) => CategoryBreakdown.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DashboardDataImplToJson(_$DashboardDataImpl instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'monthly_income': instance.monthlyIncome,
      'monthly_expense': instance.monthlyExpense,
      'savings': instance.savings,
      'budget_remaining': instance.budgetRemaining,
      'recent_transactions': instance.recentTransactions,
      'insight': instance.insight,
      'chart_data': instance.chartData,
      'spending_breakdown': instance.spendingBreakdown,
    };

_$TransactionSummaryImpl _$$TransactionSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionSummaryImpl(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      category: json['category'] as String,
      categoryIcon: json['category_icon'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$TransactionSummaryImplToJson(
        _$TransactionSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
      'type': instance.type,
      'category': instance.category,
      'category_icon': instance.categoryIcon,
      'date': instance.date.toIso8601String(),
    };

_$CategoryBreakdownImpl _$$CategoryBreakdownImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryBreakdownImpl(
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      color: json['color'] as String,
    );

Map<String, dynamic> _$$CategoryBreakdownImplToJson(
        _$CategoryBreakdownImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'amount': instance.amount,
      'percentage': instance.percentage,
      'color': instance.color,
    };
