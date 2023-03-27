import 'package:flutter/material.dart';
import 'package:library_project/Model/WidgetSize.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/Colors.dart';

class AppButtons extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color? bagColor;
  final Color? textStyleColor;
  final TextOverflow? overflow;
  final double? width;
  const AppButtons({
    Key? key,
    required this.onPressed,
    required this.text,
    this.bagColor,
    this.overflow,
    this.textStyleColor,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        child: AppText(
          fontSize: WidgetSize.buttonsFontSize,
          text: text,
        ),
        style: ElevatedButton.styleFrom(
          primary: bagColor ?? AppColor.buttonsColor,
          textStyle: TextStyle(
              color: textStyleColor ?? AppColor.buttonsTextColor,
              fontSize: WidgetSize.buttonsFontSize,
              fontStyle: FontStyle.normal),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
