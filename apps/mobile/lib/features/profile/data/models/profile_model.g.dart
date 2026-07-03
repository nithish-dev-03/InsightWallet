// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileModelImpl _$$ProfileModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfileModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      currency: json['currency'] as String? ?? 'USD',
      theme: json['theme'] as String? ?? 'dark',
      emailVerified: json['emailVerified'] as bool? ?? false,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      title: json['title'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      location: json['location'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ProfileModelImplToJson(_$ProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
      'currency': instance.currency,
      'theme': instance.theme,
      'emailVerified': instance.emailVerified,
      'biometricEnabled': instance.biometricEnabled,
      'title': instance.title,
      'bio': instance.bio,
      'location': instance.location,
      'createdAt': instance.createdAt.toIso8601String(),
    };
