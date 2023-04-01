import 'package:flutter/material.dart';
import 'package:library_project/Model/translations/locale_keys.g.dart';
import 'package:library_project/Widget/AppButtons.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/Colors.dart';
import 'package:library_project/Model/WidgetSize.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Loading {
  static show(context, String title, String content,
      {bool showButtom = false,
      void Function()? yesFunction,
      void Function()? noFunction,
      double? higth}) {
    return showDialog(
        //barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            titlePadding: EdgeInsets.zero,
            elevation: 0,

            backgroundColor:
                content == "lode" ? Colors.transparent : AppColor.white,

//tittle-------------------------------------------------------------------

            title: content != "lode"
                ? Container(
                    decoration: BoxDecoration(
                        color: AppColor.buttonsColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r))),
                    width: double.infinity,
                    height: 40.h,
                    child: Center(
                      child: AppText(
                        fontSize: WidgetSize.buttonsFontSize,
                        text: title,
                        color: AppColor.white,
                      ),
                    ),
                  )
                : const SizedBox(),
//continent area-------------------------------------------------------------------

            content: content != "lode"
                ? SizedBox(
                    height: higth ?? 100.h,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10.h),
//continent tittle-------------------------------------------------------------------
                        Expanded(
                          flex: 3,
                          child: Center(
                              child: AppText(
                            fontSize: WidgetSize.subTextSize,
                            text: content,
                            color: AppColor.black,
                          )),
                        ),

//divider-------------------------------------------------------------------

                        showButtom
                            ? Divider(
                                thickness: 2,
                                color: AppColor.buttonsColor,
                              )
                            : const SizedBox(),
                        SizedBox(height: 10.h),
//bottoms-------------------------------------------------------------------

                        showButtom
                            ? Expanded(
                                flex: 2,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
// yes bottoms-------------------------------------------------------------------
                                      Expanded(
                                          child: AppButtons(
                                        onPressed: yesFunction,
                                        text: LocaleKeys.yes.tr(),
                                      )),

                                      SizedBox(width: 20.w),
//no buttom-------------------------------------------------------------------
                                      Expanded(
                                        child: AppButtons(
                                        onPressed: yesFunction,
                                        text: LocaleKeys.no.tr(),
                                      ),
                                      )
                                    ]),
                              )
                            : const SizedBox(),
                      ],
                    ))
//Show Waiting image-------------------------------------------------------
                : SizedBox(
                    width: double.infinity,
                    height: 200.h,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Lottie.asset(
                        "assets/Lottie/lode.json",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

//Show bottoms -------------------------------------------------------

            actions: [
              showButtom == false && content != "lode"
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.clear,
                                color: AppColor.black, size: 35.sp)),
                      ),
                    )
                  : const SizedBox()
            ],
          );
        });
  }
}
