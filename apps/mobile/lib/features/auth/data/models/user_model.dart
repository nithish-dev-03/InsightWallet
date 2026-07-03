import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    @Default('') String name,
    required String email,
    String? avatar,
    @Default('USD') String currency,
    @Default('dark') String theme,
    @Default(false) bool emailVerified,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var avatarJson = json['avatar'];
    String? avatarUrl;
    if (avatarJson is Map) {
      avatarUrl = avatarJson['url'] as String?;
    } else if (avatarJson is String) {
      avatarUrl = avatarJson;
    }
    final updatedJson = Map<String, dynamic>.from(json);
    updatedJson['avatar'] = avatarUrl;
    return _$UserModelFromJson(updatedJson);
  }

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        avatar: entity.avatar,
        currency: entity.currency,
        theme: entity.theme,
        emailVerified: entity.emailVerified,
      );
}

extension UserModelX on UserModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
        avatar: avatar,
        currency: currency,
        theme: theme,
        emailVerified: emailVerified,
      );
}
