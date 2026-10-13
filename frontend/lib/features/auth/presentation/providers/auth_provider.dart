import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../domain/models/user_model.dart';
import '../../../../core/network/error_handler.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

enum AuthState { initial, unauthenticated, authenticated, loading, error }

class AuthStateData {
  final AuthState status;
  final UserModel? user;
  final String? errorMessage;

  AuthStateData({required this.status, this.user, this.errorMessage});
}

class AuthNotifier extends StateNotifier<AuthStateData> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthStateData(status: AuthState.initial)) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = AuthStateData(status: AuthState.loading);
    try {
      if (await _repository.hasValidToken()) {
        final user = await _repository.getCurrentUser();
        if (user != null) {
          state = AuthStateData(status: AuthState.authenticated, user: user);
          return;
        }
      }
    } catch (_) {
      // Network error during startup — don't lock user out,
      // just show unauthenticated so they can try logging in.
    }
    state = AuthStateData(status: AuthState.unauthenticated);
  }

  Future<void> login(String email, String password) async {
    state = AuthStateData(status: AuthState.loading);
    try {
      final userResponse = await _repository.login(email.trim(), password);
      final user = userResponse ?? await _repository.getCurrentUser();
      if (!mounted) return;
      state = AuthStateData(status: AuthState.authenticated, user: user);
    } catch (e) {
      if (!mounted) return;
      state = AuthStateData(status: AuthState.error, errorMessage: friendlyError(e));
    }
  }

  Future<void> register(String email, String password, String firstName, String lastName) async {
    state = AuthStateData(status: AuthState.loading);
    try {
      final userResponse = await _repository.register(email.trim(), password, firstName.trim(), lastName.trim());
      final user = userResponse ?? await _repository.getCurrentUser();
      if (!mounted) return;
      state = AuthStateData(status: AuthState.authenticated, user: user);
    } catch (e) {
      if (!mounted) return;
      state = AuthStateData(status: AuthState.error, errorMessage: friendlyError(e));
    }
  }

  Future<void> logout() async {
    state = AuthStateData(status: AuthState.loading);
    await _repository.logout();
    state = AuthStateData(status: AuthState.unauthenticated);
  }

  /// Call this when entering the login/register screen to wipe any stale error
  /// from a previous attempt (e.g. user went back and came back).
  void resetForScreen() {
    if (state.status == AuthState.error || state.status == AuthState.loading) {
      state = AuthStateData(status: AuthState.unauthenticated);
    }
  }

  /// Clear error state — always resets to unauthenticated regardless of current status.
  void clearError() {
    if (state.status == AuthState.error) {
      state = AuthStateData(status: AuthState.unauthenticated);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthStateData>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
