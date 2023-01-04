class User {
  String id;
  String name;
  String email;
  String role;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
        role: json['role']);
  }

  Map<String, dynamic> toJson() =>
      {'_id': id, 'name': name, 'email': email, 'role': role};
}
