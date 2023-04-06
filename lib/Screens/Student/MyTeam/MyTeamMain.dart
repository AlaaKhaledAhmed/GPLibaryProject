import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTeamMain extends StatefulWidget {
  const MyTeamMain();

  @override
  State<MyTeamMain> createState() => _MyTeamMainState();
}

class _MyTeamMainState extends State<MyTeamMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(
          title: LocaleKeys.myTeam.tr(),
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
