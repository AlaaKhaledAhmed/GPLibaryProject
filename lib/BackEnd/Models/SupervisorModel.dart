
import 'dart:convert';

// Supervisor supervisorFromJson(String str,String docId) => Supervisor.fromMap(json.decode(str), docId);
//
// String supervisorToJson(Supervisor data) => json.encode(data.toJson());

class Supervisor {
  String auth;
  String email;
  String major;
  String name;
  String password;
  String stId;
  String type;
  String userId;
  String docId;

  Supervisor({
    required this.auth,
    required this.email,
    required this.major,
    required this.name,
    required this.password,
    required this.stId,
    required this.type,
    required this.userId,
    required this.docId,
  });

  factory Supervisor.fromMap(Map snapshot, String docId) => Supervisor(
        docId: docId,
        auth: snapshot["auth"] ?? '',
        email: snapshot["email"] ?? '',
        major: snapshot["major"] ?? '',
        name: snapshot["name"] ?? '',
        password: snapshot["password"] ?? '',
        stId: snapshot["stId"] ?? '',
        type: snapshot["type"] ?? '',
        userId: snapshot["userId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "auth": auth,
        "email": email,
        "major": major,
        "name": name,
        "password": password,
        "stId": stId,
        "type": type,
        "userId": userId,
      };

}
