import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiService _api;
  final StorageService _storage;

  ProfileRepositoryImpl(this._api, this._storage);

  @override
  Future<ProfileEntity> getProfile() async {
    final response = await _api.get(ApiConfig.profile);
    final data = response.data['data'] as Map<String, dynamic>;
    final model = ProfileModel.fromJson(data);
    return model.toEntity();
  }

  @override
  Future<ProfileEntity?> getProfileByEmail(String email) async {
    try {
      final response = await _api.get(ApiConfig.profileByEmail(email));
      final data = response.data['data'] as Map<String, dynamic>;
      final model = ProfileModel.fromJson(data);
      return model.toEntity();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<ProfileEntity> createProfile(ProfileEntity profile) async {
    final response = await _api.post(
      ApiConfig.profile,
      data: {
        'name': profile.name,
        'title': profile.title,
        'bio': profile.bio,
        'location': profile.location,
        'currency': profile.currency,
        'theme': profile.theme,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final model = ProfileModel.fromJson(data);
    return model.toEntity();
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
    final response = await _api.put(
      ApiConfig.profile,
      data: ProfileModel.fromEntity(profile).toJson(),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    final model = ProfileModel.fromJson(data);
    return model.toEntity();
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath),
    });
    final response = await _api.post(ApiConfig.profileAvatar, data: formData);
    return response.data['data']['url'] as String;
  }

  @override
  Future<void> toggleBiometric(bool enabled) async {
    await _api.patch(ApiConfig.profileBiometric, data: {'enabled': enabled});
    await _storage.saveBiometricEnabled(enabled);
  }

  @override
  Future<void> logout() async {
    try {
      await _api.post(ApiConfig.logout);
    } catch (_) {}
    await _storage.clearAll();
  }
}
