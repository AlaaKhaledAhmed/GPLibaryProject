import 'package:flutter/material.dart';
import 'package:library_project/Model/translations/locale_keys.g.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppWidget.dart';

import '../../../Widget/AppSize.dart';
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
        appBar: AppBarMain(
          title: LocaleKeys.home.tr(),
        ),
        body: AppWidget.body(
            child: Container(
              margin: EdgeInsets.only(bottom: AppSize.bottomPageSize),
              child: Column(
                children: [],
              ),
            )));
  }
}