import 'package:flutter/material.dart';

class NavSuperviser extends StatefulWidget {
  const NavSuperviser();

  @override
  State<NavSuperviser> createState() => _NavSuperviserState();
}

class _NavSuperviserState extends State<NavSuperviser> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return Scaffold(
    //   body: PageView(
    //     controller: _pageController,
    //     physics: const NeverScrollableScrollPhysics(),
    //     children: List.generate(
    //         bottomBarPages.length, (index) => bottomBarPages[index]),
    //   ),
    //   extendBody: true,
    //   bottomNavigationBar: (bottomBarPages.length <= maxCount)
    //       ? AnimatedNotchBottomBar(
    //     pageController: _pageController,
    //     color: Colors.white,
    //     showLabel: false,
    //     notchColor: Colors.black87,
    //     bottomBarItems: [
    //       const BottomBarItem(
    //         inActiveItem: Icon(
    //           Icons.home_filled,
    //           color: Colors.blueGrey,
    //         ),
    //         activeItem: Icon(
    //           Icons.home_filled,
    //           color: Colors.blueAccent,
    //         ),
    //         itemLabel: 'Page 1',
    //       ),
    //       const BottomBarItem(
    //         inActiveItem: Icon(
    //           Icons.star,
    //           color: Colors.blueGrey,
    //         ),
    //         activeItem: Icon(
    //           Icons.star,
    //           color: Colors.blueAccent,
    //         ),
    //         itemLabel: 'Page 2',
    //       ),
    //
    //       ///svg example
    //       BottomBarItem(
    //         inActiveItem: SvgPicture.asset(
    //           'assets/search_icon.svg',
    //           color: Colors.blueGrey,
    //         ),
    //         activeItem: SvgPicture.asset(
    //           'assets/search_icon.svg',
    //           color: Colors.white,
    //         ),
    //         itemLabel: 'Page 3',
    //       ),
    //       const BottomBarItem(
    //         inActiveItem: Icon(
    //           Icons.settings,
    //           color: Colors.blueGrey,
    //         ),
    //         activeItem: Icon(
    //           Icons.settings,
    //           color: Colors.pink,
    //         ),
    //         itemLabel: 'Page 4',
    //       ),
    //       const BottomBarItem(
    //         inActiveItem: Icon(
    //           Icons.person,
    //           color: Colors.blueGrey,
    //         ),
    //         activeItem: Icon(
    //           Icons.person,
    //           color: Colors.yellow,
    //         ),
    //         itemLabel: 'Page 5',
    //       ),
    //     ],
    //     onTap: (index) {
    //       /// control your animation using page controller
    //       _pageController.animateToPage(
    //         index,
    //         duration: const Duration(milliseconds: 500),
    //         curve: Curves.easeIn,
    //       );
    //     },
    //   )
    //       : null,
    // );
  }
}