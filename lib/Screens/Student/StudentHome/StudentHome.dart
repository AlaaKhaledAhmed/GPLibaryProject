import 'package:flutter/material.dart';
import 'package:library_project/Model/translations/locale_keys.g.dart';

import '../../../Model/WidgetSize.dart';
import '../../../Widget/AppText.dart';
import 'package:easy_localization/easy_localization.dart';
class StudentHome extends StatefulWidget {
  const StudentHome();

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText(text: LocaleKeys.home.tr(), fontSize: WidgetSize.titleTextSize),
      ),
    );
  }
}