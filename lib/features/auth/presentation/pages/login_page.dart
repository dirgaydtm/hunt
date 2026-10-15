import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/auth_layout.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => AuthLayout(
    title: 'Masuk',
    form: LoginForm(),
    googleText: 'Masuk dengan Google',
    prompt: 'Belum memiliki akun?',
    action: 'Daftar',
    onAction: () => context.push('/register'),
  );
}
