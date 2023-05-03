import 'package:flutter/material.dart';
import 'package:library_project/BackEnd/Database/DatabaseMethods.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppIcons.dart';
import 'package:library_project/Widget/AppLoading.dart';
import 'package:library_project/Widget/AppPopUpMen.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppSvg.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../BackEnd/Provider/ChangConstModel.dart';
import '../../../Widget/AppConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class RequestMain extends StatefulWidget {
  const RequestMain({Key? key}) : super(key: key);

  @override
  State<RequestMain> createState() => _RequestMainState();
}

class _RequestMainState extends State<RequestMain> {
  String? userId;

  String? studentData;

  String? resultCount;

  List supervisorsNames = [];

  var userCollection = FirebaseFirestore.instance
      .collection("users")
      .where('type', isEqualTo: AppConstants.supervisor);

  int iniFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(
          title: LocaleKeys.requests.tr(),
        ),
        body: Consumer<ChangConstModel>(builder: (context, model, child) {
          return SizedBox(
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
//search and filter=====================================================
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 15.h,
                      ),
                      height: 60.h,
                      width: AppWidget.getWidth(context),
                      //color: Colors.green,
                    ),
                    AppWidget.hSpace(10),

//body=====================================================
                    Container(
                      height: AppWidget.getHeight(context) * 0.55,
                      decoration: AppWidget.decoration(
                          radius: 10.r, color: AppColor.noColor),
                      width: AppWidget.getWidth(context),
                      child: body(1, 1),
                      // child: StreamBuilder(
                      //     stream: iniFilter == 1
                      //         ? userCollection
                      //         .where('major', isEqualTo: studentData)
                      //         .snapshots()
                      //         : iniFilter == 2
                      //         ? userCollection
                      //         .where('searchInterest',
                      //         isEqualTo: '$studentData')
                      //         .snapshots()
                      //         : userCollection.snapshots(),
                      //     builder: (context, AsyncSnapshot snapshot) {
                      //       if (snapshot.hasError) {
                      //         return const Center(
                      //             child: Text("Error check internet!"));
                      //       }
                      //       if (snapshot.hasData) {
                      //         return body(snapshot, model);
                      //       }
                      //
                      //       return const Center(
                      //           child: CircularProgressIndicator(
                      //             color: AppColor.appBarColor,
                      //           ));
                      //     }),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
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

//show data from database========================================================================
  Widget body(snapshot, model) {
    // return snapshot.data.docs.isNotEmpty
    //     ?
    return Container(
        height: AppWidget.getHeight(context) * 0.55,
        decoration: AppWidget.decoration(radius: 10.r, color: AppColor.noColor),
        width: AppWidget.getWidth(context),
        child: Container(
          height: AppWidget.getHeight(context) * 0.55,
          decoration:
              AppWidget.decoration(radius: 10.r, color: AppColor.noColor),
          width: AppWidget.getWidth(context),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              // snapshot.data.docs.length,
              itemBuilder: (context, i) {
                // var data = snapshot.data.docs[i].data();
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: SizedBox(
                    height: 200.h,
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
                            text: '{LocaleKeys.dr.tr()}: { data[name]}',
                            fontSize: AppSize.title2TextSize,
                          ),
                        ),
//search interest=================================================================
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text:
                                      '${LocaleKeys.searchInterestTx.tr()}: ' +
                                          AppWidget.getTranslateSearchInterest(
                                              ' data[searchInterest]'),
                                  fontSize: AppSize.subTextSize + 2,
                                ),
                                AppWidget.hSpace(8),
                                AppText(
                                  text:
                                      '${LocaleKeys.superVisorMajorTx.tr()}: ' +
                                          AppWidget.getTranslateMajor(
                                              ' data[major]'),
                                  fontSize: AppSize.subTextSize + 2,
                                ),
                                AppWidget.hSpace(8),
                                AppText(
                                  text: '${LocaleKeys.emailTx.tr()}:',
                                  fontSize: AppSize.subTextSize + 2,
                                ),
                                // AppWidget.hSpace(7),
                              ],
                            ),
                          ),
                        ),
//send icon=================================================================

                        onTap: () async {},
                      ),
                    ),
//==========================================================================
                  ),
                );
              }),
        ));
    //     : Center(
    //   child: AppText(
    //       text: LocaleKeys.noData.tr(),
    //       fontSize: AppSize.titleTextSize,
    //       fontWeight: FontWeight.bold),
    // );
  }
}
