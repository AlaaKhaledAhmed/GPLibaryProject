import 'package:flutter/material.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:library_project/Widget/AppIcons.dart';
import 'package:library_project/Widget/AppSvg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SupervisorProjectScreen extends StatelessWidget {
  const SupervisorProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(
          title: LocaleKeys.supervisorProject.tr(),
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