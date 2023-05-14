import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarMain extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Color? background;
  final Color? textColor;
  final double? elevation;
  final double? radius;
  final List<Widget>?action;
  final double? high;
  final Widget?leading;
  const AppBarMain(
      {Key? key,
      this.action,
      this.leading,
      required this.title,
      this.background,
      this.elevation,
      this.radius,
      this.high,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:leading??SizedBox() ,
      actions: action??[],
      centerTitle: true,
      elevation: elevation ?? 2,
      backgroundColor: background ?? AppColor.appBarColor,
      title: AppText(
        fontSize: AppSize.titleTextSize,
        text: title,
        color: textColor ?? AppColor.white,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radius ?? 100.r),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(high ?? 85.r);
}
