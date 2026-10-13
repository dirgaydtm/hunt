import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/data/opportunity_providers.dart';
import '../../../../shared/models/opportunity_model.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';

/// Every opportunity including drafts (RLS lets admins see them).
final adminOpportunitiesProvider = FutureProvider<List<OpportunityModel>>(
  (ref) => ref.watch(opportunityRepositoryProvider).getAllForAdmin(),
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
      _refreshLists();
      return null;
    } catch (e) {
      return failureMessage(e);
    } finally {
      state = false;
    }
  }

  void _refreshLists() {
    ref.invalidate(adminOpportunitiesProvider);
    ref.invalidate(homeRecommendationsProvider);
    ref.invalidate(homeRemindersProvider);
    ref.invalidate(opportunityByIdProvider);
    ref.invalidate(searchResultsProvider);
  }

  Future<String?> save(
    OpportunityModel opp, {
    required bool isNew,
    PickedImage? newImage,
  }) => _run(() async {
    final repo = ref.read(opportunityRepositoryProvider);
    final imagePath = newImage == null
        ? opp.rawImagePath
        : await repo.uploadImage(newImage.name, newImage.bytes);
    await repo.save(opp, isNew: isNew, imagePath: imagePath);
  });

  Future<String?> delete(String id) =>
      _run(() => ref.read(opportunityRepositoryProvider).delete(id));

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
