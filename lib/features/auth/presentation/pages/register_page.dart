import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/auth_layout.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) => AuthLayout(
    title: 'Daftar',
    form: RegisterForm(),
    googleText: 'Daftar dengan Google',
    prompt: 'Sudah memiliki akun?',
    action: 'Masuk',
    onAction: context.pop,
    headerFraction: .42,
  );
}
