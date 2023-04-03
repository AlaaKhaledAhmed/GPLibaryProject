import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_project/Model/Device.dart';
import 'package:library_project/Widget/AppSvg.dart';

import 'MyProject/MyProjectMain.dart';
import 'MyTeam/MyTeamMain.dart';
import 'StudentHome/StudentHome.dart';
import 'Supervisor/StudentSupervisor.dart';

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
          Device.bottomBarItems(
              coloerSvg: AppSvg.homeColor,
              noColoerSvg: AppSvg.homeNoColor,
              title: 'home',
              onTap: () => onTabTapped(0)),
//project================================================================
          Device.bottomBarItems(
              coloerSvg: AppSvg.myProjectColor,
              noColoerSvg: AppSvg.myProjectNoColor,
              title: 'My Project',
              onTap: () => onTabTapped(1)),
//Supervisor================================================================
          Device.bottomBarItems(
              coloerSvg: AppSvg.supervisorColor,
              noColoerSvg: AppSvg.supervisorNoColor,
              title: 'Supervisor',
              onTap: () => onTabTapped(2)),

//team================================================================
          Device.bottomBarItems(
              coloerSvg: AppSvg.temColor,
              noColoerSvg: AppSvg.temNoColor,
              title: 'Team',
              onTap: () => onTabTapped(3)),
        ],
//================================================================

        bottomBarCenterModel: BottomBarCenterModel(
          centerBackgroundColor: AppColors.cherryRed,
          centerIcon: const FloatingCenterButton(
            child: Icon(
              Icons.settings,
              color: AppColors.white,
            ),
          ),
          centerIconChild: [
//language================================================================
            const FloatingCenterButtonChild(
              child: Icon(
                Icons.language,
                color: AppColors.white,
              ),
            ),
//logout================================================================
            FloatingCenterButtonChild(
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.white,
              ),
              onTap: () => onTabTapped(1),
            ),
//close================================================================
            const FloatingCenterButtonChild(
              child: Icon(
                Icons.close,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    pageController?.animateToPage(index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastLinearToSlowEaseIn);
    setState(() {});
  }
}

