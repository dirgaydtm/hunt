import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../../../../shared/widgets/hunt_text_field.dart';
import '../providers/auth_provider.dart';

/// Shown after the user opens a password-reset link from their email.
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final error = await ref
        .read(authProvider.notifier)
        .updatePassword(_passwordController.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Kata sandi berhasil diperbarui.'),
        backgroundColor: error == null
            ? AppColors.blueNormalActive
            : AppColors.redNormal,
      ),
    );
    if (error == null) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.greyLightLightActive,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Kata Sandi Baru',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: AppFontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const .all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                HuntTextField(
                  label: 'Kata Sandi Baru',
                  hintText: 'Masukkan kata sandi baru ...',
                  prefixIcon: Icons.vpn_key_outlined,
                  controller: _passwordController,
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Minimal 6 karakter' : null,
                ),
                SizedBox(height: 20),
                HuntTextField(
                  label: 'Konfirmasi Kata Sandi',
                  hintText: 'Ulangi kata sandi baru ...',
                  prefixIcon: Icons.vpn_key_outlined,
                  controller: _confirmController,
                  obscureText: true,
                  validator: (v) => v != _passwordController.text
                      ? 'Kata sandi tidak cocok'
                      : null,
                ),
                SizedBox(height: 32),
                HuntButton(
                  text: 'Simpan',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
