class User {
  final String id;
  final String password;
  final String role;
  final int isApproved;

  User({
    required this.id,
    required this.password,
    required this.role,
    required this.isApproved,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      password: map['password'],
      role: map['role'],
      isApproved: map['is_approved'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'password': password,
        'role': role,
        'is_approved': isApproved,
      };

  bool get isAllowed => isApproved == 1;
}
