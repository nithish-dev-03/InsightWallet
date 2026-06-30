// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionFilter {
  String? get type => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  DateTime? get dateFrom => throw _privateConstructorUsedError;
  DateTime? get dateTo => throw _privateConstructorUsedError;
  String get sortBy => throw _privateConstructorUsedError;
  String get sortOrder => throw _privateConstructorUsedError;
  String? get search => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TransactionFilterCopyWith<TransactionFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionFilterCopyWith<$Res> {
  factory $TransactionFilterCopyWith(
          TransactionFilter value, $Res Function(TransactionFilter) then) =
      _$TransactionFilterCopyWithImpl<$Res, TransactionFilter>;
  @useResult
  $Res call(
      {String? type,
      String? category,
      DateTime? dateFrom,
      DateTime? dateTo,
      String sortBy,
      String sortOrder,
      String? search,
      int page,
      int limit});
}

/// @nodoc
class _$TransactionFilterCopyWithImpl<$Res, $Val extends TransactionFilter>
    implements $TransactionFilterCopyWith<$Res> {
  _$TransactionFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? category = freezed,
    Object? dateFrom = freezed,
    Object? dateTo = freezed,
    Object? sortBy = null,
    Object? sortOrder = null,
    Object? search = freezed,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      dateFrom: freezed == dateFrom
          ? _value.dateFrom
          : dateFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateTo: freezed == dateTo
          ? _value.dateTo
          : dateTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String,
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionFilterImplCopyWith<$Res>
    implements $TransactionFilterCopyWith<$Res> {
  factory _$$TransactionFilterImplCopyWith(_$TransactionFilterImpl value,
          $Res Function(_$TransactionFilterImpl) then) =
      __$$TransactionFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? type,
      String? category,
      DateTime? dateFrom,
      DateTime? dateTo,
      String sortBy,
      String sortOrder,
      String? search,
      int page,
      int limit});
}

/// @nodoc
class __$$TransactionFilterImplCopyWithImpl<$Res>
    extends _$TransactionFilterCopyWithImpl<$Res, _$TransactionFilterImpl>
    implements _$$TransactionFilterImplCopyWith<$Res> {
  __$$TransactionFilterImplCopyWithImpl(_$TransactionFilterImpl _value,
      $Res Function(_$TransactionFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? category = freezed,
    Object? dateFrom = freezed,
    Object? dateTo = freezed,
    Object? sortBy = null,
    Object? sortOrder = null,
    Object? search = freezed,
    Object? page = null,
    Object? limit = null,
  }) {
    return _then(_$TransactionFilterImpl(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      dateFrom: freezed == dateFrom
          ? _value.dateFrom
          : dateFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateTo: freezed == dateTo
          ? _value.dateTo
          : dateTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as String,
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TransactionFilterImpl implements _TransactionFilter {
  const _$TransactionFilterImpl(
      {this.type,
      this.category,
      this.dateFrom,
      this.dateTo,
      this.sortBy = 'date',
      this.sortOrder = 'desc',
      this.search,
      this.page = 1,
      this.limit = 20});

  @override
  final String? type;
  @override
  final String? category;
  @override
  final DateTime? dateFrom;
  @override
  final DateTime? dateTo;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final String sortOrder;
  @override
  final String? search;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;

  @override
  String toString() {
    return 'TransactionFilter(type: $type, category: $category, dateFrom: $dateFrom, dateTo: $dateTo, sortBy: $sortBy, sortOrder: $sortOrder, search: $search, page: $page, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionFilterImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.dateFrom, dateFrom) ||
                other.dateFrom == dateFrom) &&
            (identical(other.dateTo, dateTo) || other.dateTo == dateTo) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, category, dateFrom, dateTo,
      sortBy, sortOrder, search, page, limit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionFilterImplCopyWith<_$TransactionFilterImpl> get copyWith =>
      __$$TransactionFilterImplCopyWithImpl<_$TransactionFilterImpl>(
          this, _$identity);
}

abstract class _TransactionFilter implements TransactionFilter {
  const factory _TransactionFilter(
      {final String? type,
      final String? category,
      final DateTime? dateFrom,
      final DateTime? dateTo,
      final String sortBy,
      final String sortOrder,
      final String? search,
      final int page,
      final int limit}) = _$TransactionFilterImpl;

  @override
  String? get type;
  @override
  String? get category;
  @override
  DateTime? get dateFrom;
  @override
  DateTime? get dateTo;
  @override
  String get sortBy;
  @override
  String get sortOrder;
  @override
  String? get search;
  @override
  int get page;
  @override
  int get limit;
  @override
  @JsonKey(ignore: true)
  _$$TransactionFilterImplCopyWith<_$TransactionFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
