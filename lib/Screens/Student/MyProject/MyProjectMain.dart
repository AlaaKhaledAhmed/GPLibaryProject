import 'package:flutter/material.dart';
import 'package:library_project/Model/WidgetSize.dart';
import 'package:library_project/Model/translations/locale_keys.g.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:easy_localization/easy_localization.dart';
class MyProjectMain extends StatefulWidget {
  const MyProjectMain();

  @override
  State<MyProjectMain> createState() => _MyProjectMainState();
}

class _MyProjectMainState extends State<MyProjectMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText(text: LocaleKeys.myProject.tr(), fontSize: WidgetSize.titleTextSize),
      ),
    );
  }
}
