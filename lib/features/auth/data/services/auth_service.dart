import '../models/user_model.dart';

class AuthService {
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'mahasiswa@hunt.com' && password == 'password123') {
      return UserModel(
        email: email,
        name: 'Mamang',
        token: 'mock_jwt_token_12345',
      );
    }
    throw Exception('Invalid email or password');
  }

  Future<UserModel> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return const UserModel(
      email: 'mahasiswa.google@hunt.com',
      name: 'Miming',
      token: 'mock_google_token_67890',
    );
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return true;
  }
}
