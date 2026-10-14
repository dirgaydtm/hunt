import 'package:supabase_flutter/supabase_flutter.dart';

class AdminUserService {
  final SupabaseClient _client;

  const AdminUserService(this._client);

  /// RLS only returns every profile to admins.
  Future<List<Map<String, dynamic>>> getAll() =>
      _client.from('profiles').select().order('created_at');

  Future<void> setRole(String userId, String role) =>
      _client.from('profiles').update({'role': role}).eq('id', userId);

  String avatarUrl(String path) =>
      _client.storage.from('avatars').getPublicUrl(path);
}
