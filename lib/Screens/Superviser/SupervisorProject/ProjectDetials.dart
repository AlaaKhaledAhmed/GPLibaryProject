import 'package:flutter/material.dart';
import 'package:library_project/BackEnd/Database/DatabaseMethods.dart';
import 'package:library_project/Screens/Superviser/SupervisorProject/ProjectDetials.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppButtons.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppRoutes.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppSvg.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectDetails extends StatefulWidget {
  final String superId;
  final String studentLeaderId;
  final int requestId;

  const ProjectDetails(
      {Key? key,
      required this.superId,
      required this.studentLeaderId,
      required this.requestId})
      : super(key: key);

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  int selectTap = AppConstants.selectStudentFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBarMain(
          title: LocaleKeys.supervisorProject.tr(),
          radius: 20.r,
          high: 70.h,
        ),
        body: AppWidget.body(
            child: Container(
          margin: EdgeInsets.only(bottom: AppSize.bottomPageSize),
          child: Padding(
            padding: EdgeInsets.only(top: 20.w, left: 10.w, right: 10.w),
            child: Column(
              children: [
                selectSection(AppConstants.selectStudentFile)
              ],
            ),
          ),
        )));
  }

  Widget selectSection(int selectStudentFile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
//accept request========================================================================================
        AppButtons(
            onPressed: () {},
            text: LocaleKeys.accept.tr(),
            bagColor: AppColor.cherryLightPink,
            elevation: 2,
            width: 110.w),
        AppWidget.wSpace(10.w),
//reject request========================================================================================
        AppButtons(
            onPressed: () {},
            text: LocaleKeys.accept.tr(),
            bagColor: AppColor.cherryLightPink,
            elevation: 2,
            width: 110.w),
      ],
    );
  }
}
