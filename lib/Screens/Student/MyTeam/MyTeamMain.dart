import 'package:flutter/material.dart';
import 'package:library_project/Model/translations/locale_keys.g.dart';

import '../../../Model/WidgetSize.dart';
import '../../../Widget/AppText.dart';
import 'package:easy_localization/easy_localization.dart';

class MyTeamMain extends StatefulWidget {
  const MyTeamMain();

  @override
  State<MyTeamMain> createState() => _MyTeamMainState();
}

class _MyTeamMainState extends State<MyTeamMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText(text: LocaleKeys.myTeam.tr(), fontSize: WidgetSize.titleTextSize),
      ),
    );
  }
}
