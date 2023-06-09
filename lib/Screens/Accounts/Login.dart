import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:library_project/BackEnd/Database/DatabaseMethods.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/Widget/AppButtons.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppTextFields.dart';
import 'package:library_project/Widget/AppImagePath.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import '../../Widget/AppRoutes.dart';
import '../../Widget/AppValidator.dart';
import '../../Widget/AppColors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Widget/AppLoading.dart';
import '../Student/NavStudent.dart';
import '../Superviser/NavSuperviser.dart';
import 'SingUp.dart';

class Login extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController resetEmailController = TextEditingController();
  GlobalKey<FormState> loggingKey = GlobalKey();
  GlobalKey<FormState> restPasswordKey = GlobalKey();
  Login({Key? key}) : super(key: key);

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
                height: AppWidget.getHeight(context),
                width: AppWidget.getWidth(context),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppImagePath.backgroundImage2),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: [
//Screen name=============================================================
                    Positioned(
                        //bottom: AppWidget.getHeight(context) * 0.27,
                        top: AppWidget.getHeight(context) * 0.30,
                        left: AppWidget.getHeight(context) * 0.04,
                        right: AppWidget.getHeight(context) * 0.02,
                        child: AppText(
                          fontSize: AppSize.titleTextSize,
                          text: LocaleKeys.loginTx.tr(),
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        )),

//Glass container=============================================================
                    Positioned(
                      top: AppWidget.getHeight(context) * 0.38,
                      bottom: AppWidget.getHeight(context) * 0.26,
                      left: AppWidget.getHeight(context) * 0.02,
                      right: AppWidget.getHeight(context) * 0.02,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSize.containerRadius),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: AnimatedContainer(
                              padding: EdgeInsets.all(15.r),
                              duration: const Duration(microseconds: 200),
                              height: AppWidget.getHeight(context) * 0.4,
                              width: AppWidget.getWidth(context),
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
                                      AppSize.containerRadius),
                                  border: Border.all(
                                      width: AppSize.textFieldsBorderWidth,
                                      color: AppColor.white30)),
                              child: SingleChildScrollView(
                                  child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth,
                                  minHeight: constraints.maxHeight,
                                ),
                                child: IntrinsicHeight(
                                  child: Form(
                                    key: loggingKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
//welcome Tx=============================================================
                                        AppWidget.hSpace(AppSize.hSpace),
                                        AppText(
                                          fontSize: AppSize.subTextSize,
                                          text: LocaleKeys.welcomeLoginTx.tr(),
                                          color: AppColor.white,
                                        ),
                                        AppWidget.hSpace(AppSize.hSpace + 5),

//email TextField=============================================================

                                        AppTextFields(
                                          controller: emailController,
                                          labelText: LocaleKeys.emailTx.tr(),
                                          validator: (v) =>
                                              AppValidator.validatorEmpty(v),
                                        ),
                                        AppWidget.hSpace(AppSize.hSpace),
//password TextField=============================================================

                                        AppTextFields(
                                          controller: passwordController,
                                          labelText: LocaleKeys.passwordTx.tr(),
                                          validator: (v) =>
                                              AppValidator.validatorEmpty(v),
                                          obscureText: true,
                                        ),

//create Account button=============================================================
                                        AppWidget.hSpace(10),
                                        Builder(builder: (co) {
                                          return AppButtons(
                                            onPressed: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              if (loggingKey.currentState
                                                      ?.validate() ==
                                                  true) {
                                                AppLoading.show(co, '', 'lode');
                                                Database.loggingToApp(
                                                        email: emailController
                                                            .text
                                                            .trim(),
                                                        password:
                                                            passwordController
                                                                .text)
                                                    .then((String v) {
                                                  if (v == 'error') {
                                                    Navigator.pop(co);
                                                    AppLoading.show(
                                                        context,
                                                        LocaleKeys.login.tr(),
                                                        LocaleKeys.error.tr());
                                                  } else if (v ==
                                                      'user-not-found') {
                                                    Navigator.pop(co);
                                                    AppLoading.show(
                                                        context,
                                                        LocaleKeys.login.tr(),
                                                        LocaleKeys.emailNotFound
                                                            .tr());
                                                  } else if (v ==
                                                      'wrong-password') {
                                                    Navigator.pop(co);
                                                    AppLoading.show(
                                                        context,
                                                        LocaleKeys.login.tr(),
                                                        LocaleKeys.passNotFound
                                                            .tr());
                                                  } else {
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .where('userId',
                                                            isEqualTo: v)
                                                        .get()
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                      value.docs
                                                          .forEach((element) {
                                                        print('respoms is: $v');
                                                        print(
                                                            'name is: ${element.data()['name']}');
                                                        print(
                                                            'type is: ${element.data()['type']}');
                                                        if (element.data()[
                                                                'type'] ==
                                                            AppConstants
                                                                .student) {
                                                          AppRoutes
                                                              .pushReplacementTo(
                                                                  context,
                                                                  const NavStudent());
                                                        } else if (element
                                                                    .data()[
                                                                'type'] ==
                                                            AppConstants
                                                                .supervisor) {
                                                          AppRoutes
                                                              .pushReplacementTo(
                                                                  context,
                                                                  const NavSupervisor());
                                                        } else {
                                                          AppLoading.show(
                                                              context,
                                                              LocaleKeys.login
                                                                  .tr(),
                                                              LocaleKeys.error
                                                                  .tr());
                                                        }
                                                      });
                                                    });
                                                  }
                                                });
                                              }
                                            },
                                            text: LocaleKeys.login.tr(),
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              ))),
                        ),
                      ),
                    ),
////==============================reset password===============================================================
                    Positioned(
                      bottom: AppWidget.getHeight(context) * 0.2,
                      child: Container(
                        width: AppWidget.getWidth(context),
                        alignment: Alignment.center,
                        child: InkWell(
                            child: AppText(
                              text: LocaleKeys.reset_password.tr(),
                              fontSize: AppSize.title2TextSize,
                              fontWeight: FontWeight.bold,
                              color: AppColor.white,
                            ),
                            onTap: () => showButtomsheetResetPassword(context)),
                      ),
                    ),
//==============================go to sinh up===============================================================
                    Positioned(
                      bottom: AppWidget.getHeight(context) * 0.1,
                      child: Container(
                        width: AppWidget.getWidth(context),
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
                                    fontSize: AppSize.subTextSize + 1.5,
                                    text: LocaleKeys.goTo.tr(),
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    width: 7.w,
                                  ),
                                  InkWell(
                                      child: AppText(
                                        fontSize: AppSize.subTextSize + 1.5,
                                        text: LocaleKeys.singUpStudentTx.tr(),
                                        color: AppColor.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onTap: () {
                                        AppRoutes.pushReplacementTo(
                                            context, SingUp());
                                      }),
                                ],
                              ),
                            ]),
                      ),
                    )
                  ],
                )));
      }),
    );
  }

//=======================show Buttom sheet For Reset Password========================================
  void showButtomsheetResetPassword(context) {
    showModalBottomSheet<void>(
      elevation: 10,
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: false,
      barrierColor: Colors.black87,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            margin: EdgeInsets.all(10.h),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            height: 250.h,
            decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.all(Radius.circular(10.r))),
            child: Form(
              key: restPasswordKey,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      text: LocaleKeys.send_link.tr(),
                      fontSize: AppSize.subTextSize,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
//=====================reset pass tesxfield===============================================
                    AppTextFields(
                      controller: resetEmailController,
                      labelText: LocaleKeys.emailTx.tr(),
                      validator: (v) => AppValidator.validatorEmail2(v),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
//=======================reset bottom=============================================
                    Column(
                      children: [
                        AppButtons(
                          text: LocaleKeys.send_link.tr(),
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (restPasswordKey.currentState?.validate() ==
                                true) {
                              AppLoading.show(context, '', 'lode');
                              Database.resetPassword(
                                email: resetEmailController.text,
                              ).then((String v) {
                                Navigator.pop(context);
                                if (v == 'done') {
                                  AppLoading.show(
                                    context,
                                    LocaleKeys.send_link.tr(),
                                    LocaleKeys.cheakInbox.tr(),
                                    higth: 120.h
                                  );
                                } else if (v == 'user-not-found') {
                                  AppLoading.show(
                                      context,
                                      LocaleKeys.send_link.tr(),
                                      LocaleKeys.userNotFound.tr());
                                } else {
                                  AppLoading.show(
                                      context,
                                      LocaleKeys.send_link.tr(),
                                      LocaleKeys.error.tr());
                                }
                              });
                            }
                          },
                          bagColor: AppColor.cherryLightPink,
                        ),
//=====================cancel bottom===============================================

                        SizedBox(
                          height: 10.h,
                        ),
                        AppButtons(
                          text: LocaleKeys.cancel.tr(),
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.pop(context);
                            resetEmailController.clear();
                          },
                          bagColor: AppColor.cherryLightPink,
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
