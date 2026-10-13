import 'dart:typed_data';

import '../services/profile_service.dart';

class ProfileRepository {
  final ProfileService _service;

  const ProfileRepository(this._service);

  Future<void> updateProfile({
    required String name,
    String? university,
    String? major,
    int? graduationYear,
  }) => _service.update({
    'name': name,
    'university': university,
    'major': major,
    'graduation_year': graduationYear,
  });

  Future<void> uploadAvatar(Uint8List bytes, String extension) =>
      _service.uploadAvatar(bytes, extension);
}
