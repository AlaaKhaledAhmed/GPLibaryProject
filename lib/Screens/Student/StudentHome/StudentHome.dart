import 'package:flutter/material.dart';

import '../../../Model/WidgetSize.dart';
import '../../../Widget/AppText.dart';

class StudentHome extends StatefulWidget {
  const StudentHome();

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText(text: 'Home', fontSize: WidgetSize.titleTextSize),
      ),
    );
  }
}