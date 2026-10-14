import '../../../auth/data/models/user_model.dart';
import '../services/admin_user_service.dart';

class AdminUserRepository {
  final AdminUserService _service;

  const AdminUserRepository(this._service);

  Future<List<UserModel>> getAll() async {
    final rows = await _service.getAll();
    return rows.map((r) {
      final avatar = r['avatar_path'] as String?;
      return UserModel.fromJson(
        r,
        avatarUrl: avatar == null ? null : _service.avatarUrl(avatar),
      );
    }).toList();
  }

  Future<void> setAdmin(String userId, bool isAdmin) =>
      _service.setRole(userId, isAdmin ? 'admin' : 'user');
}
