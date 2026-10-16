import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/notification_model.dart';

class NotificationRepository {
  final SupabaseClient _client;

  const NotificationRepository(this._client);

  /// Live list of the user's notifications, newest first.
  Stream<List<NotificationModel>> watch(String userId) => _client
      .from('notifications')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .order('created_at', ascending: false)
      .limit(100)
      .map((rows) => rows.map(NotificationModel.fromJson).toList());

  PostgrestFilterBuilder get _markRead => _client.from('notifications').update({
    'read_at': DateTime.now().toUtc().toIso8601String(),
  });

  Future<void> markRead(String id) => _markRead.eq('id', id);

  Future<void> markAllRead() => _markRead
      .eq('user_id', _client.auth.currentUser!.id)
      .isFilter('read_at', null);

  Future<int> broadcast({
    required String title,
    required String body,
    String? opportunityId,
  }) async {
    final count = await _client.rpc(
      'broadcast_notification',
      params: {
        'p_title': title,
        'p_body': body,
        'p_opportunity_id': opportunityId,
      },
    );
    return count as int;
  }
}
