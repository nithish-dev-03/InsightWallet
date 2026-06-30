import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/report_entity.dart';

part 'report_data.freezed.dart';
part 'report_data.g.dart';

@freezed
class ReportData with _$ReportData {
  const factory ReportData({
    required double totalIncome,
    required double totalExpense,
    required double netSavings,
    required List<CategoryBreakdownData> categoryBreakdown,
    required List<CashFlowData> cashFlow,
    required List<TrendData> trend,
    required List<TopCategoryData> topCategories,
  }) = _ReportData;

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);
}

@freezed
class CategoryBreakdownData with _$CategoryBreakdownData {
  const factory CategoryBreakdownData({
    required String category,
    required double amount,
    required double percentage,
    required int colorIndex,
  }) = _CategoryBreakdownData;

  factory CategoryBreakdownData.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownDataFromJson(json);
}

@freezed
class CashFlowData with _$CashFlowData {
  const factory CashFlowData({
    required String month,
    required double income,
    required double expense,
  }) = _CashFlowData;

  factory CashFlowData.fromJson(Map<String, dynamic> json) =>
      _$CashFlowDataFromJson(json);
}

@freezed
class TrendData with _$TrendData {
  const factory TrendData({
    required String label,
    required double value,
  }) = _TrendData;

  factory TrendData.fromJson(Map<String, dynamic> json) =>
      _$TrendDataFromJson(json);
}

@freezed
class TopCategoryData with _$TopCategoryData {
  const factory TopCategoryData({
    required String name,
    required double amount,
    required double percentage,
    required int colorIndex,
  }) = _TopCategoryData;

  factory TopCategoryData.fromJson(Map<String, dynamic> json) =>
      _$TopCategoryDataFromJson(json);
}

extension ReportDataX on ReportData {
  ReportEntity toEntity() => ReportEntity(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        netSavings: netSavings,
        categoryBreakdown: categoryBreakdown
            .map((c) => CategoryBreakdown(
                  category: c.category,
                  amount: c.amount,
                  percentage: c.percentage,
                  color: AppColors.chartColors[
                      c.colorIndex % AppColors.chartColors.length],
                ))
            .toList(),
        cashFlow: cashFlow
            .map((c) => CashFlowItem(
                  month: c.month,
                  income: c.income,
                  expense: c.expense,
                ))
            .toList(),
        trend: trend
            .map((t) => TrendPoint(label: t.label, value: t.value))
            .toList(),
        topCategories: topCategories
            .map((t) => TopCategory(
                  name: t.name,
                  amount: t.amount,
                  percentage: t.percentage,
                  color: AppColors.chartColors[
                      t.colorIndex % AppColors.chartColors.length],
                ))
            .toList(),
      );
}

extension ReportEntityX on ReportEntity {
  ReportData toData() => ReportData(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        netSavings: netSavings,
        categoryBreakdown: categoryBreakdown
            .map((c) => CategoryBreakdownData(
                  category: c.category,
                  amount: c.amount,
                  percentage: c.percentage,
                  colorIndex: AppColors.chartColors.indexOf(c.color),
                ))
            .toList(),
        cashFlow: cashFlow
            .map((c) => CashFlowData(
                  month: c.month,
                  income: c.income,
                  expense: c.expense,
                ))
            .toList(),
        trend: trend
            .map((t) => TrendData(label: t.label, value: t.value))
            .toList(),
        topCategories: topCategories
            .map((t) => TopCategoryData(
                  name: t.name,
                  amount: t.amount,
                  percentage: t.percentage,
                  colorIndex: AppColors.chartColors.indexOf(t.color),
                ))
            .toList(),
      );
}
