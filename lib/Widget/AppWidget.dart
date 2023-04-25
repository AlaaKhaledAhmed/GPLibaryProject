import 'package:flutter/material.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../BackEnd/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class AppWidget {
  final BuildContext context;

  const AppWidget({required this.context});
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
      dotColor: AppColor.iconsColor,
      onTap: onTap,
    );
  }

//center navigation icons==========================================================
  static FloatingCenterButtonChild centerIcon(
      {required IconData icon, required onTap}) {
    return FloatingCenterButtonChild(
      child: Icon(
        icon,
        color: AppColors.white,
      ),
      onTap: onTap,
    );
  }

//scroll body===========================================================
  static body({required Widget? child}) {
    return LayoutBuilder(builder: ((context, constraints) {
      return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification? overscroll) {
            overscroll!.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
              child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: child),
          )));
      // AppText(text: LocaleKeys.myTeam.tr(), fontSize: WidgetSize.titleTextSize);
    }));
  }
  //get Translate word======================================================================
  static String getTranslate(String word) {
    if(word=="الذكاء الاصطناعي" ||word=="Artificial Intelligence"){
      return LocaleKeys.artificialIntelligence.tr();
    }
    if(word=="تطوير البرمجيات" ||word== "Software Development"){
      return LocaleKeys.softwareDevelopment.tr();
    }
    if(word=="إدارة البيانات" ||word=="Data Management"){
      return LocaleKeys.dataManagement.tr();
    }
    if(word=="تطوير مواقع الانترنت" ||word=="Web Development"){
      return LocaleKeys.webDevelopment.tr();
    }

    return '';
  }

  //container decoration===============================================================
 static BoxDecoration decoration({double? radius, Color? color}) {
    return BoxDecoration(
        color: color ?? AppColor.white,
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 20.r)));
  }
  //unique number========================================================================
  static int uniqueOrder() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
