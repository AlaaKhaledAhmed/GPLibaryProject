import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_project/BackEnd/Database/DatabaseMethods.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppIcons.dart';
import 'package:library_project/Widget/AppPopUpMen.dart';
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
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'dart:math' as math;

import 'SearchSupervisors.dart';

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
                        showFilter()
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
                            trailing: FittedBox(
                              child: Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(
                                      context.locale.toString() == 'en'
                                          ? 0
                                          : math.pi),
                                  child: FutureBuilder(
                                      future: getImage(
                                          stId: userId!, supId: data['userId']),
                                      builder: (context, AsyncSnapshot sn) {
                                        if (snapshot.hasError) {
                                          return const Center(child: Text("!"));
                                        }
                                        if (snapshot.hasData) {
                                          // print(sn.data);
                                          return SvgPicture.asset(
                                            sn.data ==
                                                    AppConstants.statusIsWaiting
                                                ? AppSvg.waitSvg
                                                : sn.data ==
                                                        AppConstants
                                                            .statusIsRejection
                                                    ? AppSvg.rejectFileSvg
                                                    : sn.data ==
                                                            AppConstants
                                                                .statusIsAcceptation
                                                        ? AppSvg.acceptFileSvg
                                                        : AppSvg.sendSvg,
                                            height: 40.r,
                                            width: 40.r,
                                          );
                                        }

                                        return const Center(
                                            child: CircularProgressIndicator(
                                          color: AppColor.appBarColor,
                                        ));
                                      }),
                                ),
                              ),
                            ),
                            onTap: () async {
                              await getImage(
                                          stId: userId!,
                                          supId: data['userId']) ==
                                      AppConstants.statusIsNotSendYet
                                  ? AppLoading.show(
                                      context,
                                      LocaleKeys.sendRequest.tr(),
                                      '${LocaleKeys.sendRequestTo.tr()} ' +
                                          data['name'],
                                      higth: 100.h,
                                      showButtom: true,
                                      noFunction: () => Navigator.pop(context),
                                      yesFunction: () async =>
                                          Database.studentSupervisionRequests(
                                                  context: context,
                                                  studentUid: userId!,
                                                  supervisorUid: data['userId'],
                                                  supervisorName: data['name'],
                                                  supervisorInterest:
                                                      data['searchInterest'],
                                                  studentName: await  Database.getDataViUserId(currentUserUid: userId!)

                                          )
                                              .then((v) {
                                        print('================$v');
                                        if (v == 'done') {
                                          setState(() {});
                                          Navigator.pop(context);
                                          AppLoading.show(
                                              context,
                                              LocaleKeys.mySuperVisor.tr(),
                                              LocaleKeys.done.tr());
                                        } else {
                                          Navigator.pop(context);
                                          AppLoading.show(
                                              context,
                                              LocaleKeys.mySuperVisor.tr(),
                                              LocaleKeys.error.tr());
                                        }
                                      }),
                                    )
                                  : AppLoading.show(
                                      context,
                                      LocaleKeys.sendRequest.tr(),
                                      LocaleKeys.canNotSend.tr());
                              setState(() {});
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

//=======================================================================
  getImage({required String stId, required String supId}) async {
    // print('stId:$stId');
    // print('supId:$supId');
    late int st = 0;
    await AppConstants.requestCollection
        .where('studentUid', isEqualTo: stId)
        .where('supervisorUid', isEqualTo: supId)
        .get()
        .then((getData) {
      for (QueryDocumentSnapshot element in getData.docs) {
        if (element.exists) {
          st = element['status'];
          // print('st: $st');
          // setState(() {});
        }
      }
    });

    return st;
  }

//Filter data=========================================================================
  showFilter() => Container(
        width: AppWidget.getWidth(context) * 0.14,
        height: double.infinity,
        decoration: AppWidget.decoration(radius: 10.r),
        child: Center(
          child: AppPopUpMen(
            menuList: [
              ///show all
              PopupMenuItem(
                onTap: ()=>print('all'),
                child: AppText(
                  text: LocaleKeys.all.tr(),
                  fontSize: AppSize.subTextSize,
                ),
              ),
              ///filter by searchInterest
              // PopupMenuItem(
              //   onTap: ()=>print('searchInterest'),
              //   child: AppText(
              //     text: LocaleKeys.searchInterestTx.tr(),
              //     fontSize: AppSize.subTextSize,
              //   ),
              // ),
              ///filter by major
              PopupMenuItem(
                onTap: ()=>print('majorTx'),
                child: AppText(
                  text: LocaleKeys.majorTx.tr(),
                  fontSize: AppSize.subTextSize,
                ),
              )
            ],
            icon: SvgPicture.asset(
              AppSvg.filterSvg,
              height: 30,
              width: 30,
            ),
          ),
        ),
      );
}
