import 'package:flutter/material.dart';

import '../../../Model/WidgetSize.dart';
import '../../../Widget/AppText.dart';

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
        child: AppText(text: 'My Team', fontSize: WidgetSize.titleTextSize),
      ),
    );
  }
}