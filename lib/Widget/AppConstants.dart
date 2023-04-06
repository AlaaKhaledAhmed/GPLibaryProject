import 'package:easy_localization/easy_localization.dart';
import 'package:library_project/BackEnd/translations/locale_keys.g.dart';

class AppConstants {
  static String typeIsStudent = 'st';
  static String typeIsTeacher = 'te';
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
}
