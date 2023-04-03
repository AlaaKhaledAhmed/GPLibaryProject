import 'package:flutter/material.dart';
import 'package:library_project/Model/WidgetSize.dart';
import 'package:library_project/Widget/AppText.dart';

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
        child: AppText(text: 'My project', fontSize: WidgetSize.titleTextSize),
      ),
    );
  }
}
