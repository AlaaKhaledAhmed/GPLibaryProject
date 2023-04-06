import 'package:flutter/material.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:library_project/Widget/AppIcons.dart';
import 'package:library_project/Widget/AppSvg.dart';
import '../../Widget/AppRoutes.dart';
import '../Accounts/Login.dart';
import 'MyProject/MyProjectMain.dart';
import 'MyTeam/MyTeamMain.dart';
import 'StudentHome/StudentHome.dart';
import 'Supervisor/StudentSupervisor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavStudent extends StatefulWidget {
  const NavStudent({Key? key}) : super(key: key);

  @override
  State<NavStudent> createState() => _NavStudentState();
}

class _NavStudentState extends State<NavStudent> {
  int selectedIndex = 0;
  PageController? pageController;
  List<Widget> page = const [
    StudentHome(),
    MyProjectMain(),
    StudentSupervisor(),
    MyTeamMain()
  ];
  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: page,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        bottomBarItems: [
//home================================================================
          AppWidget.bottomBarItems(
              coloerSvg: AppSvg.homeColor,
              noColoerSvg: AppSvg.homeNoColor,
              title: LocaleKeys.home.tr(),
              onTap: () => onTabTapped(0)),
//project================================================================
          AppWidget.bottomBarItems(
              coloerSvg: AppSvg.myProjectColor,
              noColoerSvg: AppSvg.myProjectNoColor,
              title: LocaleKeys.myProject.tr(),
              onTap: () => onTabTapped(1)),
//Supervisor================================================================
          AppWidget.bottomBarItems(
              coloerSvg: AppSvg.supervisorColor,
              noColoerSvg: AppSvg.supervisorNoColor,
              title: LocaleKeys.mySuperVisor.tr(),
              onTap: () => onTabTapped(2)),

//team================================================================
          AppWidget.bottomBarItems(
              coloerSvg: AppSvg.temColor,
              noColoerSvg: AppSvg.temNoColor,
              title: LocaleKeys.myTeam.tr(),
              onTap: () => onTabTapped(3)),
        ],
//================================================================
        bottomBarCenterModel: BottomBarCenterModel(
          centerBackgroundColor: AppColor.iconsColor,
          centerIcon: FloatingCenterButton(
            child: Icon(
              AppIcons.settings,
              color: AppColors.white,
            ),
          ),
          centerIconChild: [
//language================================================================
            AppWidget.centerIcon(
                icon: AppIcons.language,
                onTap: () {
                  if (context.locale.toString() == 'en') {
                    context.setLocale(const Locale('ar'));
                    //rebuild app
                    Phoenix.rebirth(context);
                  } else {
                    context.setLocale(const Locale('en'));
                    Phoenix.rebirth(context);
                  }
                }),
//logout================================================================
            AppWidget.centerIcon(
                icon: AppIcons.logout,
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  AppRoutes.pushReplacementTo(context, Login());
                }),
//close================================================================
            AppWidget.centerIcon(icon: AppIcons.close, onTap: () {}),
          ],
        ),
      ),
    );
  }

//onTab icons==============================================================
  void onTabTapped(int index) {
    pageController?.jumpToPage(index);
    // pageController?.animateToPage(index,
    //     duration: const Duration(milliseconds: 400),
    //     curve: Curves.decelerate);
    setState(() {});
  }
}
