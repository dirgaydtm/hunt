import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hunt/core/data/opportunity_repository.dart';
import 'package:hunt/core/models/opportunity_model.dart';

Map<String, dynamic> row({
  String? start = '2026-06-08',
  String? end = '2026-07-08',
  String? image = 'assets/mock/ITfest.png',
}) => {
  'id': 'abc',
  'title': 'IT Fest 2026',
  'organizer': 'KBMDSI FILKOM UB',
  'category': 'lomba',
  'location': 'Malang',
  'requirements': ['a', 'b'],
  'documents': <String>[],
  'terms': null,
  'start_date': start,
  'end_date': end,
  'event_date': '2026-07-20',
  'image_path': image,
  'is_recommended': true,
  'created_at': '2026-07-01T10:00:00Z',
};

void main() {
  group('fromJson', () {
    test('maps columns and category label', () {
      final o = OpportunityModel.fromJson(row());
      expect(o.id, 'abc');
      expect(o.category, 'Lomba');
      expect(o.categorySlug, 'lomba');
      expect(o.syarat, ['a', 'b']);
      expect(o.ketentuan, isEmpty);
      expect(o.eventDate, DateTime(2026, 7, 20));
      expect(o.isRecommended, isTrue);
    });

    test('keeps asset paths, resolves storage paths', () {
      String resolve(String p) => 'https://cdn/$p';
      expect(
        OpportunityModel.fromJson(row(), resolveImage: resolve).imagePath,
        'assets/mock/ITfest.png',
      );
      expect(
        OpportunityModel.fromJson(
          row(image: 'x.png'),
          resolveImage: resolve,
        ).imagePath,
        'https://cdn/x.png',
      );
    });

    test('toJson round-trips writable columns', () {
      final json = OpportunityModel.fromJson(row()).toJson(imagePath: 'p');
      expect(json['category'], 'lomba');
      expect(json['start_date'], '2026-06-08');
      expect(json['image_path'], 'p');
    });
  });

  group('display text', () {
    test('dateRange omits repeated year', () {
      expect(
        OpportunityModel.fromJson(row()).dateRange,
        '8 Juni - 8 Juli 2026',
      );
      expect(
        OpportunityModel.fromJson(row(end: '2027-10-31')).dateRange,
        '8 Juni 2026 - 31 Oktober 2027',
      );
      expect(
        OpportunityModel.fromJson(row(start: null, end: null)).dateRange,
        isNull,
      );
    });

    test('urgencyText counts days to deadline', () {
      final o = OpportunityModel.fromJson(row());
      expect(o.urgencyText(DateTime(2026, 7, 5, 18)), 'Tutup dalam 3 hari');
      expect(o.urgencyText(DateTime(2026, 7, 8, 9)), 'Tutup hari ini');
      expect(o.urgencyText(DateTime(2026, 7, 9)), 'Pendaftaran ditutup');
    });

    test('postedAt is relative', () {
      final o = OpportunityModel.fromJson(row());
      expect(o.postedAt(DateTime.utc(2026, 7, 1, 13)), '3 jam lalu');
      expect(o.postedAt(DateTime.utc(2026, 7, 4, 10)), '3 hari lalu');
      expect(o.postedAt(DateTime.utc(2026, 7, 15, 10)), '2 minggu lalu');
    });
  });

  group('SearchFilters.matches', () {
    final o = OpportunityModel.fromJson(row());

    test('empty filters match everything', () {
      expect(const SearchFilters().matches(o), isTrue);
    });
    test('query, category, location', () {
      expect(const SearchFilters(query: 'fest').matches(o), isTrue);
      expect(const SearchFilters(query: 'nope').matches(o), isFalse);
      expect(const SearchFilters(category: 'Magang').matches(o), isFalse);
      expect(const SearchFilters(locations: ['Malang']).matches(o), isTrue);
      expect(const SearchFilters(locations: ['Jakarta']).matches(o), isFalse);
    });
    test('nationwide opportunities match any location filter', () {
      final online = OpportunityModel.fromJson({
        ...row(),
        'location': 'Online',
      });
      expect(const SearchFilters(locations: ['Bali']).matches(online), isTrue);
    });
    test('date range overlaps registration window', () {
      bool hit(DateTime s, DateTime e) => SearchFilters(
        dateRange: DateTimeRange(start: s, end: e),
      ).matches(o);
      expect(hit(DateTime(2026, 7, 1), DateTime(2026, 7, 30)), isTrue);
      expect(hit(DateTime(2026, 8, 1), DateTime(2026, 8, 30)), isFalse);
    });
    test('category label maps to slug', () {
      expect(
        const SearchFilters(category: 'Beasiswa').categorySlug,
        'beasiswa',
      );
      expect(const SearchFilters().categorySlug, isNull);
    });
  });
}
