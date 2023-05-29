import 'dart:io';

import 'package:flutter/material.dart';
import 'package:library_project/BackEnd/Database/DatabaseMethods.dart';
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppButtons.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppRoutes.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Widget/AppLoading.dart';
import '../../Student/MyProject/UpdateProject.dart';
import '../../Student/MyProject/ViewProject.dart';

class ProjectDetails extends StatefulWidget {
  final String superId;
  final String studentLeaderId;
  final int requestId;

  const ProjectDetails(
      {Key? key,
      required this.superId,
      required this.studentLeaderId,
      required this.requestId})
      : super(key: key);

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  String? selectedTab;
  int? tab;
  Reference? fileRef;
  String? selectedMajor;
  String? selectedSearch;
  String? section;
  String? fileURL;
  File? file;
  String? userId;
  List<String> projectData = [];
  bool? isFoundSupervisor;
  bool check2 = false;
  @override
  void initState() {
    super.initState();
    tab = 0;
    userId = FirebaseAuth.instance.currentUser!.uid;
    Future.delayed(Duration.zero, () async {
      await getMajorAndSearch();
      await getSuperName();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('projectData: $projectData');
    print('isFoundSupervisor: $isFoundSupervisor');
    return Scaffold(
      appBar: AppBarMain(
        title: LocaleKeys.myProject.tr(),
      ),
      body: AppWidget.body(
        child: Container(
          margin: EdgeInsets.only(bottom: AppSize.bottomPageSize),
          child: Column(
            children: [
              showTabs(),
              StreamBuilder(
                stream: tab == 0
                    ? AppConstants.projectCollection
                        .where("status",
                            isEqualTo: AppConstants.statusIsComplete)
                        .snapshots()
                    : tab == 1
                        ? AppConstants.projectCollection
                            .where("status",
                                isEqualTo: AppConstants.statusIsUnComplete)
                            .snapshots()
                        : AppConstants.projectCollection
                            .where("from",
                                isEqualTo: AppConstants.typeIsStudent)
                            .snapshots(),
                builder: (context, AsyncSnapshot snapshat) {
                  if (snapshat.hasError) {
                    return Center(child: Text('${snapshat.error}'));
                  }
                  if (snapshat.hasData) {
                    return tab == 0
                        ? getCompletedProject(context, snapshat)
                        : tab == 1
                            ? getUnCompletedProject(context, snapshat)
                            : getStudentFile(context, snapshat);
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

//Tabs=================================================================
  Widget showTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: SizedBox(
        height: 60.h,
        width: double.infinity,
        child: ListView.builder(
            itemCount: AppConstants.superTabsMenu.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: AppButtons(
                  text: context.locale.toString() == 'en'
                      ? AppConstants.superTabsMenu[index]
                      : AppConstants.superTabsMenu[index],
                  onPressed: () {
                    setState(() {
                      tab = index;
                    });
                  },
                  bagColor:
                      tab == index ? AppColor.cherryLightPink : AppColor.white,
                  textStyleColor:
                      tab == index ? AppColor.white : AppColor.black,
                  width: 160.w,
                ),
              );
            }),
      ),
    );
  }

//====================================================================================
  Widget getCompletedProject(context, snapshat) {
    return snapshat.data.docs.length > 0
        ? Expanded(
            child: SizedBox(
            width: double.infinity,
            height: 150.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ListView.builder(
                  itemCount: snapshat.data.docs.length,
                  itemBuilder: (context, i) {
                    var data = snapshat.data.docs[i].data();
                    return InkWell(
                      onTap: () async {
                        AppLoading.show(context, "", "lode");
                        final file =
                            await Database.lodeFirbase(data['fileName'])
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
                      child: Container(
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
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            )),
                      ),
                    );
                  }),
            ),
          ))
        : Center(
            child: Padding(
              padding: EdgeInsets.only(top: AppWidget.getHeight(context) / 4),
              child: AppText(
                text: LocaleKeys.noData.tr(),
                fontSize: AppSize.subTextSize,
              ),
            ),
          );
  }

//======================================================================
  Widget getStudentFile(BuildContext context, AsyncSnapshot snapshat) {
    return snapshat.data.docs.length > 0
        ? Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 45.h,
                  child: Transform.translate(
                    offset: Offset(12.w, 0),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: AppText(
                        fontSize: AppSize.subTextSize,
                        text: LocaleKeys.complete.tr(),
                        color: AppColor.appBarColor,
                      ),
                      value: check2,
                      selectedTileColor: AppColor.black,
                      onChanged: (value) {
                        check2 == false
                            ? AppLoading.show(
                                context,
                                LocaleKeys.myProject.tr(),
                                LocaleKeys.complete.tr() +
                                    (context.locale.toString() == 'en'
                                        ? "?"
                                        : "؟"),
                                higth: 100.h,
                                noFunction: () => Navigator.pop(context),
                                yesFunction: () => setProjectComplete(value),
                                showButtom: true)
                            : {check2 = value!, setState(() {})};
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: SizedBox(
                  width: double.infinity,
                  height: 150.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: ListView.builder(
                        itemCount: snapshat.data.docs.length,
                        itemBuilder: (context, i) {
                          var data = snapshat.data.docs[i].data();
                          return InkWell(
                            onTap: () async {
                              AppLoading.show(context, "", "lode");
                              final file =
                                  await Database.lodeFirbase(data['fileName'])
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
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 20.h),
                              height: 250.h,
                              child: Card(
                                  color: AppColor.white,
                                  elevation: 5,
                                  child: ListTile(
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          text: LocaleKeys.searchInterestTx
                                                  .tr() +
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
                                        SizedBox(height: 20.h),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        }),
                  ),
                )),
              ],
            ),
          )
        : Center(
            child: Padding(
                padding: EdgeInsets.only(top: AppWidget.getHeight(context) / 4),
                child: AppText(
                    text: LocaleKeys.noData.tr(),
                    fontSize: AppSize.subTextSize)),
          );
  }

//======================================================================
  Widget getUnCompletedProject(BuildContext context, AsyncSnapshot snapshat) {
    return snapshat.data.docs.length > 0
        ? Expanded(
            child: SizedBox(
            width: double.infinity,
            height: 150.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ListView.builder(
                  itemCount: snapshat.data.docs.length,
                  itemBuilder: (context, i) {
                    var data = snapshat.data.docs[i].data();
                    return InkWell(
                      onTap: () {
                        AppRoutes.pushTo(
                            context,
                            UpdateProject(
                              status: AppConstants.statusIsUnComplete,
                              dateController: data['year'],
                              docId: snapshat.data.docs[i].id,
                              nameController: data['name'],
                              selectedMajor:
                                  AppWidget.getTranslateMajor(data['major']),
                              selectedSearch:
                                  AppWidget.getTranslateSearchInterest(
                                      data['searchInterest']),
                              superNameController: data['superName'],
                              fileName: data['fileName'],
                              fileURL: data['link'],
                            ));
                      },
                      child: Container(
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
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            )),
                      ),
                    );
                  }),
            ),
          ))
        : Center(
            child: Padding(
              padding: EdgeInsets.only(top: AppWidget.getHeight(context) / 4),
              child: InkWell(
                onTap: () {
                  setState(() {
                    getFile(context).whenComplete(() {
                      print('fillllllllllllle:${file!.path}');

                      AppLoading.show(
                          context,
                          LocaleKeys.attachFile.tr(),
                          LocaleKeys.attachFile.tr() +
                              (context.locale.toString() == 'en' ? "?" : "؟"),
                          higth: 100.h,
                          noFunction: () => Navigator.pop(context),
                          yesFunction: () => uploadedFileFromDevice(
                              fileName: path.basename(file!.path)),
                          showButtom: true);
                    });
                  });
                },
                child: AppText(
                  text: LocaleKeys.attachFile.tr(),
                  fontSize: AppSize.title2TextSize,
                ),
              ),
            ),
          );
  }

//show file picker=========================================
  Future getFile(context) async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf']);
    if (pickedFile == null) {
      return null;
    }
    setState(() {
      file = File(pickedFile.paths.first!);
    });
  }

//===============================================================
  uploadedFileFromDevice({required String fileName}) async {
    AppLoading.show(context, '', 'lode');
    FocusManager.instance.primaryFocus?.unfocus();
    fileRef = FirebaseStorage.instance.ref('project').child(fileName);
    await fileRef?.putFile(file!).then((getValue) async {
      Navigator.pop(context);
      fileURL = await fileRef!.getDownloadURL();
      Database.addProject(
        status: AppConstants.statusIsUnComplete,
        name: 'projectName',
        year:
            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
        link: fileURL!,
        fileName: fileName,
        from: AppConstants.typeIsSupervisor,
        superName: projectData[2],
        major: AppWidget.setEnTranslateMajor(projectData[0]),
        searchInterest: AppWidget.setEnTranslateSearchInterest(projectData[1]),
      ).then((String v) {
        print('================$v');
        if (v == "done") {
          Navigator.pop(context);
          AppLoading.show(
              context, LocaleKeys.update.tr(), LocaleKeys.done.tr());
        } else {
          Navigator.pop(context);
          AppLoading.show(
              context, LocaleKeys.update.tr(), LocaleKeys.error.tr());
        }
      });
    });
  }

//get Major And Search=================================================================================================
  Future<void> getMajorAndSearch() async {
    await AppConstants.userCollection
        .where("userId", isEqualTo: userId!)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        projectData.insert(
            0, AppWidget.getTranslateMajor("${element["major"]}"));
        projectData.insert(
            1,
            AppWidget.getTranslateSearchInterest(
                "${element["searchInterest"]}"));
        setState(() {});
      });
    });
  }

  //get Super Name==============================================================
  Future<void> getSuperName() async {
    await AppConstants.requestCollection
        .where("supervisorUid", isEqualTo: userId!)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.exists) {
          projectData.insert(2, "${element["supervisorName"]}");
          print('existsexistsexists');
          isFoundSupervisor = true;
          setState(() {});
        } else {
          isFoundSupervisor = false;
          print('nnnnnnnnnot exists');
          setState(() {});
        }
      });
    });
  }

  //=============================================================================
  setProjectComplete(bool? value) {
    //Database.updateStouts(docId: 'docId');
    Navigator.pop(context);
    check2 = value!;
    setState(() {});
  }
}
