import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

/// Deep link the Supabase dashboard must allow as a redirect URL.
const authRedirectUrl = 'io.supabase.hunt://login-callback';

class AuthService {
  final SupabaseClient _client;

  const AuthService(this._client);

  String? get _redirect => kIsWeb ? null : authRedirectUrl;

  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> login(String email, String password) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Opens the Google consent screen. The session arrives later through
  /// [authStateChanges] once the deep link brings the user back.
  Future<void> loginWithGoogle() {
    return _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: _redirect,
    );
  }

  /// Returns true when the user is signed in immediately, false when
  /// email confirmation is required first.
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
      emailRedirectTo: _redirect,
    );
    return res.session != null;
  }

  Future<void> logout() => _client.auth.signOut();

  Future<UserModel?> fetchProfile(String userId) async {
    final row = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (row == null) return null;
    final avatarPath = row['avatar_path'] as String?;
    return UserModel.fromJson(
      row,
      avatarUrl: avatarPath == null
          ? null
          : _client.storage.from('avatars').getPublicUrl(avatarPath),
    );
  }
}
