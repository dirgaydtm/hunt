import '../../core/utils/date_time_extension.dart';

/// Category slugs as stored in the database, mapped to display labels.
const opportunityCategories = {
  'beasiswa': 'Beasiswa',
  'lomba': 'Lomba',
  'magang': 'Magang',
};

class OpportunityModel {
  final String id;
  final String title;
  final String organizer;

  /// Display label, e.g. `Beasiswa`.
  final String category;
  final String? location;
  final String? description;
  final List<String> syarat;
  final List<String> berkas;
  final List<String> ketentuan;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? eventDate;
  final String? registrationUrl;

  /// Either a bundled asset path (`assets/...`) or a full network URL.
  final String? imagePath;
  final bool isRecommended;
  final bool isPublished;
  final DateTime? createdAt;

  const OpportunityModel({
    required this.id,
    required this.title,
    required this.organizer,
    required this.category,
    this.location,
    this.description,
    this.syarat = const [],
    this.berkas = const [],
    this.ketentuan = const [],
    this.startDate,
    this.endDate,
    this.eventDate,
    this.registrationUrl,
    this.imagePath,
    this.isRecommended = false,
    this.isPublished = true,
    this.createdAt,
  });

  String get categorySlug => opportunityCategories.entries
      .firstWhere(
        (e) => e.value == category,
        orElse: () => const MapEntry('beasiswa', 'Beasiswa'),
      )
      .key;

  /// [resolveImage] turns a storage path into a public URL.
  factory OpportunityModel.fromJson(
    Map<String, dynamic> json, {
    String Function(String path)? resolveImage,
  }) {
    final image = json['image_path'] as String?;
    return OpportunityModel(
      id: json['id'] as String,
      title: json['title'] as String,
      organizer: json['organizer'] as String,
      category:
          opportunityCategories[json['category']] ?? json['category'] as String,
      location: json['location'] as String?,
      description: json['description'] as String?,
      syarat: _strings(json['requirements']),
      berkas: _strings(json['documents']),
      ketentuan: _strings(json['terms']),
      startDate: _date(json['start_date']),
      endDate: _date(json['end_date']),
      eventDate: _date(json['event_date']),
      registrationUrl: json['registration_url'] as String?,
      imagePath: image == null || image.startsWith('assets/')
          ? image
          : resolveImage?.call(image) ?? image,
      isRecommended: json['is_recommended'] as bool? ?? false,
      isPublished: json['is_published'] as bool? ?? true,
      createdAt: _date(json['created_at']),
    );
  }

  /// Columns written by the admin form. [imagePath] must be the raw
  /// storage path or asset path, not a URL.
  Map<String, dynamic> toJson({String? imagePath}) => {
    'title': title,
    'organizer': organizer,
    'category': categorySlug,
    'location': location,
    'description': description,
    'requirements': syarat,
    'documents': berkas,
    'terms': ketentuan,
    'start_date': _dateOnly(startDate),
    'end_date': _dateOnly(endDate),
    'event_date': _dateOnly(eventDate),
    'registration_url': registrationUrl,
    'image_path': imagePath,
    'is_recommended': isRecommended,
    'is_published': isPublished,
  };

  /// e.g. `8 Juni - 8 Juli 2026` or `1 November 2026 - 31 Oktober 2027`.
  String? get dateRange {
    final s = startDate, e = endDate;
    if (s == null && e == null) return null;
    if (s == null) return 'Hingga ${_long(e!)}';
    if (e == null) return 'Mulai ${_long(s)}';
    final start = s.year == e.year ? '${s.day} ${s.toMonthName()}' : _long(s);
    return '$start - ${_long(e)}';
  }

  /// Deadline countdown, or null when there is no deadline.
  String? urgencyText([DateTime? now]) {
    final e = endDate;
    if (e == null) return null;
    final days = e.difference(_day(now ?? DateTime.now())).inDays;
    if (days < 0) return 'Pendaftaran ditutup';
    if (days == 0) return 'Tutup hari ini';
    return 'Tutup dalam $days hari';
  }

  /// Relative publish time, e.g. `3 hari lalu`.
  String? postedAt([DateTime? now]) {
    final c = createdAt;
    if (c == null) return null;
    final diff = (now ?? DateTime.now()).difference(c);
    if (diff.inHours < 1) return 'Baru saja';
    if (diff.inDays < 1) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    if (diff.inDays < 30) return '${diff.inDays ~/ 7} minggu lalu';
    return _long(c.toLocal());
  }

  static List<OpportunityModel> get dummies => List.generate(
    3,
    (i) => OpportunityModel(
      id: 'skeleton-$i',
      title: 'Skeleton Title Loading ${i + 1}',
      organizer: 'Skeleton Subtitle Loading',
      category: '',
    ),
  );

  @override
  bool operator ==(Object other) => other is OpportunityModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

List<String> _strings(Object? v) =>
    v is List ? v.map((e) => e.toString()).toList() : const [];

DateTime? _date(Object? v) => v is String ? DateTime.parse(v) : null;

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

String _long(DateTime d) => '${d.day} ${d.toMonthName()} ${d.year}';

String? _dateOnly(DateTime? d) => d == null
    ? null
    : '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';
