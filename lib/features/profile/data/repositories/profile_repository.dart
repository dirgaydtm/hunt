import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient _client;

  const ProfileRepository(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<void> _update(Map<String, dynamic> data) =>
      _client.from('profiles').update(data).eq('id', _userId);

  Future<void> updateProfile({
    required String name,
    String? university,
    String? major,
    int? graduationYear,
  }) => _update({
    'name': name,
    'university': university,
    'major': major,
    'graduation_year': graduationYear,
  });

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
    await _update({'avatar_path': path});
  }
}
