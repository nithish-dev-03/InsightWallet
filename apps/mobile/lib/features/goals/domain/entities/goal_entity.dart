import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum GoalStatus { active, completed, cancelled }

class Milestone extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;

  const Milestone({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Milestone copyWith({String? id, String? title, bool? isCompleted}) {
    return Milestone(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted];
}

class GoalEntity extends Equatable {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final IconData icon;
  final Color color;
  final GoalStatus status;
  final List<Milestone> milestones;

  const GoalEntity({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0,
    required this.deadline,
    this.icon = Icons.flag_rounded,
    this.color = Colors.purple,
    this.status = GoalStatus.active,
    this.milestones = const [],
  });

  double get percentage =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0;

  double get remaining =>
      (targetAmount - currentAmount).clamp(0, double.infinity);

  int get daysRemaining => DateTime.now().difference(deadline).inDays.abs();

  bool get isOverdue => DateTime.now().isAfter(deadline);

  GoalEntity copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    IconData? icon,
    Color? color,
    GoalStatus? status,
    List<Milestone>? milestones,
  }) {
    return GoalEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      status: status ?? this.status,
      milestones: milestones ?? this.milestones,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        targetAmount,
        currentAmount,
        deadline,
        icon,
        color,
        status,
        milestones,
      ];
}
