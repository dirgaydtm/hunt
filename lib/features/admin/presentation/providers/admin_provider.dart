import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/supabase/supabase_provider.dart';
import '../../../../core/data/opportunity_providers.dart';
import '../../../../core/models/opportunity_model.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/repositories/admin_user_repository.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';

/// Every opportunity including drafts (RLS lets admins see them).
final adminOpportunitiesProvider = FutureProvider<List<OpportunityModel>>(
  (ref) => ref.watch(opportunityRepositoryProvider).getAllForAdmin(),
);

final adminUserRepositoryProvider = Provider(
  (ref) => AdminUserRepository(ref.watch(supabaseClientProvider)),
);

final adminUsersProvider = FutureProvider<List<UserModel>>(
  (ref) => ref.watch(adminUserRepositoryProvider).getAll(),
);

/// A picked image waiting to be uploaded.
typedef PickedImage = ({String name, Uint8List bytes});

/// `true` while an admin write is in flight. Methods return an error
/// message, or null on success.
class AdminController extends Notifier<bool> {
  @override
  bool build() => false;

  Future<String?> _run(Future<void> Function() action) async {
    state = true;
    try {
      await action();
      ref.invalidate(opportunityRepositoryProvider);
      return null;
    } catch (e) {
      return failureMessage(e);
    } finally {
      state = false;
    }
  }

  Future<String?> save(
    OpportunityModel opp, {
    required bool isNew,
    PickedImage? newImage,
  }) => _run(() async {
    final repo = ref.read(opportunityRepositoryProvider);
    final oldImage = opp.rawImagePath;
    final imagePath = newImage == null
        ? oldImage
        : await repo.uploadImage(newImage.name, newImage.bytes);
    await repo.save(opp, isNew: isNew, imagePath: imagePath);
    if (newImage != null && oldImage != null) {
      await repo.deleteImage(oldImage);
    }
  });

  Future<String?> delete(OpportunityModel opp) => _run(() async {
    final repo = ref.read(opportunityRepositoryProvider);
    await repo.delete(opp.id);
    if (opp.rawImagePath != null) await repo.deleteImage(opp.rawImagePath!);
  });

  Future<String?> setAdmin(String userId, bool isAdmin) async {
    state = true;
    try {
      await ref.read(adminUserRepositoryProvider).setAdmin(userId, isAdmin);
      ref.invalidate(adminUsersProvider);
      return null;
    } catch (e) {
      return failureMessage(e);
    } finally {
      state = false;
    }
  }

  Future<String?> broadcast({
    required String title,
    required String body,
    String? opportunityId,
  }) async {
    state = true;
    try {
      await ref
          .read(notificationRepositoryProvider)
          .broadcast(title: title, body: body, opportunityId: opportunityId);
      return null;
    } catch (e) {
      return failureMessage(e);
    } finally {
      state = false;
    }
  }
}

final adminControllerProvider = NotifierProvider<AdminController, bool>(
  AdminController.new,
);
