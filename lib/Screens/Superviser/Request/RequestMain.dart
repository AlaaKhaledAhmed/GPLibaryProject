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

class RequestMain extends StatefulWidget {
  const RequestMain({Key? key}) : super(key: key);

  @override
  State<RequestMain> createState() => _RequestMainState();
}

class _RequestMainState extends State<RequestMain> {
  String? userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = AppWidget.getUid();
  }

  @override
  Widget build(BuildContext context) {
    print('iddddddd: $userId');
    return Scaffold(
        appBar: AppBarMain(
          title: LocaleKeys.requests.tr(),
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
                        height: 280.h,
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
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColor.cherryLightPink),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.r)),
                                    ),
                                    height: 120.h,
                                    width: double.infinity,
                                    child: SingleChildScrollView(
                                      child: AppText(
                                        text: ' ${data['description']}',
                                        fontSize: AppSize.subTextSize + 2,
                                      ),
                                    ),
                                  ),
                                  AppWidget.hSpace(10.h),
                                  Row(
                                    children: [
//accept request========================================================================================
                                      AppButtons(
                                          onPressed: data['status'] ==
                                                      AppConstants
                                                          .statusIsRejection ||
                                                  data['status'] ==
                                                      AppConstants
                                                          .statusIsAcceptation
                                              ? null
                                              : () => Database.updateRequestStatus(
                                                    docId: snapshot
                                                        .data.docs[i].id,
                                                    status: AppConstants
                                                        .statusIsAcceptation,
                                                    isAccept: true,
                                                  ),
                                          text: LocaleKeys.accept.tr(),
                                          bagColor: AppColor.cherryLightPink,
                                          elevation: 2,
                                          width: 110.w),
                                      AppWidget.wSpace(10.w),
//reject request========================================================================================
                                      AppButtons(
                                          onPressed: data['status'] ==
                                                      AppConstants
                                                          .statusIsRejection ||
                                                  data['status'] ==
                                                      AppConstants
                                                          .statusIsAcceptation
                                              ? null
                                              : () => Database.updateRequestStatus(
                                                    docId: snapshot
                                                        .data.docs[i].id,
                                                    status: AppConstants
                                                        .statusIsRejection,
                                                    isAccept: false,
                                                  ),
                                          text: LocaleKeys.reject.tr(),
                                          textStyleColor: data['status'] ==
                                                      AppConstants
                                                          .statusIsRejection ||
                                                  data['status'] ==
                                                      AppConstants
                                                          .statusIsAcceptation
                                              ? AppColor.white
                                              : AppColor.cherry,
                                          bagColor: AppColor.white,
                                          elevation: 1,
                                          width: 110.w),
                                    ],
                                  )

                                  // AppWidget.hSpace(7),
                                ],
                              ),
                            ),
//status=================================================================
                            trailing: SvgPicture.asset(
                              data['status'] == AppConstants.statusIsAcceptation
                                  ? AppSvg.acceptFileSvg
                                  : data['status'] ==
                                          AppConstants.statusIsRejection
                                      ? AppSvg.rejectFileSvg
                                      : AppSvg.waitSvg,
                              height: 50.r,
                              width: 50.r,
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
                fontSize: AppSize.subTextSize,
                fontWeight: FontWeight.bold),
          );
  }
}
