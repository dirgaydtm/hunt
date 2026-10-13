import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationRepository {
  final NotificationService _service;

  const NotificationRepository(this._service);

  Stream<List<NotificationModel>> watch(String userId) => _service
      .watch(userId)
      .map((rows) => rows.map(NotificationModel.fromJson).toList());

  Future<void> markRead(String id) => _service.markRead(id);

  Future<void> markAllRead(String userId) => _service.markAllRead(userId);

  Future<int> broadcast({
    required String title,
    required String body,
    String? opportunityId,
  }) => _service.broadcast(
    title: title,
    body: body,
    opportunityId: opportunityId,
  );
}
