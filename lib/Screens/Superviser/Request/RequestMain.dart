import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RequestMain extends StatelessWidget {
  const RequestMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(
          title: LocaleKeys.requests.tr(),
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