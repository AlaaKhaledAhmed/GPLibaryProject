import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppIcons.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import '../../../BackEnd/Provider/ChangConstModel.dart';
import '../../../Widget/AppSize.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_project/Widget/AppSvg.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

class StudentSupervisor extends StatefulWidget {
  const StudentSupervisor();

  @override
  State<StudentSupervisor> createState() => _StudentSupervisorState();
}

class _StudentSupervisorState extends State<StudentSupervisor> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final supervisorList =
          Provider.of<ChangConstModel>(context, listen: false);
      supervisorList.getSupervisor();
      print('supervisorList.supervisorList: ${supervisorList.supervisorList}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(
          title: LocaleKeys.mySuperVisor.tr(),
        ),
        body: Container(
          // color: Colors.green,
          height: AppWidget.getHeight(context),
          width: AppWidget.getWidth(context),
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
                AppWidget.hSpace(10),
//body=====================================================
                body()
              ],
            ),
          ),
        ));
  }

//container decoration===============================================================
  BoxDecoration decoration({double? radius, Color? color}) {
    return BoxDecoration(
        color: color ?? AppColor.white,
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

//body========================================================================
  Widget body() {
    return Container(
            height: AppWidget.getHeight(context) * 0.55,
            decoration: decoration(radius: 10.r, color: AppColor.noColor),
            width: AppWidget.getWidth(context),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: SizedBox(
                      height: 120,
                      width: AppWidget.getWidth(context),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          //set border radius more than 50% of height and width to make circle
                        ),
//dr name=================================================================
                        child: ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(top: 30.h),
                            child: AppText(
                              text: 'Dr.Nada Ali',
                              fontSize: AppSize.title2TextSize,
                            ),
                          ),
//search interest=================================================================
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: AppText(
                              text: LocaleKeys.softwareDevelopment.tr(),
                              fontSize: AppSize.title2TextSize,
                            ),
                          ),
//send icon=================================================================
                          trailing: Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(
                                  context.locale.toString() == 'en'
                                      ? 0
                                      : math.pi),
                              child: SvgPicture.asset(
                                AppSvg.sendSvg,
                                height: 40.r,
                                width: 40.r,
                              ),
                            ),
                          ),
                        ),
//==========================================================================
                      ),
                    ),
                  );
                }),
          );
  }
}
