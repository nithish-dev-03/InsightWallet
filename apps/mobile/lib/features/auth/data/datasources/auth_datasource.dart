import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/services/api_service.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';

class AuthDataSource {
  final ApiService _api;

  AuthDataSource(this._api);

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _api.post(
      ApiConfig.login,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data['data']);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _api.post(
      ApiConfig.register,
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data['data']);
  }

  Future<void> logout() async {
    try {
      await _api.post(ApiConfig.logout);
    } on DioException {
      // Ignore server errors on logout
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _api.post(
      ApiConfig.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    return AuthResponse.fromJson(response.data['data']);
  }

  Future<void> forgotPassword(String email) async {
    await _api.post(
      ApiConfig.forgotPassword,
      data: {'email': email},
    );
  }

  Future<void> resetPassword(String token, String password) async {
    await _api.post(
      ApiConfig.resetPassword,
      data: {'token': token, 'password': password},
    );
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _api.get(ApiConfig.profile);
    return response.data['data'];
  }
}
