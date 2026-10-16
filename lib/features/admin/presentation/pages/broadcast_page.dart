import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/hunt_button.dart';
import '../../../../core/widgets/hunt_text_field.dart';
import '../providers/admin_provider.dart';

/// Sends an in-app announcement to every user.
class BroadcastPage extends ConsumerStatefulWidget {
  const BroadcastPage({super.key});

  @override
  ConsumerState<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends ConsumerState<BroadcastPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  String? _opportunityId;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final error = await ref
        .read(adminControllerProvider.notifier)
        .broadcast(
          title: _title.text.trim(),
          body: _body.text.trim(),
          opportunityId: _opportunityId,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Notifikasi terkirim ke semua pengguna.'),
        backgroundColor: error == null
            ? AppColors.blueNormalActive
            : AppColors.redNormal,
      ),
    );
    if (error == null) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final sending = ref.watch(adminControllerProvider);
    final opportunities = ref.watch(adminOpportunitiesProvider).value ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Broadcast Notifikasi',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: AppFontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const .all(24),
            children: [
              HuntTextField(
                label: 'Judul',
                hintText: 'Contoh: Beasiswa baru dibuka!',
                controller: _title,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _body,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Isi pesan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                initialValue: _opportunityId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Tautkan ke peluang (opsional)',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Tidak ada')),
                  for (final o in opportunities)
                    DropdownMenuItem(
                      value: o.id,
                      child: Text(o.title, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (v) => setState(() => _opportunityId = v),
              ),
              const SizedBox(height: 32),
              HuntButton(text: 'Kirim', isLoading: sending, onPressed: _send),
            ],
          ),
        ),
      ),
    );
  }
}
