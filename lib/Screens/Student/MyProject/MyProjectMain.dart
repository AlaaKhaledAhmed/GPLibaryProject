import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppButtons.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../Widget/AppBarMain.dart';
import '../../../Widget/AppSize.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentProjectScreen extends StatefulWidget {
  const StudentProjectScreen();

  @override
  State<StudentProjectScreen> createState() => _StudentProjectScreenState();
}

class _StudentProjectScreenState extends State<StudentProjectScreen> {
  String? selectedTab;
  int? tab;
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((c) async {
      setState(() {
        tab = 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tab == null) {
      selectedTab = (context.deviceLocale.toString() == 'en_EG'
          ? AppConstants.studentTabsMenuEn[0]
          : AppConstants.studentTabsMenuAr[0]);
    }
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
                                isEqualTo: AppConstants.typeIsSupervisor)
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
            itemCount: AppConstants.studentTabsMenuAr.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppButtons(
                  text: context.locale.toString() == 'en'
                      ? AppConstants.studentTabsMenuEn[index]
                      : AppConstants.studentTabsMenuAr[index],
                  onPressed: () {
                    setState(() {
                      selectedTab = (context.locale.toString() == 'en'
                          ? AppConstants.studentTabsMenuEn[index]
                          : AppConstants.studentTabsMenuAr[index]);
                      tab = index;
                    });
                  },
                  bagColor: selectedTab ==
                          (context.locale.toString() == 'en'
                              ? AppConstants.studentTabsMenuEn[index]
                              : AppConstants.studentTabsMenuAr[index])
                      ? AppColor.cherryLightPink
                      : AppColor.white,
                  textStyleColor: selectedTab ==
                          (context.locale.toString() == 'en'
                              ? AppConstants.studentTabsMenuEn[index]
                              : AppConstants.studentTabsMenuAr[index])
                      ? AppColor.white
                      : AppColor.black,
                  width: 120.w,
                ),
              );
            }),
      ),
    );
  }

//====================================================================================
  Widget body(BuildContext context, AsyncSnapshot snapshat) {
    return Text('data');
  }

}
