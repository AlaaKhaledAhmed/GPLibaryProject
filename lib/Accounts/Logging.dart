import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:library_project/Model/Constants.dart';
import 'package:library_project/Model/Device.dart';
import 'package:library_project/Widget/AppButtons.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppTextFields.dart';
import 'package:library_project/Widget/DropList.dart';
import 'package:library_project/Widget/ImagePath.dart';
import 'package:library_project/Model/WidgetSize.dart';
import '../Model/Routs.dart';
import '../Model/Validator.dart';
import '../Model/translations/locale_keys.g.dart';
import '../Widget/Colors.dart';
import 'package:easy_localization/easy_localization.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> loggingKey = GlobalKey();
  List<bool> isTeacher = [false];
  String? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: AppColor.black,
      body: LayoutBuilder(builder: (context, constraints) {
        return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification? overscroll) {
              overscroll!.disallowGlow();
              return true;
            },
            child: Container(
                height: Device.getHeight(context),
                width: Device.getWidth(context),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(ImagePath.backgroundImage2),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: [
//Screen name=============================================================
                    Positioned(
                        bottom: Device.getHeight(context) * 0.22,
                        top: Device.getHeight(context) * 0.44,
                        left: Device.getHeight(context) * 0.04,
                        right: Device.getHeight(context) * 0.02,
                        child: AppText(
                          fontSize: WidgetSize.titleTextSize,
                          text: isTeacher[0]
                              ? LocaleKeys.singUpTeacherTx.tr()
                              : LocaleKeys.singUpStudentTx.tr(),
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        )),

//Glass container=============================================================
                    Positioned(
                      bottom: Device.getHeight(context) * 0.25,
                      top: Device.getHeight(context) * 0.42,
                      left: Device.getHeight(context) * 0.02,
                      right: Device.getHeight(context) * 0.02,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(WidgetSize.containerRadius),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: AnimatedContainer(
                              padding: EdgeInsets.all(15.r),
                              duration: const Duration(microseconds: 200),
                              height: Device.getHeight(context) * 0.4,
                              width: Device.getWidth(context),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: -5,
                                        blurRadius: 25,
                                        color: AppColor.black.withOpacity(0.3))
                                  ],
                                  gradient: const LinearGradient(
                                      colors: [Colors.white60, Colors.white10],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomCenter),
                                  color: AppColor.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(
                                      WidgetSize.containerRadius),
                                  border: Border.all(
                                      width: WidgetSize.textFieldsBorderWidth,
                                      color: AppColor.white30)),
                              child: SingleChildScrollView(
                                  child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth,
                                  minHeight: constraints.maxHeight,
                                ),
                                child: IntrinsicHeight(
                                  child: Form(
                                    // key: singUpKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
//no Have Account Tx=============================================================

                                        AppText(
                                          fontSize: WidgetSize.subTextSize,
                                          text: LocaleKeys.noHaveAccountTx.tr(),
                                          color: AppColor.white,
                                        ),
                                        Device.hSpace(WidgetSize.hSpace),

//email TextField=============================================================

                                        AppTextFields(
                                          controller: emailController,
                                          labelText: LocaleKeys.emailTx.tr(),
                                          validator: (v) =>
                                              Validator.validatorEmail(
                                                  v!,
                                                  isTeacher[0]
                                                      ? Constants.typeIsTeacher
                                                      : Constants
                                                          .typeIsStudent),
                                        ),
                                        Device.hSpace(WidgetSize.hSpace),
//password TextField=============================================================

                                        AppTextFields(
                                          controller: passwordController,
                                          labelText: LocaleKeys.passwordTx.tr(),
                                          validator: (v) =>
                                              Validator.validatorPassword(v!),
                                          obscureText: true,
                                        ),

//create Account button=============================================================
                                        Device.hSpace(10),
                                        AppButtons(
                                          onPressed: () {},
                                          text: LocaleKeys.createAccount.tr(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ))),
                        ),
                      ),
                    ),
//Switch SingUp =============================================================
                    Positioned(
                      bottom: Device.getHeight(context) * 0.09,
                      child: Container(
                        width: Device.getWidth(context),
                        alignment: Alignment.center,
                        //color: AppColor.black,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  AppText(
                                    fontSize: WidgetSize.subTextSize,
                                    text: (isTeacher[0]
                                            ? LocaleKeys.isStudent.tr()
                                            : LocaleKeys.isTeacher.tr()) +
                                        (context.locale.toString() == 'en'
                                            ? '?'
                                            : '؟'),
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    width: 7.w,
                                  ),
                                  InkWell(
                                      child: AppText(
                                        fontSize: WidgetSize.subTextSize,
                                        text: LocaleKeys.createAccount.tr(),
                                        color: AppColor.textFieldBorderColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onTap: () {
                                        print('object');
                                        setState(() {
                                          isTeacher[0] = !isTeacher[0];
                                        });
                                        print('isTeacher: $isTeacher');
                                      }),
                                ],
                              ),
                            ]),
                      ),
                    ),

                  ],
                )));
      }),
    );
  }
}
