import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/supabase/supabase_provider.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/auth_service.dart';

final authServiceProvider = Provider(
  (ref) => AuthService(ref.watch(supabaseClientProvider)),
);
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.watch(authServiceProvider)),
);

/// Holds the signed-in user's profile. `null` means signed out.
///
/// Action methods return `null` on success or a user-facing error message.
class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() {
    final repo = ref.watch(authRepositoryProvider);
    final sub = repo.authStateChanges.listen((data) {
      if (data.event == AuthChangeEvent.signedIn ||
          data.event == AuthChangeEvent.signedOut ||
          data.event == AuthChangeEvent.userUpdated) {
        _reload(data.session);
      }
    });
    ref.onDispose(sub.cancel);
    return _loadProfile(repo.currentSession);
  }

  Future<UserModel?> _loadProfile(Session? session) async {
    if (session == null) return null;
    return ref.read(authRepositoryProvider).fetchProfile(session.user.id);
  }

  Future<void> _reload(Session? session) async {
    state = await AsyncValue.guard(() => _loadProfile(session));
  }

  /// Re-fetches the profile, e.g. after editing it.
  Future<void> refresh() =>
      _reload(ref.read(authRepositoryProvider).currentSession);

  Future<String?> _run(Future<void> Function() action) async {
    final previous = state;
    state = AsyncLoading<UserModel?>();
    try {
      await action();
      // Successful sign-in is picked up by the auth listener.
      if (state.isLoading) state = previous;
      return null;
    } catch (e) {
      state = previous;
      return failureMessage(e);
    }
  }

  Future<String?> login(String email, String password) =>
      _run(() => ref.read(authRepositoryProvider).login(email, password));

  Future<String?> loginWithGoogle() =>
      _run(() => ref.read(authRepositoryProvider).loginWithGoogle());

  /// On success, [needsConfirmation] tells whether the user must confirm
  /// their email before they can sign in.
  Future<({String? error, bool needsConfirmation})> register({
    required String name,
    required String email,
    required String password,
  }) async {
    var signedIn = false;
    final error = await _run(() async {
      signedIn = await ref
          .read(authRepositoryProvider)
          .register(name: name, email: email, password: password);
    });
    return (error: error, needsConfirmation: error == null && !signedIn);
  }

  Future<void> logout() => ref.read(authRepositoryProvider).logout();
}

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);
