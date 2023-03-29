// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ar = {
  "singUpStudentTx": "إنشاء حساب طالب",
  "singUpTeacherTx": "إنشاء حساب دكتور",
  "loginTx": "تسجيل الدخول",
  "noHaveAccountTx": "يبدو أنه ليس لديك حساب. لنقم بإنشاء حساب جديد لك الآن",
  "mandatoryTx": "حقل اجباري",
  "name": "اسم المستخدم",
  "emailTx": "البريد إلكتروني",
  "passwordTx": "كلمة المرور",
  "idTx": "الرقم الجامعي",
  "phoneTx": "رقم الجوال",
  "majorTx": "تخصص الطالب",
  "searchInterestTx": "الاهتمامات",
  "isTeacher": "هل انت دكتور",
  "isStudent": "هل انت طالب",
  "createAccount": "إنشاء حساب",
  "goTo": "الذهاب الى",
  "invalidEmail": "البريد الالكتروني غير صالح",
  "invalidName": "اسم المستخدم غير صالح",
  "weekPass": "كلمة المرور ضعيفة",
  "invalidPhone": "رقم الجوال يجب ان يكون ١٠ خانات",
  "invalidId": "رقم الطالب يجب ان يكون 6 خانات",
  "emailFound": "البريد الالكتروني موجود بالفعل",
  "error": "حدث خطأ. الرجاء معاودة المحاولة في وقت لاحق",
  "userNotFound": "المستخدم غير موجود",
  "invalidPassword": "يجب أن تتكون كلمة المرور 6 خانات على الأقل",
  "cancel": "إلغاء",
  "lang": "اللغة",
  "signOut": "تسجيل الخروج",
  "confirmDelete": "هل أنت متأكد من اكمال عملية الحذف",
  "delete": "حذف",
  "update": "تعديل",
  "noData": "لا توجد بيانات لعرضها حاليا",
  "add": "إضافة",
  "home": "الرئسية",
  "completed": "اكتملت العملية بنجاح"
};
static const Map<String,dynamic> en = {
  "singUpStudentTx": "Student Sing Up",
  "singUpTeacherTx": "Teacher Sing Up",
  "loginTx": "Logging Page",
  "noHaveAccountTx": "It seems that you do not have an account. Let us create a new account for you now",
  "mandatoryTx": "Mandatory field",
  "name": "User Name",
  "emailTx": "Email",
  "passwordTx": "Password",
  "idTx": "Student ID",
  "phoneTx": "Phone Number",
  "majorTx": "Student Major",
  "searchInterestTx": "Search Interest",
  "isTeacher": "Are you a teacher",
  "isStudent": "Are you a student",
  "createAccount": "Create an account",
  "goTo": "Go to",
  "invalidEmail": "The email is not valid",
  "invalidName": "The username is not valid",
  "weekPass": "Weak password",
  "invalidPhone": "Mobile number must be 10 digits",
  "invalidId": "The student ID must be 6 digits",
  "emailFound": "The email already exists",
  "error": "An error occurred. Please try again later",
  "userNotFound": "The user does not exist",
  "invalidPassword": "Password must be at least 6 digits",
  "cancel": "Cancel",
  "lang": "Language",
  "signOut": "Sign Out",
  "confirmDelete": "Are you sure to complete the deletion",
  "delete": "Delete",
  "update": "Update",
  "noData": "There is no data to display at this time",
  "add": "Add",
  "home": "Home",
  "completed": "The operation completed successfully"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": ar, "en": en};
}
