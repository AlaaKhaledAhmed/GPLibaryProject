import 'package:flutter/material.dart';
import 'package:library_project/Screens/Accounts/Logging.dart';
import 'package:library_project/Screens/Accounts/SingUp.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';

class NavStudent extends StatefulWidget {
  const NavStudent({Key? key}) : super(key: key);

  @override
  State<NavStudent> createState() => _NavStudentState();
}

class _NavStudentState extends State<NavStudent> {
  int selectedIndex = 1;
  PageController? pageController;
  List<Widget> page = [
    Login(),
    SingUp(),
    Login(),
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

          BottomBarItemsModel(

            icon: const Icon(Icons.home, size: 25),
            iconSelected:
                const Icon(Icons.home, color: AppColors.cherryRed, size: 25),
            title: 'home',
            dotColor: AppColors.cherryRed,
            onTap: () {},
          ),
          BottomBarItemsModel(
            icon: const Icon(Icons.search, size: 25),
            iconSelected:
                const Icon(Icons.search, color: AppColors.cherryRed, size: 25),
            title: 'search',
            dotColor: AppColors.cherryRed,
            onTap: () {},
          ),
          BottomBarItemsModel(
            icon: const Icon(Icons.person, size: 25),
            iconSelected:
                const Icon(Icons.person, color: AppColors.cherryRed, size: 25),
            title: 'person',
            dotColor: AppColors.cherryRed,
            onTap: () {},
          ),
          BottomBarItemsModel(
              icon: const Icon(Icons.settings, size: 25),
              iconSelected: const Icon(Icons.settings,
                  color: AppColors.cherryRed, size: 25),
              title: 'settings',
              dotColor: AppColors.cherryRed,
              onTap: () {}),
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

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController?.animateToPage(selectedIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastLinearToSlowEaseIn);
  }
}
