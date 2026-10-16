import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/hunt_text_field.dart';
import '../providers/auth_provider.dart';
import 'auth_fields.dart';

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
      final result = await ref
          .read(authProvider.notifier)
          .register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      if (!mounted) return;
      if (result.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error!),
            backgroundColor: AppColors.redNormal,
          ),
        );
      } else if (result.needsConfirmation) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registrasi berhasil! Cek email kamu untuk konfirmasi akun.',
            ),
            backgroundColor: AppColors.blueNormalActive,
          ),
        );
        context.pop();
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) => AuthCard(
    formKey: _formKey,
    submitText: 'Daftar Sekarang',
    isLoading: ref.watch(authProvider).isLoading,
    onSubmit: _handleRegister,
    fields: [
      HuntTextField(
        label: 'Nama Lengkap',
        hintText: 'Masukkan nama lengkap ...',
        prefixIcon: Icons.person_outline_rounded,
        controller: _nameController,
        validator: (v) =>
            v == null || v.trim().isEmpty ? 'Nama tidak boleh kosong' : null,
      ),
      EmailField(controller: _emailController),
      PasswordField(controller: _passwordController),
      PasswordField(
        controller: _confirmPasswordController,
        label: 'Konfirmasi Kata Sandi',
        hintText: 'Konfirmasi kata sandi ...',
        validator: (v) =>
            v != _passwordController.text ? 'Kata sandi tidak cocok' : null,
      ),
    ],
  );
}
