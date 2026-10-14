import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/admin_provider.dart';

class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  String _query = '';

  bool _matches(UserModel u) {
    final q = _query.toLowerCase();
    return q.isEmpty ||
        u.name.toLowerCase().contains(q) ||
        u.email.toLowerCase().contains(q);
  }

  Future<void> _setAdmin(UserModel user, bool isAdmin) async {
    final error = await ref
        .read(adminControllerProvider.notifier)
        .setAdmin(user.id, isAdmin);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ??
              (isAdmin
                  ? '${user.name} sekarang admin.'
                  : '${user.name} bukan admin lagi.'),
        ),
        backgroundColor: error == null
            ? AppColors.blueNormalActive
            : AppColors.redNormal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(adminUsersProvider);
    final me = ref.watch(authProvider).value?.id;
    final busy = ref.watch(adminControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Kelola Pengguna',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: AppFontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const .fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari nama atau email ...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  const Center(child: Text('Gagal memuat pengguna')),
              data: (all) {
                final users = all.where(_matches).toList();
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(adminUsersProvider.future),
                  child: ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final u = users[i];
                      final isMe = u.id == me;
                      return SwitchListTile(
                        secondary: CircleAvatar(
                          backgroundColor: AppColors.blueLightActive,
                          backgroundImage: u.avatarUrl == null
                              ? null
                              : NetworkImage(u.avatarUrl!),
                          child: u.avatarUrl == null
                              ? const Icon(
                                  Icons.person,
                                  color: AppColors.blueDark,
                                )
                              : null,
                        ),
                        title: Text(isMe ? '${u.name} (kamu)' : u.name),
                        subtitle: Text(
                          [
                            u.email,
                            if (u.university != null) u.university!,
                          ].join('\n'),
                        ),
                        isThreeLine: u.university != null,
                        value: u.isAdmin,
                        // Admins can't demote themselves and lock themselves out.
                        onChanged: busy || isMe ? null : (v) => _setAdmin(u, v),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
