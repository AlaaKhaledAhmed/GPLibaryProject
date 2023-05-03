import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:library_project/Widget/AppWidget.dart';
class StudentProjectScreen extends StatefulWidget {
  const StudentProjectScreen();

  @override
  State<StudentProjectScreen> createState() => _StudentProjectScreenState();
}

class _StudentProjectScreenState extends State<StudentProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(
          title: LocaleKeys.myProject.tr(),
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
