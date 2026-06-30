import '../../../../core/services/storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;
  final StorageService _storage;

  AuthRepositoryImpl(this._dataSource, this._storage);

  @override
  Future<UserEntity> login(String email, String password) async {
    final request = LoginRequest(email: email, password: password);
    final response = await _dataSource.login(request);
    await _saveTokens(response);
    return response.user.toEntity();
  }

  @override
  Future<UserEntity> register(
      String name, String email, String password) async {
    final request = RegisterRequest(name: name, email: email, password: password);
    final response = await _dataSource.register(request);
    await _saveTokens(response);
    return response.user.toEntity();
  }

  @override
  Future<void> logout() async {
    await _dataSource.logout();
    await _storage.clearAll();
  }

  @override
  Future<UserEntity> refreshToken() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token available');
    final response = await _dataSource.refreshToken(refreshToken);
    await _saveTokens(response);
    return response.user.toEntity();
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _dataSource.forgotPassword(email);
  }

  @override
  Future<void> resetPassword(String token, String password) async {
    await _dataSource.resetPassword(token, password);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final data = await _dataSource.getCurrentUser();
    return UserEntity(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatar: data['avatar'],
      currency: data['currency'] ?? 'USD',
      theme: data['theme'] ?? 'dark',
      emailVerified: data['emailVerified'] ?? false,
    );
  }

  Future<void> _saveTokens(AuthResponse response) async {
    await _storage.saveToken(response.accessToken);
    await _storage.saveRefreshToken(response.refreshToken);
  }
}
