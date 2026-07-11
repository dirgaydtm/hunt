import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/hunt_text_field.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../providers/auth_provider.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(authProvider.notifier)
          .register(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registrasi Berhasil! Silakan masuk dengan akun baru Anda.',
            ),
            backgroundColor: AppColors.blueNormalActive,
          ),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Container(
      padding: const .symmetric(horizontal: 30, vertical: 20),
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
              label: 'Nama Lengkap',
              hintText: 'Masukkan nama lengkap ...',
              prefixIcon: Icons.person_outline_rounded,
              controller: _nameController,
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Nama tidak boleh kosong'
                  : null,
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            HuntTextField(
              label: 'Konfirmasi Kata Sandi',
              hintText: 'Konfirmasi kata sandi ...',
              prefixIcon: Icons.vpn_key_outlined,
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.greyLightDark,
                ),
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
              ),
              validator: (v) => v != _passwordController.text
                  ? 'Kata sandi tidak cocok'
                  : null,
            ),
            SizedBox(height: 32),
            Padding(
              padding: .symmetric(horizontal: 21),
              child: HuntButton(
                text: 'Daftar Sekarang',
                isLoading: isLoading,
                onPressed: _handleRegister,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
