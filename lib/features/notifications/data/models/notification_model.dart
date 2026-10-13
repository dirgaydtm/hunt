class NotificationModel {
  final String id;
  final String title;
  final String body;

  /// `announcement` or `deadline`.
  final String kind;
  final String? opportunityId;
  final DateTime? readAt;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.kind,
    required this.createdAt,
    this.opportunityId,
    this.readAt,
  });

  bool get isRead => readAt != null;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final readAt = json['read_at'] as String?;
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String? ?? '',
      kind: json['kind'] as String? ?? 'announcement',
      opportunityId: json['opportunity_id'] as String?,
      readAt: readAt == null ? null : DateTime.parse(readAt),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
