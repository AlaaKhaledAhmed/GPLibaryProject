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
import '../../../BackEnd/Provider/ChangConstModel.dart';
import '../../../Widget/AppLoading.dart';
import '../../../Widget/AppSize.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_project/Widget/AppSvg.dart';
import 'dart:math' as math;
import 'SearchSupervisors.dart';
import 'package:provider/provider.dart';

class StudentSupervisor extends StatefulWidget {
  const StudentSupervisor({Key? key}) : super(key: key);

  @override
  State<StudentSupervisor> createState() => _StudentSupervisorState();
}

class _StudentSupervisorState extends State<StudentSupervisor> {
  String? userId;
  String? studentData;
  int?resultCount;
  List supervisorsNames = [];
  var userCollection = FirebaseFirestore.instance
      .collection("users")
      .where('type', isEqualTo: AppConstants.supervisor);
  int iniFilter = 0;

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
                          showFilter(model)
                        ],
                      ),
                    ),
                    AppWidget.hSpace(10),
//search and filter=====================================================
                    resultCount!=null?
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(text: LocaleKeys.results.tr(), fontSize: AppSize.title2TextSize,color: AppColor.iconColor,),
                          AppText(text: '$resultCount', fontSize: AppSize.title2TextSize,color: AppColor.iconColor,)

                        ],
                      ),
                    ):const SizedBox(),
                    AppWidget.hSpace(15),
//body=====================================================
                    Container(
                      height: AppWidget.getHeight(context) * 0.55,
                      decoration: AppWidget.decoration(
                          radius: 10.r, color: AppColor.noColor),
                      width: AppWidget.getWidth(context),
                      child: StreamBuilder(
                          stream: iniFilter == 1
                              ? userCollection
                                  .where('major', isEqualTo: studentData)
                                  .snapshots()
                              : iniFilter == 2
                                  ? userCollection
                                      .where('searchInterest',
                                          isEqualTo: '$studentData')
                                      .snapshots()
                                  : userCollection.snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text("Error check internet!"));
                            }
                            if (snapshot.hasData) {
                              return body(snapshot, model);
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
    resultCount=snapshot.data.docs.length;
    return snapshot.data.docs.isNotEmpty
        ? Container(
            height: AppWidget.getHeight(context) * 0.55,
            decoration:
                AppWidget.decoration(radius: 10.r, color: AppColor.noColor),
            width: AppWidget.getWidth(context),
            child: Container(
              height: AppWidget.getHeight(context) * 0.55,
              decoration:
                  AppWidget.decoration(radius: 10.r, color: AppColor.noColor),
              width: AppWidget.getWidth(context),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: resultCount,
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
                                text: AppWidget.getTranslateSearchInterest(
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
                                      future: getStatus(
                                          stId: userId!, supId: data['userId']),
                                      builder: (context, AsyncSnapshot sn) {
                                        if (sn.hasError) {
                                          return const Center(child: Text("!"));
                                        }
                                        if (sn.hasData) {
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
                              await getStatus(
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
                                                  studentName: await Database
                                                      .getDataViUserId(
                                                          currentUserUid:
                                                              userId!))
                                              .then((v) {
                                        print('================$v');
                                        if (v == 'done') {
                                          model.refreshPage();
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
                fontSize: AppSize.titleTextSize,
                fontWeight: FontWeight.bold),
          );
  }

//get Status of student request=======================================================================
  getStatus({required String stId, required String supId}) async {
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
        }
      }
    });

    return st;
  }

//Filter data=========================================================================
  showFilter(model) => Container(
        width: AppWidget.getWidth(context) * 0.14,
        height: double.infinity,
        decoration: AppWidget.decoration(radius: 10.r),
        child: Center(
          child: AppPopUpMen(
            menuList: [
              ///show all
              PopupMenuItem(
                onTap: () {
                  iniFilter = 0;
                  model.refreshPage();
                  print('iniFilter:$iniFilter');
                },
                child: AppText(
                  text: LocaleKeys.all.tr(),
                  fontSize: AppSize.subTextSize,
                ),
              ),

              ///filter by major
              PopupMenuItem(
                onTap: () async {
                  await getStudentMajor(filterBy: AppConstants.filterByMajor);
                  iniFilter = 1;
                  model.refreshPage();
                  print('iniFilter:$iniFilter');
                },
                child: AppText(
                  text: LocaleKeys.majorTx.tr(),
                  fontSize: AppSize.subTextSize,
                ),
              ),

              ///filter by search Interest
              PopupMenuItem(
                onTap: () async {
                  await getStudentMajor(filterBy: null);
                  iniFilter = 2;
                  model.refreshPage();
                  print('iniFilter:$iniFilter');
                },
                child: AppText(
                  text: LocaleKeys.searchInterestTx.tr(),
                  fontSize: AppSize.subTextSize,
                ),
              ),
            ],
            icon: SvgPicture.asset(
              AppSvg.filterSvg,
              height: 30,
              width: 30,
            ),
          ),
        ),
      );
//get Student major===================================================================================================
  Future<void> getStudentMajor({required filterBy}) async {
    var c = await AppConstants.userCollection
        .where('userId', isEqualTo: userId!)
        .get();
    c.docs.forEach((element) {
      if (element.exists) {
        if (filterBy != null) {
          studentData = element['major'];
          print('studentMajor: $studentData');
        } else {
          studentData = element['searchInterest'];
          print('studentSearchInterest: $studentData');
        }
      }
    });
  }
}
