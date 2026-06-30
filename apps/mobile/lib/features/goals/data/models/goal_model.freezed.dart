// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GoalModel _$GoalModelFromJson(Map<String, dynamic> json) {
  return _GoalModel.fromJson(json);
}

/// @nodoc
mixin _$GoalModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get targetAmount => throw _privateConstructorUsedError;
  double get currentAmount => throw _privateConstructorUsedError;
  DateTime get deadline => throw _privateConstructorUsedError;
  int get iconCodePoint => throw _privateConstructorUsedError;
  int get colorValue => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<MilestoneModel> get milestones => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoalModelCopyWith<GoalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalModelCopyWith<$Res> {
  factory $GoalModelCopyWith(GoalModel value, $Res Function(GoalModel) then) =
      _$GoalModelCopyWithImpl<$Res, GoalModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      double targetAmount,
      double currentAmount,
      DateTime deadline,
      int iconCodePoint,
      int colorValue,
      String status,
      List<MilestoneModel> milestones});
}

/// @nodoc
class _$GoalModelCopyWithImpl<$Res, $Val extends GoalModel>
    implements $GoalModelCopyWith<$Res> {
  _$GoalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? deadline = null,
    Object? iconCodePoint = null,
    Object? colorValue = null,
    Object? status = null,
    Object? milestones = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAmount: null == currentAmount
          ? _value.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      milestones: null == milestones
          ? _value.milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<MilestoneModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoalModelImplCopyWith<$Res>
    implements $GoalModelCopyWith<$Res> {
  factory _$$GoalModelImplCopyWith(
          _$GoalModelImpl value, $Res Function(_$GoalModelImpl) then) =
      __$$GoalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double targetAmount,
      double currentAmount,
      DateTime deadline,
      int iconCodePoint,
      int colorValue,
      String status,
      List<MilestoneModel> milestones});
}

/// @nodoc
class __$$GoalModelImplCopyWithImpl<$Res>
    extends _$GoalModelCopyWithImpl<$Res, _$GoalModelImpl>
    implements _$$GoalModelImplCopyWith<$Res> {
  __$$GoalModelImplCopyWithImpl(
      _$GoalModelImpl _value, $Res Function(_$GoalModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? targetAmount = null,
    Object? currentAmount = null,
    Object? deadline = null,
    Object? iconCodePoint = null,
    Object? colorValue = null,
    Object? status = null,
    Object? milestones = null,
  }) {
    return _then(_$GoalModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      targetAmount: null == targetAmount
          ? _value.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currentAmount: null == currentAmount
          ? _value.currentAmount
          : currentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      milestones: null == milestones
          ? _value._milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<MilestoneModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoalModelImpl implements _GoalModel {
  const _$GoalModelImpl(
      {required this.id,
      required this.name,
      required this.targetAmount,
      required this.currentAmount,
      required this.deadline,
      required this.iconCodePoint,
      required this.colorValue,
      required this.status,
      final List<MilestoneModel> milestones = const []})
      : _milestones = milestones;

  factory _$GoalModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoalModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double targetAmount;
  @override
  final double currentAmount;
  @override
  final DateTime deadline;
  @override
  final int iconCodePoint;
  @override
  final int colorValue;
  @override
  final String status;
  final List<MilestoneModel> _milestones;
  @override
  @JsonKey()
  List<MilestoneModel> get milestones {
    if (_milestones is EqualUnmodifiableListView) return _milestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_milestones);
  }

  @override
  String toString() {
    return 'GoalModel(id: $id, name: $name, targetAmount: $targetAmount, currentAmount: $currentAmount, deadline: $deadline, iconCodePoint: $iconCodePoint, colorValue: $colorValue, status: $status, milestones: $milestones)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.currentAmount, currentAmount) ||
                other.currentAmount == currentAmount) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.iconCodePoint, iconCodePoint) ||
                other.iconCodePoint == iconCodePoint) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._milestones, _milestones));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      targetAmount,
      currentAmount,
      deadline,
      iconCodePoint,
      colorValue,
      status,
      const DeepCollectionEquality().hash(_milestones));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalModelImplCopyWith<_$GoalModelImpl> get copyWith =>
      __$$GoalModelImplCopyWithImpl<_$GoalModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoalModelImplToJson(
      this,
    );
  }
}

abstract class _GoalModel implements GoalModel {
  const factory _GoalModel(
      {required final String id,
      required final String name,
      required final double targetAmount,
      required final double currentAmount,
      required final DateTime deadline,
      required final int iconCodePoint,
      required final int colorValue,
      required final String status,
      final List<MilestoneModel> milestones}) = _$GoalModelImpl;

  factory _GoalModel.fromJson(Map<String, dynamic> json) =
      _$GoalModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get targetAmount;
  @override
  double get currentAmount;
  @override
  DateTime get deadline;
  @override
  int get iconCodePoint;
  @override
  int get colorValue;
  @override
  String get status;
  @override
  List<MilestoneModel> get milestones;
  @override
  @JsonKey(ignore: true)
  _$$GoalModelImplCopyWith<_$GoalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MilestoneModel _$MilestoneModelFromJson(Map<String, dynamic> json) {
  return _MilestoneModel.fromJson(json);
}

/// @nodoc
mixin _$MilestoneModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MilestoneModelCopyWith<MilestoneModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MilestoneModelCopyWith<$Res> {
  factory $MilestoneModelCopyWith(
          MilestoneModel value, $Res Function(MilestoneModel) then) =
      _$MilestoneModelCopyWithImpl<$Res, MilestoneModel>;
  @useResult
  $Res call({String id, String title, bool isCompleted});
}

/// @nodoc
class _$MilestoneModelCopyWithImpl<$Res, $Val extends MilestoneModel>
    implements $MilestoneModelCopyWith<$Res> {
  _$MilestoneModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MilestoneModelImplCopyWith<$Res>
    implements $MilestoneModelCopyWith<$Res> {
  factory _$$MilestoneModelImplCopyWith(_$MilestoneModelImpl value,
          $Res Function(_$MilestoneModelImpl) then) =
      __$$MilestoneModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, bool isCompleted});
}

/// @nodoc
class __$$MilestoneModelImplCopyWithImpl<$Res>
    extends _$MilestoneModelCopyWithImpl<$Res, _$MilestoneModelImpl>
    implements _$$MilestoneModelImplCopyWith<$Res> {
  __$$MilestoneModelImplCopyWithImpl(
      _$MilestoneModelImpl _value, $Res Function(_$MilestoneModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? isCompleted = null,
  }) {
    return _then(_$MilestoneModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MilestoneModelImpl implements _MilestoneModel {
  const _$MilestoneModelImpl(
      {required this.id, required this.title, this.isCompleted = false});

  factory _$MilestoneModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MilestoneModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'MilestoneModel(id: $id, title: $title, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MilestoneModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, isCompleted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MilestoneModelImplCopyWith<_$MilestoneModelImpl> get copyWith =>
      __$$MilestoneModelImplCopyWithImpl<_$MilestoneModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MilestoneModelImplToJson(
      this,
    );
  }
}

abstract class _MilestoneModel implements MilestoneModel {
  const factory _MilestoneModel(
      {required final String id,
      required final String title,
      final bool isCompleted}) = _$MilestoneModelImpl;

  factory _MilestoneModel.fromJson(Map<String, dynamic> json) =
      _$MilestoneModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  bool get isCompleted;
  @override
  @JsonKey(ignore: true)
  _$$MilestoneModelImplCopyWith<_$MilestoneModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
