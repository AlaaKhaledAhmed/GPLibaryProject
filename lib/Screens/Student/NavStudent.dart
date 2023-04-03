import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavStudent extends StatefulWidget {
  const NavStudent({Key? key}) : super(key: key);

  @override
  State<NavStudent> createState() => _NavStudentState();
}

class _NavStudentState extends State<NavStudent> {
  int selectedIndex = 1;
  PageController? pageController;
  List<Widget> page = [P1(), P2(), P3(), P4()];
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
          BottomBarItemsModel(
            iconSelected: SvgPicture.asset(

              'assets/Svg/team_c.svg',
              height: 30,
              width: 30,
            ),
            icon: SvgPicture.asset(
              'assets/Svg/team_nc.svg',
              height: 30,
              width: 30,
            ),
            title: 'home',
            dotColor: AppColors.cherryRed,
            onTap: () => onTabTapped(0),
          ),
          BottomBarItemsModel(
            icon: const Icon(Icons.search, size: 25),
            iconSelected:
                const Icon(Icons.search, color: AppColors.cherryRed, size: 25),
            title: 'search',
            dotColor: AppColors.cherryRed,
            onTap: () => onTabTapped(1),
          ),
          BottomBarItemsModel(
            icon: const Icon(Icons.person, size: 25),
            iconSelected:
                const Icon(Icons.person, color: AppColors.cherryRed, size: 25),
            title: 'person',
            dotColor: AppColors.cherryRed,
            onTap: () => onTabTapped(2),
          ),
          BottomBarItemsModel(
            iconSelected: SvgPicture.asset(
              //thinks 24%
              // boy head color : #c98a1d
              'assets/Svg/supervisor_c.svg',
              height: 30,
              width: 30,
            ),
            icon: SvgPicture.asset(
              'assets/Svg/supervisor_nc.svg',
              height: 30,
              width: 30,
            ),
            title: 'Supervisor',
            dotColor: AppColors.cherryRed,
            onTap: () => onTabTapped(0),
          ),
        ],
        bottomBarCenterModel: const BottomBarCenterModel(
          centerBackgroundColor: AppColors.cherryRed,
          centerIcon: FloatingCenterButton(
            child: Icon(
              Icons.add,
              color: AppColors.white,
            ),
          ),
          centerIconChild: [
            FloatingCenterButtonChild(
              child: Icon(
                Icons.home,
                color: AppColors.white,
              ),
            ),
            FloatingCenterButtonChild(
              child: Icon(
                Icons.home,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void onTabTapped(int index) {
  //   setState(() {
  //     selectedIndex = index;
  //   });
  //   pageController?.animateToPage(selectedIndex,
  //       duration: const Duration(milliseconds: 400),
  //       curve: Curves.fastLinearToSlowEaseIn);
  // }
  void onTabTapped(int index) {
    pageController?.animateToPage(index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastLinearToSlowEaseIn);
  }
}

class P1 extends StatelessWidget {
  const P1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}

class P2 extends StatelessWidget {
  const P2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}

class P3 extends StatelessWidget {
  const P3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown,
    );
  }
}

class P4 extends StatelessWidget {
  const P4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}
