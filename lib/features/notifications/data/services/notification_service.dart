import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final SupabaseClient _client;

  const NotificationService(this._client);

  /// Live list of the user's notifications, newest first.
  Stream<List<Map<String, dynamic>>> watch(String userId) => _client
      .from('notifications')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .order('created_at')
      .limit(100);

  Future<void> markRead(String id) => _client
      .from('notifications')
      .update({'read_at': DateTime.now().toUtc().toIso8601String()})
      .eq('id', id);

  Future<void> markAllRead(String userId) => _client
      .from('notifications')
      .update({'read_at': DateTime.now().toUtc().toIso8601String()})
      .eq('user_id', userId)
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
