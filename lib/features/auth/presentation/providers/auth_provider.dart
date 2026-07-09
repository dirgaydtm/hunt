import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/auth_service.dart';
import '../../data/repositories/auth_repository.dart';

final authServiceProvider = Provider((ref) => AuthService());
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.watch(authServiceProvider)),
);

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  Future<bool> login(String email, String password) async {
    state = true;
    try {
      await ref.read(authRepositoryProvider).login(email, password);
      state = false;
      return true;
    } catch (_) {
      state = false;
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    state = true;
    try {
      await ref.read(authRepositoryProvider).loginWithGoogle();
      state = false;
      return true;
    } catch (_) {
      state = false;
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = true;
    try {
      await ref
          .read(authRepositoryProvider)
          .register(name: name, email: email, password: password);
      state = false;
      return true;
    } catch (_) {
      state = false;
      return false;
    }
  }

  void logout() => state = false;
}

final authProvider = NotifierProvider<AuthNotifier, bool>(AuthNotifier.new);
