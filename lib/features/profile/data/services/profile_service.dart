import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client;

  const ProfileService(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<void> update(Map<String, dynamic> data) =>
      _client.from('profiles').update(data).eq('id', _userId);

  /// Uploads into the user's own folder and stores the path on the profile.
  Future<void> uploadAvatar(Uint8List bytes, String extension) async {
    final path =
        '$_userId/avatar_${DateTime.now().millisecondsSinceEpoch}.$extension';
    await _client.storage
        .from('avatars')
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: 'image/$extension'),
        );
    await update({'avatar_path': path});
  }
}
