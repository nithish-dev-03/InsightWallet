import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    @Default('') String name,
    required String email,
    String? avatar,
    @Default('USD') String currency,
    @Default('dark') String theme,
    @Default(false) bool emailVerified,
  }) = _UserEntity;
}
