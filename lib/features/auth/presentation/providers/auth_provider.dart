import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/auth_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import 'dart:async';

final authServiceProvider = Provider((ref) => AuthService());
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.watch(authServiceProvider)),
);

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() => null;

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .login(email, password);
      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authRepositoryProvider).loginWithGoogle();
      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(authRepositoryProvider)
          .register(name: name, email: email, password: password);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);
