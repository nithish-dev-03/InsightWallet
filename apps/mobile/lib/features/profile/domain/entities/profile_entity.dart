import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_entity.freezed.dart';

@freezed
class ProfileEntity with _$ProfileEntity {
  const factory ProfileEntity({
    required String id,
    required String name,
    required String email,
    String? avatar,
    @Default('USD') String currency,
    @Default('dark') String theme,
    @Default(false) bool emailVerified,
    @Default(false) bool biometricEnabled,
    required DateTime createdAt,
  }) = _ProfileEntity;

  const ProfileEntity._();
}
