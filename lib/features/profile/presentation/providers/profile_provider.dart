import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/supabase/supabase_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/services/profile_service.dart';

final profileServiceProvider = Provider(
  (ref) => ProfileService(ref.watch(supabaseClientProvider)),
);

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(ref.watch(profileServiceProvider)),
);

/// `true` while a profile save or avatar upload is in flight.
/// Action methods return an error message, or null on success.
class ProfileController extends Notifier<bool> {
  @override
  bool build() => false;

  Future<String?> _run(Future<void> Function() action) async {
    state = true;
    try {
      await action();
      await ref.read(authProvider.notifier).refresh();
      return null;
    } catch (e) {
      return failureMessage(e);
    } finally {
      state = false;
    }
  }

  Future<String?> updateProfile({
    required String name,
    String? university,
    String? major,
    int? graduationYear,
  }) => _run(
    () => ref
        .read(profileRepositoryProvider)
        .updateProfile(
          name: name,
          university: university,
          major: major,
          graduationYear: graduationYear,
        ),
  );

  /// Opens the gallery; returns null without uploading if cancelled.
  Future<String?> pickAndUploadAvatar() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      imageQuality: 85,
    );
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    final ext = file.name.split('.').last.toLowerCase();
    return _run(
      () => ref
          .read(profileRepositoryProvider)
          .uploadAvatar(bytes, ext == 'jpg' ? 'jpeg' : ext),
    );
  }
}

final profileControllerProvider = NotifierProvider<ProfileController, bool>(
  ProfileController.new,
);
