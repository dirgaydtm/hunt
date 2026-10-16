import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider(
  (ref) => NotificationRepository(ref.watch(supabaseClientProvider)),
);

final notificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  final userId = ref.watch(authProvider.select((a) => a.value?.id));
  if (userId == null) return Stream.value(const []);
  return ref.watch(notificationRepositoryProvider).watch(userId);
});

final unreadNotificationCountProvider = Provider<int>(
  (ref) =>
      ref.watch(notificationsProvider).value?.where((n) => !n.isRead).length ??
      0,
);
