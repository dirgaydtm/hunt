class UserModel {
  final String email;
  final String name;
  final String? token;

  const UserModel({
    required this.email,
    required this.name,
    this.token,
  });
}
