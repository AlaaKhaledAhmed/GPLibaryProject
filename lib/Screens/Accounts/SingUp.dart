import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:library_project/Widget/Loading.dart';

import '../../Database/Database.dart';
import '../../Model/Constants.dart';
import '../../Model/Device.dart';
import '../../Model/Routs.dart';
import '../../Model/Validator.dart';
import '../../Model/WidgetSize.dart';
import '../../Model/translations/locale_keys.g.dart';
import '../../Widget/AppButtons.dart';
import '../../Widget/AppText.dart';
import '../../Widget/AppTextFields.dart';
import '../../Widget/Colors.dart';
import '../../Widget/DropList.dart';
import '../../Widget/ImagePath.dart';
import 'Logging.dart';

class SingUp extends StatefulWidget {
  const SingUp({Key? key}) : super(key: key);

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();

  GlobalKey<FormState> singUpKey = GlobalKey();
  List<bool> isSuperviser = [false];
  String? selectedMajor;
  String? selectedSearch;
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
                        top: Device.getHeight(context) * 0.22,
                        bottom: Device.getHeight(context) * 0.12,
                        left: Device.getHeight(context) * 0.04,
                        right: Device.getHeight(context) * 0.02,
                        child: AppText(
                          fontSize: WidgetSize.titleTextSize,
                          text: isSuperviser[0]
                              ? LocaleKeys.singUpTeacherTx.tr()
                              : LocaleKeys.singUpStudentTx.tr(),
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        )),

//Glass container=============================================================
                    Positioned(
                      bottom: Device.getHeight(context) * 0.15,
                      top: Device.getHeight(context) * 0.27,
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
                                    key: singUpKey,
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
//name TextField=============================================================

                                        AppTextFields(
                                          controller: nameController,
                                          labelText: LocaleKeys.name.tr(),
                                          validator: (v) =>
                                              Validator.validatorName(v),
                                        ),
                                        Device.hSpace(WidgetSize.hSpace),
//email TextField=============================================================

                                        AppTextFields(
                                          controller: emailController,
                                          labelText: LocaleKeys.emailTx.tr(),
                                          validator: (v) =>
                                              Validator.validatorEmail(
                                                  v,
                                                  isSuperviser[0]
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
                                              Validator.validatorPassword(v),
                                          obscureText: true,
                                        ),
                                        Device.hSpace(WidgetSize.hSpace),
//id or search interest TextField=============================================================
                                        isSuperviser[0]
                                            ? DropList(
                                                listItem:
                                                    context.locale.toString() ==
                                                            'en'
                                                        ? Constants.searchEn
                                                        : Constants.searchAr,
                                                validator: (v) {
                                                  if (v == null) {
                                                    return LocaleKeys
                                                        .mandatoryTx
                                                        .tr();
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                onChanged: (selectedItem) {
                                                  setState(() {
                                                    selectedSearch =
                                                        selectedItem;
                                                  });
                                                },
                                                hintText: LocaleKeys
                                                    .selectSearchInterest
                                                    .tr(),
                                                dropValue: selectedSearch,
                                              )
                                            : AppTextFields(
                                                controller: idController,
                                                labelText: LocaleKeys.idTx.tr(),
                                                validator: (v) =>
                                                    Validator.validatorID(v),
                                              ),
                                        Device.hSpace(WidgetSize.hSpace),
//major dropList=============================================================
                                        DropList(
                                          listItem:
                                              context.locale.toString() == 'en'
                                                  ? Constants.majorEn
                                                  : Constants.majorEn,
                                          validator: (v) {
                                            if (v == null) {
                                              return LocaleKeys.mandatoryTx
                                                  .tr();
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (selectedItem) {
                                            setState(() {
                                              selectedMajor = selectedItem;
                                            });
                                          },
                                          hintText: LocaleKeys.selectMajor.tr(),
                                          dropValue: selectedMajor,
                                        ),
                                        Device.hSpace(WidgetSize.hSpace),
//phone TextField=============================================================
                                        AppTextFields(
                                          controller: phoneController,
                                          labelText: LocaleKeys.phoneTx.tr(),
                                          validator: (v) =>
                                              Validator.validatorPhone(v),
                                        ),
//create Account button=============================================================
                                        Device.hSpace(10),
                                        AppButtons(
                                          text: LocaleKeys.createAccount.tr(),
                                          onPressed: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            if (singUpKey.currentState
                                                    ?.validate() ==
                                                true) {
                                              Loading.show(context, '', 'lode');

                                              isSuperviser[0] == false
                                                  ? Firbase.studentSingUpFu(
                                                      name: nameController.text,
                                                      email:
                                                          emailController.text,
                                                      password:
                                                          passwordController
                                                              .text,
                                                      stId: idController.text,
                                                      major: selectedMajor!,
                                                      phone:
                                                          phoneController.text,
                                                    ).then((String v) {
                                                      print(
                                                          '================$v');
                                                      if (v == 'done') {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Loading.show(
                                                            context,
                                                            LocaleKeys.singUp
                                                                .tr(),
                                                            LocaleKeys.done
                                                                .tr());
                                                      } else if (v ==
                                                          'weak-password') {
                                                        Navigator.pop(context);
                                                        Loading.show(
                                                            context,
                                                            LocaleKeys.singUp
                                                                .tr(),
                                                            LocaleKeys.weekPass
                                                                .tr());
                                                      } else if (v ==
                                                          'email-already-in-use') {
                                                        Navigator.pop(context);
                                                        Loading.show(
                                                            context,
                                                            LocaleKeys.singUp
                                                                .tr(),
                                                            LocaleKeys
                                                                .emailFound
                                                                .tr());
                                                      } else {
                                                        Navigator.pop(context);
                                                        Loading.show(
                                                            context,
                                                            LocaleKeys.singUp
                                                                .tr(),
                                                            LocaleKeys.error
                                                                .tr());
                                                      }
                                                    })
                                                  : Firbase.supervisorSingUpFu(
                                                      name: nameController.text,
                                                      email:
                                                          emailController.text,
                                                      password:
                                                          passwordController
                                                              .text,
                                                      searchInterest:
                                                          selectedSearch!,
                                                      major: selectedMajor!,
                                                      phone:
                                                          phoneController.text,
                                                    ).then((String v) {
                                                      print(
                                                          '================$v');
                                                      if (v == 'done') {
                                                        Navigator.pop(context);
                                                        Loading.show(
                                                            context,
                                                            LocaleKeys.singUp
                                                                .tr(),
                                                            LocaleKeys.done
                                                                .tr());
                                                      } else if (v ==
                                                          'weak-password') {
                                                        Navigator.pop(context);
                                                        Loading.show(
                                                            context,
                                                            LocaleKeys.singUp
                                                                .tr(),
                                                            LocaleKeys.weekPass
                                                                .tr());
                                                      } else if (v ==
                                                          'email-already-in-use') {
                                                        Navigator.pop(context);
                                                        Loading.show(
                                                            context,
                                                            LocaleKeys.singUp
                                                                .tr(),
                                                            LocaleKeys
                                                                .emailFound
                                                                .tr());
                                                      } else {
                                                        Navigator.pop(context);
                                                        Loading.show(
                                                            context,
                                                            LocaleKeys.singUp
                                                                .tr(),
                                                            LocaleKeys.error
                                                                .tr());
                                                      }
                                                    });
                                            }
                                          },
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
                                    text: (isSuperviser[0]
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
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        print('object');
                                        setState(() {
                                          isSuperviser[0] = !isSuperviser[0];
                                        });
                                        print('isTeacher: $isSuperviser');
                                      }),
                                ],
                              ),
                            ]),
                      ),
                    ),
//Switch SingUp =============================================================
                    Positioned(
                      bottom: Device.getHeight(context) * 0.04,
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
                                    text: LocaleKeys.goTo.tr(),
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    width: 7.w,
                                  ),
                                  InkWell(
                                      child: AppText(
                                        fontSize: WidgetSize.subTextSize,
                                        text: LocaleKeys.loginTx.tr(),
                                        color: AppColor.textFieldBorderColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onTap: () {
                                        Routes.pushReplacementTo(
                                            context, const Login());
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
}
