import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/budget_entity.dart';

part 'budget_model.freezed.dart';
part 'budget_model.g.dart';

@freezed
class BudgetModel with _$BudgetModel {
  const factory BudgetModel({
    required String id,
    required String categoryId,
    required String categoryName,
    required double amount,
    required double spent,
    required String period,
    required DateTime startDate,
    required DateTime endDate,
    @Default(true) bool notifications,
  }) = _BudgetModel;

  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);
}

extension BudgetModelX on BudgetModel {
  BudgetEntity toEntity() => BudgetEntity(
        id: id,
        categoryId: categoryId,
        categoryName: categoryName,
        amount: amount,
        spent: spent,
        period: _periodFromString(period),
        startDate: startDate,
        endDate: endDate,
        notifications: notifications,
      );

  static BudgetPeriod _periodFromString(String value) {
    switch (value) {
      case 'weekly':
        return BudgetPeriod.weekly;
      case 'monthly':
        return BudgetPeriod.monthly;
      case 'yearly':
        return BudgetPeriod.yearly;
      default:
        return BudgetPeriod.monthly;
    }
  }
}

extension BudgetEntityX on BudgetEntity {
  BudgetModel toModel() => BudgetModel(
        id: id,
        categoryId: categoryId,
        categoryName: categoryName,
        amount: amount,
        spent: spent,
        period: period.name,
        startDate: startDate,
        endDate: endDate,
        notifications: notifications,
      );
}
