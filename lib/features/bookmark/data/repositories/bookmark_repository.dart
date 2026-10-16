import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/opportunity_repository.dart';
import '../../../../core/models/opportunity_model.dart';

class BookmarkRepository {
  final SupabaseClient _client;
  final OpportunityRepository _opportunities;

  const BookmarkRepository(this._client, this._opportunities);

  String get _userId => _client.auth.currentUser!.id;

  /// Newest bookmark first.
  Future<List<OpportunityModel>> getBookmarks() async {
    final rows = await _client
        .from('bookmarks')
        .select('created_at, opportunities(*)')
        .eq('user_id', _userId)
        .order('created_at', ascending: false);
    return rows
        .map((r) => r['opportunities'] as JsonRow?)
        .whereType<JsonRow>()
        .map(_opportunities.fromRow)
        .toList();
  }

  /// Idempotent: an existing bookmark is left as is (there is no UPDATE
  /// policy, so a merging upsert would be rejected by RLS).
  Future<void> add(String opportunityId) => _client.from('bookmarks').upsert({
    'user_id': _userId,
    'opportunity_id': opportunityId,
  }, ignoreDuplicates: true);

  Future<void> remove(String opportunityId) => _client
      .from('bookmarks')
      .delete()
      .eq('user_id', _userId)
      .eq('opportunity_id', opportunityId);
}
