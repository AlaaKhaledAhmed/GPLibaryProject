import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppIcons.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import '../../../Widget/AppSize.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_project/Widget/AppSvg.dart';

class StudentSupervisor extends StatefulWidget {
  const StudentSupervisor();

  @override
  State<StudentSupervisor> createState() => _StudentSupervisorState();
}

class _StudentSupervisorState extends State<StudentSupervisor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(
          title: LocaleKeys.mySuperVisor.tr(),
        ),
        body: AppWidget.body(
            child: Container(
          margin: EdgeInsets.only(bottom: AppSize.bottomPageSize),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
            ),
            child: Column(
              children: [
//search and filter=====================================================
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 15.h,
                  ),
                  height: 60.h,
                  width: AppWidget.getWidth(context),
                  //color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: double.infinity,
                        width: AppWidget.getWidth(context) * 0.75,
                        decoration: decoration(),
                        child: rowData(),
                      ),
                      Container(
                        width: AppWidget.getWidth(context) * 0.14,
                        height: double.infinity,
                        decoration: decoration(radius: 10.r),
                        child: Center(
                          child: SvgPicture.asset(
                            AppSvg.filterSvg,
                            height: 30,
                            width: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )));
  }

//container decoration===============================================================
  BoxDecoration decoration({double? radius}) {
    return BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 20.r)));
  }

//search box===============================================================
  Widget rowData() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.r),
          child: Icon(AppIcons.search),
        ),
        AppText(text: LocaleKeys.search.tr(), fontSize: AppSize.subTextSize)
      ],
    );
  }
}
