class UserModel {
  final String id;
  final String email;
  final String name;
  final String? university;
  final String? major;
  final int? graduationYear;
  final String? avatarUrl;
  final String role;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.university,
    this.major,
    this.graduationYear,
    this.avatarUrl,
    this.role = 'user',
  });

  bool get isAdmin => role == 'admin';

  factory UserModel.fromJson(Map<String, dynamic> json, {String? avatarUrl}) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String? ?? '',
      university: json['university'] as String?,
      major: json['major'] as String?,
      graduationYear: json['graduation_year'] as int?,
      avatarUrl: avatarUrl,
      role: json['role'] as String? ?? 'user',
    );
  }
}
