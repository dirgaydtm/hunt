import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/data/models/user_model.dart';

class AdminUserRepository {
  final SupabaseClient _client;

  const AdminUserRepository(this._client);

  /// RLS only returns every profile to admins.
  Future<List<UserModel>> getAll() async {
    final rows = await _client
        .from('profiles')
        .select()
        .order('created_at', ascending: true);
    return rows.map((r) {
      final avatar = r['avatar_path'] as String?;
      return UserModel.fromJson(
        r,
        avatarUrl: avatar == null
            ? null
            : _client.storage.from('avatars').getPublicUrl(avatar),
      );
    }).toList();
  }

  Future<void> setAdmin(String userId, bool isAdmin) => _client
      .from('profiles')
      .update({'role': isAdmin ? 'admin' : 'user'})
      .eq('id', userId);
}
