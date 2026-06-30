import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/profile_entity.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String name,
    required String email,
    String? avatar,
    @Default('USD') String currency,
    @Default('dark') String theme,
    @Default(false) bool emailVerified,
    @Default(false) bool biometricEnabled,
    required DateTime createdAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.fromEntity(ProfileEntity entity) => ProfileModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        avatar: entity.avatar,
        currency: entity.currency,
        theme: entity.theme,
        emailVerified: entity.emailVerified,
        biometricEnabled: entity.biometricEnabled,
        createdAt: entity.createdAt,
      );
}

extension ProfileModelX on ProfileModel {
  ProfileEntity toEntity() => ProfileEntity(
        id: id,
        name: name,
        email: email,
        avatar: avatar,
        currency: currency,
        theme: theme,
        emailVerified: emailVerified,
        biometricEnabled: biometricEnabled,
        createdAt: createdAt,
      );
}
