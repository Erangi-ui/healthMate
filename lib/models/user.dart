class User {
  final String? id;
  final String email;
  final String password;
  final String name;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'password': password,
      'name': name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString(),
      email: map['email'],
      password: map['password'],
      name: map['name'],
    );
  }
}