import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/notification_provider.dart';

/// Bell icon with an unread badge; opens the notifications page.
class NotificationBell extends ConsumerWidget {
  final IconData icon;
  final EdgeInsetsGeometry? padding;

  const NotificationBell({
    super.key,
    this.icon = Icons.notifications,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationCountProvider);
    return IconButton(
      padding: padding,
      icon: Badge(
        isLabelVisible: unread > 0,
        backgroundColor: AppColors.redNormal,
        label: Text(unread > 9 ? '9+' : '$unread'),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
      onPressed: () => context.push('/notifications'),
    );
  }
}
