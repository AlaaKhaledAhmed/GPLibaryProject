import 'package:flutter/material.dart';
import 'package:library_project/Screens/Superviser/SupervisorProject/ProjectDetials.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppRoutes.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                            .where('status', whereIn: [
                          AppConstants.statusIsAcceptation,
                          AppConstants.statusIsComplete
                        ]).snapshots(),
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
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.cherryLightPink,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.r)),
                                    ),
                                    height: 120.h,
                                    padding: EdgeInsets.all(10.r),
                                    width: double.infinity,
                                    child: SingleChildScrollView(
                                      child: AppText(
                                        text: ' ${data['description']}',
                                        fontSize: AppSize.subTextSize + 2,
                                        color: AppColor.white,
                                      ),
                                    ),
                                  )

                                  // AppWidget.hSpace(7),
                                ],
                              ),
                            ),
                            onTap: () {
                              AppRoutes.pushTo(
                                  context,
                                  ProjectDetails(
                                      description: data['description'],
                                      isAccept: data['isAccept'],
                                      projectName: data['projectName'],
                                      requestId: data['requestId'],
                                      status: data['status'],
                                      studentName: data['studentName'],
                                      studentUid: data['studentUid'],
                                      supervisorInterest:
                                          data['supervisorInterest'],
                                      supervisorName: data['supervisorName'],
                                      supervisorUid: data['supervisorUid'],
                                      docId: snapshot.data.docs[i].id));
                            },
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
                fontSize: AppSize.subTextSize,
                fontWeight: FontWeight.bold),
          );
  }
}
