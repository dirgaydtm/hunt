import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/supabase/supabase_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/services/notification_service.dart';

final notificationServiceProvider = Provider(
  (ref) => NotificationService(ref.watch(supabaseClientProvider)),
);

final notificationRepositoryProvider = Provider(
  (ref) => NotificationRepository(ref.watch(notificationServiceProvider)),
);

final _userIdProvider = Provider<String?>(
  (ref) => ref.watch(authProvider.select((a) => a.value?.id)),
);

final notificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  final userId = ref.watch(_userIdProvider);
  if (userId == null) return Stream.value(const []);
  return ref.watch(notificationRepositoryProvider).watch(userId);
});

final unreadNotificationCountProvider = Provider<int>(
  (ref) =>
      ref.watch(notificationsProvider).value?.where((n) => !n.isRead).length ??
      0,
);

final notificationActionsProvider = Provider(NotificationActions.new);

class NotificationActions {
  final Ref _ref;

  NotificationActions(this._ref);

  NotificationRepository get _repo => _ref.read(notificationRepositoryProvider);

  Future<void> markRead(NotificationModel n) async {
    if (!n.isRead) await _repo.markRead(n.id);
  }

  Future<void> markAllRead() async {
    final userId = _ref.read(_userIdProvider);
    if (userId != null) await _repo.markAllRead(userId);
  }
}
