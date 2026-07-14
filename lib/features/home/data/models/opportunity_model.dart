class OpportunityModel {
  final String title;
  final String organizer;
  final String category;
  final String? dateRange;
  final String? postedAt;
  final String? urgencyText;
  final String? imagePath;
  final String? description;
  final List<String>? syarat;
  final List<String>? berkas;
  final List<String>? ketentuan;
  final DateTime? eventDate;

  const OpportunityModel({
    required this.title,
    required this.organizer,
    required this.category,
    this.dateRange,
    this.postedAt,
    this.urgencyText,
    this.imagePath,
    this.description,
    this.syarat,
    this.berkas,
    this.ketentuan,
    this.eventDate,
  });

  static List<OpportunityModel> get dummies => [
    const OpportunityModel(
      title: 'Skeleton Title Loading 1',
      organizer: 'Skeleton Subtitle Loading',
      category: '',
      dateRange: 'Loading Date',
      postedAt: 'Loading',
      urgencyText: 'Loading',
      imagePath: null,
    ),
    const OpportunityModel(
      title: 'Skeleton Title Loading 2',
      organizer: 'Skeleton Subtitle Loading',
      category: '',
      dateRange: 'Loading Date',
      postedAt: 'Loading',
      urgencyText: 'Loading',
      imagePath: null,
    ),
    const OpportunityModel(
      title: 'Skeleton Title Loading 3',
      organizer: 'Skeleton Subtitle Loading',
      category: '',
      dateRange: 'Loading Date',
      postedAt: 'Loading',
      urgencyText: 'Loading',
      imagePath: null,
    ),
  ];
}
