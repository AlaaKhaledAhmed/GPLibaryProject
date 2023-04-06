import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/BackEnd/translations/locale_keys.g.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:library_project/Widget/AppWidget.dart';
class MyProjectMain extends StatefulWidget {
  const MyProjectMain();

  @override
  State<MyProjectMain> createState() => _MyProjectMainState();
}

class _MyProjectMainState extends State<MyProjectMain> {
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
