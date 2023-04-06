import 'package:library_project/BackEnd/Models/StudentModel.dart';

class TeamModel {
  int teamId;
  List<Student> member;
  int teamOwnerId;
  TeamModel({
    required this.member,
    required this.teamOwnerId,
    required this.teamId,
  });
}
