import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../../../../shared/widgets/hunt_text_field.dart';

/// White rounded card with a [Form], the [fields] and a submit button.
class AuthCard extends StatelessWidget {
  const AuthCard({
    super.key,
    required this.formKey,
    required this.fields,
    required this.submitText,
    required this.isLoading,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final String submitText;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) => Container(
    padding: .fromLTRB(20, 20, 20, 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: .circular(28),
      boxShadow: [
        BoxShadow(color: Color(0x3F00A9B8), blurRadius: 32, spreadRadius: 3),
      ],
    ),
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: .start,
        spacing: 12,
        children: [
          ...fields,
          Padding(
            padding: .fromLTRB(21, 8, 21, 0),
            child: HuntButton(
              text: submitText,
              isLoading: isLoading,
              onPressed: onSubmit,
            ),
          ),
        ],
      ),
    ),
  );
}

class EmailField extends StatelessWidget {
  const EmailField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => HuntTextField(
    label: 'Email',
    hintText: 'Masukkan email ...',
    prefixIcon: Icons.email_outlined,
    controller: controller,
    keyboardType: .emailAddress,
    validator: (v) =>
        v == null || !v.contains('@') ? 'Email tidak valid' : null,
  );
}

/// Password field with its own show/hide toggle.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.label = 'Kata Sandi',
    this.hintText = 'Masukkan kata sandi ...',
    this.validator,
  });

  final TextEditingController controller;
  final String label, hintText;
  final String? Function(String?)? validator;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) => HuntTextField(
    label: widget.label,
    hintText: widget.hintText,
    prefixIcon: Icons.vpn_key_outlined,
    controller: widget.controller,
    obscureText: _obscure,
    suffixIcon: IconButton(
      icon: Icon(
        _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: AppColors.greyLightDark,
      ),
      onPressed: () => setState(() => _obscure = !_obscure),
    ),
    validator:
        widget.validator ??
        (v) => v == null || v.length < 6 ? 'Minimal 6 karakter' : null,
  );
}
