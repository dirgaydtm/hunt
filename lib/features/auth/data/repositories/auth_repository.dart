import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  const AuthRepository(this._authService);

  Session? get currentSession => _authService.currentSession;

  Stream<AuthState> get authStateChanges => _authService.authStateChanges;

  Future<void> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<void> loginWithGoogle() => _authService.loginWithGoogle();

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _authService.register(name: name, email: email, password: password);
  }

  Future<void> logout() => _authService.logout();

  Future<UserModel?> fetchProfile(String userId) {
    return _authService.fetchProfile(userId);
  }
}
