// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoalModelImpl _$$GoalModelImplFromJson(Map<String, dynamic> json) =>
    _$GoalModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      deadline: DateTime.parse(json['deadline'] as String),
      iconCodePoint: (json['iconCodePoint'] as num).toInt(),
      colorValue: (json['colorValue'] as num).toInt(),
      status: json['status'] as String,
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((e) => MilestoneModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GoalModelImplToJson(_$GoalModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'targetAmount': instance.targetAmount,
      'currentAmount': instance.currentAmount,
      'deadline': instance.deadline.toIso8601String(),
      'iconCodePoint': instance.iconCodePoint,
      'colorValue': instance.colorValue,
      'status': instance.status,
      'milestones': instance.milestones,
    };

_$MilestoneModelImpl _$$MilestoneModelImplFromJson(Map<String, dynamic> json) =>
    _$MilestoneModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$MilestoneModelImplToJson(
        _$MilestoneModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
    };
