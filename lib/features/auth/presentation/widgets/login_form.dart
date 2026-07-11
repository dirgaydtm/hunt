import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/hunt_text_field.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../providers/auth_provider.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(authProvider.notifier)
          .login(_emailController.text, _passwordController.text);
      if (success && mounted) {
        context.go('/home');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Login gagal. Gunakan: mahasiswa@hunt.com / password123',
            ),
            backgroundColor: AppColors.redNormal,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Container(
      padding: const .all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(28),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F00A9B8),
            blurRadius: 32,
            offset: Offset(0, 0),
            spreadRadius: 3,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: 18),
            HuntTextField(
              label: 'Email',
              hintText: 'Masukkan email ...',
              prefixIcon: Icons.email_outlined,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v == null || !v.contains('@') ? 'Email tidak valid' : null,
            ),
            SizedBox(height: 20),
            HuntTextField(
              label: 'Kata Sandi',
              hintText: 'Masukkan kata sandi ...',
              prefixIcon: Icons.vpn_key_outlined,
              controller: _passwordController,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.greyLightDark,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) =>
                  v == null || v.length < 6 ? 'Minimal 6 karakter' : null,
            ),
            SizedBox(height: 32),
            Padding(
              padding: .symmetric(horizontal: 21),
              child: HuntButton(
                text: 'Masuk Sekarang',
                isLoading: isLoading,
                onPressed: _handleLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
