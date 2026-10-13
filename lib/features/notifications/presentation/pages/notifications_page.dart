import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_time_extension.dart';
import '../../data/models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  void _open(BuildContext context, WidgetRef ref, NotificationModel n) {
    ref.read(notificationActionsProvider).markRead(n);
    if (n.opportunityId != null) {
      context.push('/opportunity/${n.opportunityId}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsProvider);
    final unread = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: AppFontWeight.bold,
          ),
        ),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () =>
                  ref.read(notificationActionsProvider).markAllRead(),
              child: const Text('Tandai semua dibaca'),
            ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Gagal memuat notifikasi')),
        data: (items) => items.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 64,
                      color: AppColors.greyLightDark,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada notifikasi',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.greyLightDarkActive,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final n = items[i];
                  final local = n.createdAt.toLocal();
                  return ListTile(
                    tileColor: n.isRead
                        ? null
                        : AppColors.blueLightHover.withValues(alpha: 0.5),
                    leading: CircleAvatar(
                      backgroundColor: n.kind == 'deadline'
                          ? AppColors.orangeNormal
                          : AppColors.blueNormal,
                      child: Icon(
                        n.kind == 'deadline'
                            ? Icons.alarm_rounded
                            : Icons.campaign_rounded,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      n.title,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: n.isRead
                            ? AppFontWeight.regular
                            : AppFontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      [
                        if (n.body.isNotEmpty) n.body,
                        '${local.day} ${local.toMonthName()} ${local.year}',
                      ].join('\n'),
                    ),
                    isThreeLine: n.body.isNotEmpty,
                    onTap: () => _open(context, ref, n),
                  );
                },
              ),
      ),
    );
  }
}
