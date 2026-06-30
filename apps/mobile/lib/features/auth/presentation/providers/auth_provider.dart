import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.error(String message) = _Error;
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = StorageService();
  final api = ApiService(storage);
  final dataSource = AuthDataSource(api);
  return AuthRepositoryImpl(dataSource, storage);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState.unauthenticated());

  Future<void> checkAuth() async {
    state = const AuthState.loading();
    try {
      final isAuth = await _repository.isAuthenticated();
      if (isAuth) {
        final user = await _repository.getCurrentUser();
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _repository.login(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _repository.register(name, email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await _repository.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> refresh() async {
    try {
      final user = await _repository.refreshToken();
      state = AuthState.authenticated(user);
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }
}
