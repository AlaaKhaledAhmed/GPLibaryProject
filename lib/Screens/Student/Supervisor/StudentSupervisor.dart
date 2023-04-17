import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_project/BackEnd/Database/DatabaseMethods.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppIcons.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Widget/AppLoading.dart';
import '../../../Widget/AppSize.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_project/Widget/AppSvg.dart';
import 'dart:math' as math;

import '../../Superviser/SearchSupervisors.dart';

class StudentSupervisor extends StatefulWidget {
  const StudentSupervisor();

  @override
  State<StudentSupervisor> createState() => _StudentSupervisorState();
}

class _StudentSupervisorState extends State<StudentSupervisor> {
  String? userId;
  List supervisorsNames = [];
  var userCollection = FirebaseFirestore.instance
      .collection("users")
      .where('type', isEqualTo: 'supervisor');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;

    userCollection.get().then((value) {
      for (var element in value.docs) {
        setState(() {
          //يضيف الاسما
          supervisorsNames.add(element['name']);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(
          title: LocaleKeys.mySuperVisor.tr(),
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
                        InkWell(
                          onTap: () => showSearch(
                              context: context,
                              delegate: SearchSupervisors(
                                  supervisorsNamesList: supervisorsNames,
                                  context: context,
                                  userId: userId!,
                                  local: context.locale)),
                          child: Container(
                            height: double.infinity,
                            width: AppWidget.getWidth(context) * 0.75,
                            decoration: AppWidget.decoration(),
                            child: rowData(),
                          ),
                        ),
                        Container(
                          width: AppWidget.getWidth(context) * 0.14,
                          height: double.infinity,
                          decoration: AppWidget.decoration(radius: 10.r),
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
                  Container(
                    height: AppWidget.getHeight(context) * 0.55,
                    decoration: AppWidget.decoration(
                        radius: 10.r, color: AppColor.noColor),
                    width: AppWidget.getWidth(context),
                    child: StreamBuilder(
                        stream: userCollection.snapshots(),
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
  Widget body(snapshot) {
    return Container(
      height: AppWidget.getHeight(context) * 0.55,
      decoration: AppWidget.decoration(radius: 10.r, color: AppColor.noColor),
      width: AppWidget.getWidth(context),
      child: snapshot.data.docs.length >= 0
          ? Container(
              height: AppWidget.getHeight(context) * 0.55,
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
                                text: data['name'],
                                fontSize: AppSize.title2TextSize,
                              ),
                            ),
//search interest=================================================================
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: AppText(
                                text: AppWidget.getTranslate(
                                    data['searchInterest']),
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
                            onTap: () {
                              AppLoading.show(
                                context,
                                'Send',
                                'send request to ' + data['name'],
                                higth: 100.h,
                                showButtom: true,
                                noFunction: () => Navigator.pop(context),
                                yesFunction: () => Database.getDataViUserId(
                                  uId:userId!,
                                    userType: AppConstants.student,
                                    // context: context,
                                    // stId: userId!,
                                    // supervisorId: data['userId']
                                ),
                              );
                            },
                          ),
                        ),
//==========================================================================
                      ),
                    );
                  }),
            )
          : Center(
              child: Padding(
                  padding:
                      EdgeInsets.only(top: AppWidget.getHeight(context) / 2),
                  child: AppText(
                      text: LocaleKeys.noData.tr(),
                      fontSize: AppSize.titleTextSize,
                      fontWeight: FontWeight.bold)),
            ),
    );
  }

//============================================================================================

}
