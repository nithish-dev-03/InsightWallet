import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/goal_entity.dart';

part 'goal_model.freezed.dart';
part 'goal_model.g.dart';

@freezed
class GoalModel with _$GoalModel {
  const factory GoalModel({
    required String id,
    required String name,
    required double targetAmount,
    required double currentAmount,
    required DateTime deadline,
    required int iconCodePoint,
    required int colorValue,
    required String status,
    @Default([]) List<MilestoneModel> milestones,
  }) = _GoalModel;

  factory GoalModel.fromJson(Map<String, dynamic> json) =>
      _$GoalModelFromJson(json);
}

@freezed
class MilestoneModel with _$MilestoneModel {
  const factory MilestoneModel({
    required String id,
    required String title,
    @Default(false) bool isCompleted,
  }) = _MilestoneModel;

  factory MilestoneModel.fromJson(Map<String, dynamic> json) =>
      _$MilestoneModelFromJson(json);
}

extension GoalModelX on GoalModel {
  GoalEntity toEntity() => GoalEntity(
        id: id,
        name: name,
        targetAmount: targetAmount,
        currentAmount: currentAmount,
        deadline: deadline,
        icon: IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
        color: Color(colorValue),
        status: _statusFromString(status),
        milestones: milestones.map((m) => Milestone(
              id: m.id,
              title: m.title,
              isCompleted: m.isCompleted,
            )).toList(),
      );

  static GoalStatus _statusFromString(String value) {
    switch (value) {
      case 'active':
        return GoalStatus.active;
      case 'completed':
        return GoalStatus.completed;
      case 'cancelled':
        return GoalStatus.cancelled;
      default:
        return GoalStatus.active;
    }
  }
}

extension GoalEntityX on GoalEntity {
  GoalModel toModel() => GoalModel(
        id: id,
        name: name,
        targetAmount: targetAmount,
        currentAmount: currentAmount,
        deadline: deadline,
        iconCodePoint: icon.codePoint,
        colorValue: color.value,
        status: status.name,
        milestones: milestones
            .map((m) => MilestoneModel(
                  id: m.id,
                  title: m.title,
                  isCompleted: m.isCompleted,
                ))
            .toList(),
      );
}
