import 'package:flutter/material.dart';
import 'package:library_project/BackEnd/Database/DatabaseMethods.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppButtons.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppSvg.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupervisorProjectScreen extends StatefulWidget {
  const SupervisorProjectScreen({Key? key}) : super(key: key);

  @override
  State<SupervisorProjectScreen> createState() =>
      _SupervisorProjectScreenState();
}

class _SupervisorProjectScreenState extends State<SupervisorProjectScreen> {
  String? userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = AppWidget.getUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(
          title: LocaleKeys.supervisorProject.tr(),
        ),
        body: SizedBox(
          // color: Colors.green,
          height: AppWidget.getHeight(context),
          width: AppWidget.getWidth(context),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppWidget.hSpace(20.h),

//body====================================================================
                  Container(
                    height: AppWidget.getHeight(context) * 0.80,
                    decoration: AppWidget.decoration(
                        radius: 10.r, color: AppColor.noColor),
                    width: AppWidget.getWidth(context),
                    child: StreamBuilder(
                        stream: AppConstants.requestCollection
                            .where('supervisorUid', isEqualTo: userId)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text("Error check internet!"));
                          }
                          if (snapshot.hasData) {
                            return body(snapshot);
                          }

                          return const Center(
                              child: CircularProgressIndicator(
                            color: AppColor.appBarColor,
                          ));
                        }),
                  )
                ],
              ),
            ),
          ),
        ));
  }

//show data from database========================================================================
  Widget body(snapshot) {
    return snapshot.data.docs.isNotEmpty
        ? Container(
            //  height: AppWidget.getHeight(context) * 0.55,
            decoration:
                AppWidget.decoration(radius: 10.r, color: AppColor.noColor),
            width: AppWidget.getWidth(context),
            child: Container(
              // height: AppWidget.getHeight(context) * 0.55,
              decoration:
                  AppWidget.decoration(radius: 10.r, color: AppColor.noColor),
              width: AppWidget.getWidth(context),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, i) {
                    var data = snapshot.data.docs[i].data();
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: SizedBox(
                        height: 230.h,
                        width: AppWidget.getWidth(context),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            //set border radius more than 50% of height and width to make circle
                          ),
//student name=================================================================
                          child: ListTile(
                            title: Padding(
                              padding: EdgeInsets.only(top: 30.h),
                              child: AppText(
                                text:
                                    '${LocaleKeys.leaderName.tr()}: ${data['studentName']} ',
                                fontSize: AppSize.title2TextSize,
                              ),
                            ),
//project Description=================================================================
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppWidget.hSpace(8.h),
                                  AppText(
                                    text:
                                        '${LocaleKeys.projectDescription.tr()}:',
                                    fontSize: AppSize.subTextSize + 2,
                                  ),
                                  Container(
                                    decoration: AppWidget.decoration(
                                        radius: 10.r,
                                        color: AppColor.cherryLightPink),
                                    margin:EdgeInsets.symmetric(vertical: 10.h),
                                    padding: const EdgeInsets.all(10),
                                    child: AppText(
                                      text:
                                          "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",
                                      fontSize: AppSize.subTextSize + 2,
                                    ),
                                  )

                                  // AppWidget.hSpace(7),
                                ],
                              ),
                            ),
                          ),
                        ),
//==========================================================================
                      ),
                    );
                  }),
            ))
        : Center(
            child: AppText(
                text: LocaleKeys.noData.tr(),
                align: TextAlign.center,
                fontSize: AppSize.titleTextSize,
                fontWeight: FontWeight.bold),
          );
  }
}
