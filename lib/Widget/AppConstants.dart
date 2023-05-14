import 'package:easy_localization/easy_localization.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AppConstants {
  static String typeIsStudent = 'st';
  static String typeIsSupervisor = 'te';
  static int statusIsNotSendYet = 0;
  static int statusIsWaiting = 1;
  static int statusIsAcceptation = 2;
  static int statusIsRejection = 3;
  static String student = 'student';
  static String supervisor = 'supervisor';
  static int selectStudentFile=1;
  static int selectSuperFile=1;
  static int filterByMajor=1;
  static int filterBySearch=2;
  static List<String> majorList = [
    LocaleKeys.softwareEngineering.tr(),
    LocaleKeys.dataScience.tr(),
    LocaleKeys.informationSecurity.tr(),
    LocaleKeys.informationTechnology.tr(),
    LocaleKeys.networkEngineering.tr()
  ];

  static List<String> searchList = [
    LocaleKeys.artificialIntelligence.tr(),
    LocaleKeys.softwareDevelopment.tr(),
    LocaleKeys.dataManagement.tr(),
    LocaleKeys.webDevelopment.tr()
  ];

  static CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');
  static CollectionReference requestCollection =
  FirebaseFirestore.instance.collection('requests');
  static CollectionReference projectCollection =
  FirebaseFirestore.instance.collection('project');
}
