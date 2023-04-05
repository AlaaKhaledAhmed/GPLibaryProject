import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppColors.dart';

class AppBarMain extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Color? background;
  final double? elevation;
  const AppBarMain(
      {Key? key, required this.title, this.background, this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: background,
      title: AppText(
      fontSize: AppSize.titleTextSize,
      text: title,
      color: AppColor.black,
      fontWeight: FontWeight.bold,
    ));
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
