import 'package:flutter/material.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppWidget.dart';

import '../../../Widget/AppSize.dart';
import '../../../Widget/AppText.dart';
import 'package:easy_localization/easy_localization.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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