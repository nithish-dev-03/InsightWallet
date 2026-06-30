import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _biometricEnabledKey = 'biometric_enabled';
  static const _onboardedKey = 'has_onboarded';

  final FlutterSecureStorage _storage;

  StorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  Future<void> saveToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<void> saveBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _biometricEnabledKey,
      value: enabled.toString(),
    );
  }

  Future<bool> getBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  Future<void> saveProfile(Map<String, dynamic> profile) async {
    await _storage.write(
      key: 'cached_profile',
      value: profile.toString(),
    );
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final value = await _storage.read(key: 'cached_profile');
    if (value == null) return null;
    // Profile is stored as JSON string
    return null; // Will be fetched from API each time for simplicity
  }

  Future<void> setOnboarded(String value) async {
    await _storage.write(key: _onboardedKey, value: value);
  }

  Future<String?> getOnboarded() async {
    return await _storage.read(key: _onboardedKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
