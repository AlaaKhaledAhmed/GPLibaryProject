import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButtons extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color? bagColor;
  final Color? textStyleColor;
  final TextOverflow? overflow;
  final double? width;
  final double? elevation;
  const AppButtons({
    Key? key,
    required this.onPressed,
    required this.text,
    this.bagColor,
    this.overflow,
    this.textStyleColor,
    this.width,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 50.h,
      child: ElevatedButton(
        child: AppText(
          fontSize: AppSize.buttonsFontSize,
          text: text,
        ),
        style: ElevatedButton.styleFrom(
          primary: bagColor ?? AppColor.buttonsColor,
          elevation: elevation ?? 1,
          textStyle: TextStyle(
              fontFamily: context.locale.toString() == 'en'
                  ? GoogleFonts.quicksand().fontFamily
                  : GoogleFonts.almarai().fontFamily,
              color: textStyleColor ?? AppColor.buttonsTextColor,
              fontSize: AppSize.buttonsFontSize,
              fontStyle: FontStyle.normal),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
