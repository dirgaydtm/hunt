import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  const AuthRepository(this._authService);

  Future<UserModel> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<UserModel> loginWithGoogle() {
    return _authService.loginWithGoogle();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _authService.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
