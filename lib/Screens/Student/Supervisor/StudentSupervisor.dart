import 'package:flutter/material.dart';

import '../../../Model/WidgetSize.dart';
import '../../../Widget/AppText.dart';

class StudentSupervisor extends StatefulWidget {
  const StudentSupervisor();

  @override
  State<StudentSupervisor> createState() => _StudentSupervisorState();
}

class _StudentSupervisorState extends State<StudentSupervisor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText(text: 'Supervisors', fontSize: WidgetSize.titleTextSize),
      ),
    );
  }
}
