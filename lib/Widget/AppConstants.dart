import 'package:library_project/Model/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

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
