
import 'package:easy_localization/easy_localization.dart';
import 'package:library_project/Model/translations/locale_keys.g.dart';
import 'package:email_validator/email_validator.dart';

import 'Constants.dart';

class Validator {
//valid empty data============================================================
  static String? validatorEmpty(String v) {
    if (v.isEmpty) {
      return LocaleKeys.mandatoryTx.tr();
    } else {
      return null;
    }
  }
//valid name data============================================================
  static String? validatorName(String name) {
    final nameRegExp =  RegExp(r"^\s*([A-Za-z]{2,10})$");
    if (name.isEmpty) {
      return LocaleKeys.mandatoryTx.tr();
    }if (nameRegExp.hasMatch(name)==false) {
      return LocaleKeys.invalidName.tr();
    } else {
      return null;
    }
  }
  //valid email=============================================================
  static String? validatorEmail(String email, String type) {
    var match = RegExp(r'(^|\D)\d{6,6}($|\D)').hasMatch(email);
    print('match :$match');
    print('type :$type');
    if (email.isEmpty) {
      return LocaleKeys.mandatoryTx.tr();
    }

    if (type == Constants.typeIsStudent) {
      if ((email.endsWith('@taibahu.edu.sa') == false) ||
          ((email.startsWith('tu') == false))|| match==false) {
        return LocaleKeys.invalidEmail.tr() ;
      }
      return null;
    }
    if (type == Constants.typeIsTeacher) {
      if ((email.endsWith('@taibahu.edu.sa') == false) ||
          (email.startsWith('tu') == false)) {
        return LocaleKeys.invalidEmail.tr();
      }
      return null;
    }

    if (EmailValidator.validate(email.trim()) == false) {
      return LocaleKeys.invalidEmail.tr();
    }
    return null;
  }
//valid ID data============================================================
  static String? validatorID(String id) {
    final idRegExp = RegExp(r"^\s*[0-9]{6}$");
    if (id.isEmpty) {
      return LocaleKeys.mandatoryTx.tr();
    }if (idRegExp.hasMatch(id)==false){
      return LocaleKeys.invalidId.tr();
    } else {
      return null;
    }
  }
//valid Password data============================================================
  static String? validatorPassword(String pass) {
    if (pass.isEmpty) {
      return LocaleKeys.mandatoryTx.tr();
    }if (pass.length<6) {
      return LocaleKeys.invalidPassword.tr();
    } else {
      return null;
    }
  }
//valid Phone data============================================================
  static String? validatorPhone(String phone) {
    final phoneRegExp = RegExp(r"^\s*[0-9]{10}$");
    if (phone.trim().isEmpty) {
      return LocaleKeys.mandatoryTx.tr();
    }
    if (phoneRegExp.hasMatch(phone)==false || phone.startsWith('05')==false) {
      return LocaleKeys.invalidPhone.tr();
    }
    return null;
  }
}
