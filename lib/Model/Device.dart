import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return SizedBox(width: space.w,);
  }
  //==========================================================


}
