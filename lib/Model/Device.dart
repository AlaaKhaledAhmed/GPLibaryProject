import 'package:flutter/material.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Device {
  final BuildContext context;

  const Device({required this.context});
  //==========================================================
  static double getHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  //==========================================================
  static double getWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  //==========================================================
  static Widget hSpace(double space) {
    return SizedBox(height: space);
  }

  //==========================================================
  static Widget wSpace(space) {
    return SizedBox(
      width: space.w,
    );
  }

//navigation icons==========================================================
  static BottomBarItemsModel bottomBarItems(
      {required String coloerSvg,
      required String noColoerSvg,
      required String title,
      required onTap}) {
    return BottomBarItemsModel(
      iconSelected: SvgPicture.asset(
        coloerSvg,
        height: 30,
        width: 30,
      ),
      icon: SvgPicture.asset(
        noColoerSvg,
        height: 30,
        width: 30,
      ),
      title: title,
      dotColor: AppColors.cherryRed,
      onTap: onTap,
    );
  }

//center navigation icons==========================================================
  static FloatingCenterButtonChild centerIcon(
      {required IconData icon,
      required onTap}) {
    return FloatingCenterButtonChild(
      child: Icon(
        icon,
        color: AppColors.white,
      ),
      onTap: onTap,
    );
  }
}
