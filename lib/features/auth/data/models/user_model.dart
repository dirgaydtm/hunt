class UserModel {
  final String email;
  final String name;
  final String? token;
  final String university;
  final String major;
  final String graduationYear;

  const UserModel({
    required this.email,
    required this.name,
    this.token,
    this.university = 'Universitas Brawijaya',
    this.major = 'Sistem Informasi',
    this.graduationYear = '2025',
  });
}
