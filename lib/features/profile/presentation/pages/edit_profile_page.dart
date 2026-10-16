import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/hunt_button.dart';
import '../../../../core/widgets/hunt_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _university;
  late final TextEditingController _major;
  late final TextEditingController _graduationYear;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).value;
    _name = TextEditingController(text: user?.name);
    _university = TextEditingController(text: user?.university);
    _major = TextEditingController(text: user?.major);
    _graduationYear = TextEditingController(
      text: user?.graduationYear?.toString(),
    );
  }

  @override
  void dispose() {
    for (final c in [_name, _university, _major, _graduationYear]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _nullIfEmpty(String v) => v.trim().isEmpty ? null : v.trim();

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final error = await ref
        .read(profileControllerProvider.notifier)
        .updateProfile(
          name: _name.text.trim(),
          university: _nullIfEmpty(_university.text),
          major: _nullIfEmpty(_major.text),
          graduationYear: int.tryParse(_graduationYear.text.trim()),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Profil berhasil diperbarui.'),
        backgroundColor: error == null
            ? AppColors.blueNormalActive
            : AppColors.redNormal,
      ),
    );
    if (error == null) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
              spacing: 20,
              children: [
                HuntTextField(
                  label: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap ...',
                  prefixIcon: Icons.person_outline_rounded,
                  controller: _name,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nama tidak boleh kosong'
                      : null,
                ),
                // Student details don't apply to admins.
                if (!(ref.watch(authProvider).value?.isAdmin ?? false)) ...[
                  HuntTextField(
                    label: 'Universitas',
                    hintText: 'Contoh: Universitas Brawijaya',
                    prefixIcon: Icons.account_balance,
                    controller: _university,
                  ),
                  HuntTextField(
                    label: 'Jurusan',
                    hintText: 'Contoh: Sistem Informasi',
                    prefixIcon: Icons.work_outline,
                    controller: _major,
                  ),
                  HuntTextField(
                    label: 'Tahun Lulus',
                    hintText: 'Contoh: 2027',
                    prefixIcon: Icons.calendar_today_outlined,
                    controller: _graduationYear,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final year = int.tryParse(v.trim());
                      return year == null || year < 1950 || year > 2100
                          ? 'Tahun tidak valid'
                          : null;
                    },
                  ),
                ],
                const SizedBox(height: 12),
                HuntButton(text: 'Simpan', isLoading: saving, onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
