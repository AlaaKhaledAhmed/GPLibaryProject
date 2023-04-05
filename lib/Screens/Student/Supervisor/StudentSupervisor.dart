import 'package:flutter/material.dart';
import 'package:library_project/Model/translations/locale_keys.g.dart';

import '../../../Widget/AppSize.dart';
import '../../../Widget/AppText.dart';
import 'package:easy_localization/easy_localization.dart';
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
        child: AppText(text: LocaleKeys.mySuperVisor.tr(), fontSize: AppSize.titleTextSize),
      ),
    );
  }
}
