import 'dart:typed_data';

import 'package:flutter/material.dart' show DateTimeRange;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/locations.dart';

typedef JsonRow = Map<String, dynamic>;

class OpportunityService {
  final SupabaseClient _client;

  const OpportunityService(this._client);

  static const _table = 'opportunities';
  static const _bucket = 'opportunity-images';

  PostgrestFilterBuilder<List<JsonRow>> get _published =>
      _client.from(_table).select().eq('is_published', true);

  String publicImageUrl(String path) =>
      _client.storage.from(_bucket).getPublicUrl(path);

  Future<List<JsonRow>> getRecommended() => _published
      .eq('is_recommended', true)
      .order('created_at', ascending: false)
      .limit(10);

  Future<List<JsonRow>> getUpcomingDeadlines({int limit = 5}) => _published
      .gte('end_date', _iso(DateTime.now()))
      .order('end_date')
      .limit(limit);

  Future<List<JsonRow>> search({
    String query = '',
    String? category,
    List<String> locations = const [],
    DateTimeRange? dateRange,
  }) {
    var q = _published;
    final term = query.replaceAll(RegExp(r'[,()%*\\]'), ' ').trim();
    if (term.isNotEmpty) {
      q = q.or(
        'title.ilike.%$term%,organizer.ilike.%$term%,location.ilike.%$term%',
      );
    }
    if (category != null) q = q.eq('category', category);
    if (locations.isNotEmpty) {
      q = q.inFilter('location', [...locations, ...Locations.nationwide]);
    }
    if (dateRange != null) {
      // registration window overlaps the picked range
      q = q
          .lte('start_date', _iso(dateRange.end))
          .gte('end_date', _iso(dateRange.start));
    }
    return q.order('end_date', ascending: true, nullsFirst: false);
  }

  Future<List<JsonRow>> getByEventMonth(DateTime month) {
    final first = DateTime(month.year, month.month);
    final last = DateTime(month.year, month.month + 1, 0);
    return _published
        .gte('event_date', _iso(first))
        .lte('event_date', _iso(last))
        .order('event_date');
  }

  Future<JsonRow?> getById(String id) =>
      _client.from(_table).select().eq('id', id).maybeSingle();

  // ---- admin ----

  Future<List<JsonRow>> getAllForAdmin() =>
      _client.from(_table).select().order('created_at', ascending: false);

  Future<JsonRow> insert(JsonRow data) =>
      _client.from(_table).insert(data).select().single();

  Future<JsonRow> update(String id, JsonRow data) =>
      _client.from(_table).update(data).eq('id', id).select().single();

  Future<void> delete(String id) => _client.from(_table).delete().eq('id', id);

  Future<void> deleteImage(String path) =>
      _client.storage.from(_bucket).remove([path]);

  Future<String> uploadImage(String fileName, List<int> bytes) async {
    final safeName = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final ext = safeName.split('.').last.toLowerCase();
    final path = '${DateTime.now().millisecondsSinceEpoch}_$safeName';
    await _client.storage
        .from(_bucket)
        .uploadBinary(
          path,
          Uint8List.fromList(bytes),
          fileOptions: FileOptions(
            contentType: 'image/${ext == 'jpg' ? 'jpeg' : ext}',
          ),
        );
    return path;
  }
}

String _iso(DateTime d) => d.toIso8601String().substring(0, 10);
