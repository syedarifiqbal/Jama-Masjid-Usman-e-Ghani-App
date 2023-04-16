class User {
  final int? id;
  final String name;
  final String email;
  final bool isAdmin;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isAdmin: json['is_admin'],
    );
  }
}
