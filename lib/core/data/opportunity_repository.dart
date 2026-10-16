import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/locations.dart';
import '../models/opportunity_model.dart';

typedef JsonRow = Map<String, dynamic>;

const _table = 'opportunities';
const _bucket = 'opportunity-images';

class OpportunityRepository {
  final SupabaseClient _client;

  const OpportunityRepository(this._client);

  PostgrestFilterBuilder<List<JsonRow>> get _published =>
      _client.from(_table).select().eq('is_published', true);

  OpportunityModel fromRow(JsonRow row) => OpportunityModel.fromJson(
    row,
    resolveImage: (path) => _client.storage.from(_bucket).getPublicUrl(path),
  );

  Future<List<OpportunityModel>> _list(Future<List<JsonRow>> rows) async =>
      (await rows).map(fromRow).toList();

  Future<List<OpportunityModel>> getRecommended() => _list(
    _published
        .eq('is_recommended', true)
        .order('created_at', ascending: false)
        .limit(10),
  );

  Future<List<OpportunityModel>> getUpcomingDeadlines() => _list(
    _published
        .gte('end_date', _iso(DateTime.now()))
        .order('end_date', ascending: true)
        .limit(5),
  );

  Future<List<OpportunityModel>> search(SearchFilters filters) {
    var q = _published;
    final term = filters.query.replaceAll(RegExp(r'[,()%*\\]'), ' ').trim();
    if (term.isNotEmpty) {
      final lower = term.toLowerCase();
      final categories = opportunityCategories.keys
          .where((slug) => slug.contains(lower))
          .map((slug) => ',category.eq.$slug')
          .join();
      q = q.or(
        'title.ilike.%$term%,organizer.ilike.%$term%,location.ilike.%$term%'
        '$categories',
      );
    }
    final category = filters.categorySlug;
    if (category != null) q = q.eq('category', category);
    if (filters.locations.isNotEmpty) {
      q = q.inFilter('location', [
        ...filters.locations,
        ...Locations.nationwide,
      ]);
    }
    final range = filters.dateRange;
    if (range != null) {
      // registration window overlaps the picked range
      q = q
          .lte('start_date', _iso(range.end))
          .gte('end_date', _iso(range.start));
    }
    return _list(q.order('end_date', ascending: true, nullsFirst: false));
  }

  Future<List<OpportunityModel>> getByEventMonth(DateTime month) => _list(
    _published
        .gte('event_date', _iso(DateTime(month.year, month.month)))
        .lte('event_date', _iso(DateTime(month.year, month.month + 1, 0)))
        .order('event_date', ascending: true),
  );

  Future<OpportunityModel?> getById(String id) async {
    final row = await _client.from(_table).select().eq('id', id).maybeSingle();
    return row == null ? null : fromRow(row);
  }

  Future<List<OpportunityModel>> getAllForAdmin() => _list(
    _client.from(_table).select().order('created_at', ascending: false),
  );

  /// Creates or updates. [imagePath] is the raw storage/asset path.
  Future<OpportunityModel> save(
    OpportunityModel opp, {
    required bool isNew,
    String? imagePath,
  }) async {
    final data = opp.toJson(imagePath: imagePath);
    final query = isNew
        ? _client.from(_table).insert(data)
        : _client.from(_table).update(data).eq('id', opp.id);
    return fromRow(await query.select().single());
  }

  Future<void> delete(String id) => _client.from(_table).delete().eq('id', id);

  /// Removes an uploaded image; bundled assets are left alone.
  /// Best effort: a leftover file must not fail the user's action.
  Future<void> deleteImage(String path) async {
    if (path.startsWith('assets/')) return;
    try {
      await _client.storage.from(_bucket).remove([path]);
    } catch (_) {}
  }

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

/// Search criteria shared by the search page and filter sheet.
class SearchFilters {
  final String query;

  /// Display label (`Beasiswa`) or `Semua` for any.
  final String category;
  final List<String> locations;
  final DateTimeRange? dateRange;

  const SearchFilters({
    this.query = '',
    this.category = 'Semua',
    this.locations = const [],
    this.dateRange,
  });

  String? get categorySlug => opportunityCategories.entries
      .where((e) => e.value == category)
      .map((e) => e.key)
      .firstOrNull;

  bool get hasFilters =>
      category != 'Semua' || locations.isNotEmpty || dateRange != null;

  /// Client-side equivalent of the server search, for already-loaded lists.
  bool matches(OpportunityModel opp) {
    final q = query.toLowerCase();
    if (q.isNotEmpty &&
        !opp.title.toLowerCase().contains(q) &&
        !opp.organizer.toLowerCase().contains(q) &&
        !opp.category.toLowerCase().contains(q) &&
        !(opp.location?.toLowerCase().contains(q) ?? false)) {
      return false;
    }
    if (category != 'Semua' && opp.category != category) return false;
    if (locations.isNotEmpty &&
        !locations.contains(opp.location) &&
        !Locations.nationwide.contains(opp.location)) {
      return false;
    }
    final range = dateRange;
    if (range != null) {
      final start = opp.startDate, end = opp.endDate;
      if (start == null || end == null) return false;
      if (start.isAfter(range.end) || end.isBefore(range.start)) return false;
    }
    return true;
  }

  SearchFilters copyWith({
    String? query,
    String? category,
    List<String>? locations,
    DateTimeRange? Function()? dateRange,
  }) => SearchFilters(
    query: query ?? this.query,
    category: category ?? this.category,
    locations: locations ?? this.locations,
    dateRange: dateRange != null ? dateRange() : this.dateRange,
  );

  @override
  bool operator ==(Object other) =>
      other is SearchFilters &&
      other.query == query &&
      other.category == category &&
      other.dateRange == dateRange &&
      other.locations.length == locations.length &&
      other.locations.every(locations.contains);

  @override
  int get hashCode => Object.hash(
    query,
    category,
    dateRange,
    Object.hashAllUnordered(locations),
  );
}
