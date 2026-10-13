import 'package:flutter/material.dart';

import '../models/opportunity_model.dart';
import 'opportunity_service.dart';

class OpportunityRepository {
  final OpportunityService _service;

  const OpportunityRepository(this._service);

  OpportunityModel _map(JsonRow row) =>
      OpportunityModel.fromJson(row, resolveImage: _service.publicImageUrl);

  List<OpportunityModel> _mapAll(List<JsonRow> rows) => rows.map(_map).toList();

  Future<List<OpportunityModel>> getRecommended() async =>
      _mapAll(await _service.getRecommended());

  Future<List<OpportunityModel>> getUpcomingDeadlines() async =>
      _mapAll(await _service.getUpcomingDeadlines());

  Future<List<OpportunityModel>> search(SearchFilters filters) async => _mapAll(
    await _service.search(
      query: filters.query,
      category: filters.categorySlug,
      locations: filters.locations,
      dateRange: filters.dateRange,
    ),
  );

  Future<List<OpportunityModel>> getByEventMonth(DateTime month) async =>
      _mapAll(await _service.getByEventMonth(month));

  Future<OpportunityModel?> getById(String id) async {
    final row = await _service.getById(id);
    return row == null ? null : _map(row);
  }

  Future<List<OpportunityModel>> getAllForAdmin() async =>
      _mapAll(await _service.getAllForAdmin());

  /// Creates or updates. [imagePath] is the raw storage/asset path.
  Future<OpportunityModel> save(
    OpportunityModel opp, {
    required bool isNew,
    String? imagePath,
  }) async {
    final data = opp.toJson(imagePath: imagePath);
    return _map(
      isNew ? await _service.insert(data) : await _service.update(opp.id, data),
    );
  }

  Future<void> delete(String id) => _service.delete(id);

  Future<String> uploadImage(String fileName, List<int> bytes) =>
      _service.uploadImage(fileName, bytes);
}

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
        !(opp.location?.toLowerCase().contains(q) ?? false)) {
      return false;
    }
    if (category != 'Semua' && opp.category != category) return false;
    if (locations.isNotEmpty && !locations.contains(opp.location)) {
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
