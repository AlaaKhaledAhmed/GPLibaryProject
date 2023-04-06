class Student {
  final String name;
  final String? email;
  final String? password;
  final String stId;
  final String? major;
  final String? phone;
  final String auth;
  Student({
    this.email,
    this.password,
    required this.stId,
    this.major,
    this.phone,
    required this.name,
    required this.auth
  });
}
