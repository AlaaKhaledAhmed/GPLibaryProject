import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_project/BackEnd/Database/DatabaseMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_project/Screens/Student/MyProject/ViewProject.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppLoading.dart';
import 'package:library_project/Widget/AppRoutes.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../MyProject/DawonlodeProject.dart';
import 'CommentPage.dart';

class StudentHome extends StatefulWidget {
  const StudentHome();

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  String? userId;
  String? name;
  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    Future.delayed(Duration.zero, () async {
      await getName(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(
        title: LocaleKeys.home.tr(),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: AppConstants.projectCollection
                .where("status", isEqualTo: AppConstants.statusIsComplete)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshat) {
              if (snapshat.hasError) {
                return Center(child: Text('${snapshat.error}'));
              }
              if (snapshat.hasData) {
                return body(context, snapshat);
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  Widget body(context, snapshat) {
    print('name: $name');
    return snapshat.data.docs.length > 0
        ? Expanded(
            child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ListView.builder(
                  itemCount: snapshat.data.docs.length,
                  itemBuilder: (context, i) {
                    var data = snapshat.data.docs[i].data();
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 20.h),
                      height: 250.h,
                      child: Card(
                          color: AppColor.white,
                          elevation: 5,
                          child: ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20.h),
                                Expanded(
                                    child: AppText(
                                  fontSize: AppSize.subTextSize,
                                  text: LocaleKeys.projectName.tr() +
                                      ": ${data['name']}",
                                  color: AppColor.appBarColor,
                                )),
                                Expanded(
                                    child: AppText(
                                  fontSize: AppSize.subTextSize,
                                  text: LocaleKeys.year.tr() +
                                      ": ${data['year']}",
                                  color: AppColor.appBarColor,
                                )),
                                Expanded(
                                    child: AppText(
                                  fontSize: AppSize.subTextSize,
                                  text:
                                      '${LocaleKeys.superVisorMajorTx.tr()}: ' +
                                          AppWidget.getTranslateMajor(
                                              data['major']),
                                  color: AppColor.appBarColor,
                                )),
                                Expanded(
                                    child: AppText(
                                  fontSize: AppSize.subTextSize,
                                  text: LocaleKeys.searchInterestTx.tr() +
                                      ": ${AppWidget.getTranslateSearchInterest(data['searchInterest'])}",
                                  color: AppColor.appBarColor,
                                )),
                                Expanded(
                                    child: AppText(
                                  fontSize: AppSize.subTextSize,
                                  text: LocaleKeys.mySuperVisor.tr() +
                                      ": ${data['superName']}",
                                  color: AppColor.appBarColor,
                                )),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
//view comment---------------------------------------------------------------------------------

                                    IconButton(
                                        onPressed: () {
                                          AppRoutes.pushTo(
                                              context,
                                              CommentPage(
                                                name: name!,
                                                projectId: data['projectId'],
                                                userId: userId!,
                                              ));
                                        },
                                        icon: const Icon(Icons.comment)),
//view file---------------------------------------------------------------------------------
                                    IconButton(
                                        onPressed: () async {
                                          AppLoading.show(context, "", "lode");
                                          final file =
                                              await Database.lodeFirbase(
                                                      data['fileName'])
                                                  .whenComplete(() {
                                            Navigator.pop(context);
                                          });
                                          // ignore: unnecessary_null_comparison
                                          if (file == null) return;
                                          AppRoutes.pushTo(
                                              context,
                                              ViewPdf(
                                                file: file,
                                                fileName: data['fileName'],
                                                link: data['link'],
                                              ));
                                        },
                                        icon: const Icon(
                                            Icons.view_carousel_sharp)),
//dwonlode file---------------------------------------------------------------------------------
                                    IconButton(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                DownloadingDialog(
                                              fileName: data['fileName'],
                                              url: data['link'],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.download)),
//-----------------------------------------------------------------------------------------------
                                  ],
                                )),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          )),
                    );
                  }),
            ),
          ))
        : Center(
            child: Padding(
              padding: EdgeInsets.only(top: AppWidget.getHeight(context) / 3),
              child: AppText(
                  text: LocaleKeys.noData.tr(),
                  fontSize: AppSize.subTextSize,
                  fontWeight: FontWeight.bold),
            ),
          );
  }
//==========================================================================================
  //================delete Information============================================================
  // Widget deleteInformation(i, String id, snapshat, Widget child) {
  //   return Dismissible(
  //     direction: DismissDirection.startToEnd,
  //     secondaryBackground: Container(),
  //     background: Container(
  //       color: Colors.red,
  //       child: Padding(
  //         padding: EdgeInsets.all(15.h),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Padding(
  //               padding:
  //                   EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 5.h),
  //               child: Icon(Icons.delete, color: Colors.white, size: 36.sp),
  //             ),
  //             text(context, deleteData, bottomSize, white,
  //                 fontWeight: FontWeight.bold)
  //           ],
  //         ),
  //       ),
  //     ),
  //     confirmDismiss: (DismissDirection direction) async {
  //       return showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: text(
  //               context,
  //               deleteData,
  //               bottomSize,
  //               black,
  //               fontWeight: FontWeight.bold,
  //               align: TextAlign.center,
  //             ),
  //             content: text(context, confirmDelete, bottomSize, Colors.grey,
  //                 fontWeight: FontWeight.bold, align: TextAlign.right),
  //             actions: [
  //               FlatButton(
  //                 onPressed: () async {
  //                   Navigator.of(context).pop(true);

  //                   Firbase.delete(docId: id, collection: 'project')
  //                       .then((String v) {
  //                     if (v == 'done') {
  //                       Navigator.of(context).pop();
  //                     } else {
  //                       Navigator.of(context).pop();
  //                     }
  //                   });
  //                 },
  //                 child: text(context, 'نعم', bottomSize, red!,
  //                     fontWeight: FontWeight.bold, align: TextAlign.center),
  //               ),
  //               FlatButton(
  //                 onPressed: () => Navigator.of(context).pop(false),
  //                 child: text(context, 'لا', bottomSize, black,
  //                     fontWeight: FontWeight.bold, align: TextAlign.center),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //     key: UniqueKey(),
  //     child: child,
  //   );
  // }

//get user name===============================================
  Future<void> getName(String? userId) async {
    FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        name = element.data()['name'];
        setState(() {});
      }
    });
  }
}
