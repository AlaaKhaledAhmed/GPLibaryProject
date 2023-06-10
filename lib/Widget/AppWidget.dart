import 'package:flutter/material.dart';
import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../BackEnd/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      width: space,
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
      dotColor: AppColor.cherry,
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
  static Widget body({required Widget? child}) {
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

  //get Translate Search Interest======================================================================
  static String getTranslateSearchInterest(String search) {
    if (search == "الذكاء الاصطناعي" || search == "Artificial Intelligence") {
      return LocaleKeys.artificialIntelligence.tr();
    }
    if (search == "تطوير البرمجيات" || search == "Software Development") {
      return LocaleKeys.softwareDevelopment.tr();
    }
    if (search == "إدارة البيانات" || search == "Data Management") {
      return LocaleKeys.dataManagement.tr();
    }
    if (search == "تطوير مواقع الانترنت" || search == "Web Development") {
      return LocaleKeys.webDevelopment.tr();
    }

    return '';
  }

  //set Translate Search Interest======================================================================
  static String setEnTranslateSearchInterest(String search) {
    if (search == "الذكاء الاصطناعي" || search == "Artificial Intelligence") {
      return "Artificial Intelligence";
    }
    if (search == "تطوير البرمجيات" || search == "Software Development") {
      return "Software Development";
    }
    if (search == "إدارة البيانات" || search == "Data Management") {
      return "Data Management";
    }
    if (search == "تطوير مواقع الانترنت" || search == "Web Development") {
      return "Web Development";
    }

    return '';
  }

  //get Translate major======================================================================
  static String getTranslateMajor(String major) {
    if (major == "هندسة برمجيات" || major == "Software Engineering") {
      return LocaleKeys.softwareEngineering.tr();
    }
    if (major == "علم البيانات" || major == "Data Science") {
      return LocaleKeys.dataScience.tr();
    }
    if (major == "أمن المعلومات" || major == "Information Security") {
      return LocaleKeys.informationSecurity.tr();
    }
    if (major == "تكنولوجيا المعلومات" || major == "Information Technology") {
      return LocaleKeys.informationTechnology.tr();
    }
    if (major == "هندسة الشبكات" || major == "Network Engineering") {
      return LocaleKeys.softwareEngineering.tr();
    }

    return '';
  }

  //set Translate major======================================================================
  static String setEnTranslateMajor(String major) {
    if (major == "هندسة برمجيات" || major == "Software Engineering") {
      return "Software Engineering";
    }
    if (major == "علم البيانات" || major == "Data Science") {
      return "Data Science";
    }
    if (major == "أمن المعلومات" || major == "Information Security") {
      return "Information Security";
    }
    if (major == "تكنولوجيا المعلومات" || major == "Information Technology") {
      return "Information Technology";
    }
    if (major == "هندسة الشبكات" || major == "Network Engineering") {
      return "Network Engineering";
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

  //==========================================================
  // static String? getUid()  {
  //   String? uid=FirebaseAuth.instance.currentUser?.uid;
  //   return uid;
  // }
}
