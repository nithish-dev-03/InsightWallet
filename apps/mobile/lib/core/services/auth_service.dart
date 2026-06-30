import 'package:dio/dio.dart';

import '../config/api_config.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _api;
  final StorageService _storage;

  AuthService(this._api, this._storage);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _api.post(
        ApiConfig.login,
        data: {'email': email, 'password': password},
      );

      final data = response.data['data'];
      await _storage.saveToken(data['accessToken']);
      await _storage.saveRefreshToken(data['refreshToken']);

      return data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _api.post(
        ApiConfig.register,
        data: {'name': name, 'email': email, 'password': password},
      );

      final data = response.data['data'];
      await _storage.saveToken(data['accessToken']);
      await _storage.saveRefreshToken(data['refreshToken']);

      return data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _api.post(ApiConfig.logout);
    } on DioException {
      // Ignore server errors on logout
    } finally {
      await _storage.clearAll();
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    try {
      final response = await _api.post(
        ApiConfig.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data['data'];
      await _storage.saveToken(data['accessToken']);
      await _storage.saveRefreshToken(data['refreshToken']);

      return data;
    } on DioException catch (e) {
      await _storage.clearAll();
      throw _handleError(e);
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _api.get(ApiConfig.profile);
      return response.data['data'];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _api.post(
        ApiConfig.forgotPassword,
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> resetPassword(String token, String password) async {
    try {
      await _api.post(
        ApiConfig.resetPassword,
        data: {'token': token, 'password': password},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    final message = e.response?.data is Map
        ? e.response?.data['message'] ?? e.message
        : e.message;
    return Exception(message ?? 'An unexpected error occurred');
  }
}
