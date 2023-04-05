import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:library_project/Model/Database/DatabaseMethods.dart';
import 'package:library_project/Model/Provider/ChangConstModel.dart';
import 'package:library_project/Widget/AppLoading.dart';
import '../../Widget/AppConstants.dart';
import '../../Widget/AppWidget.dart';
import '../../Widget/AppRoutes.dart';
import '../../Widget/AppValidator.dart';
import '../../Widget/AppSize.dart';
import '../../Model/translations/locale_keys.g.dart';
import '../../Widget/AppButtons.dart';
import '../../Widget/AppText.dart';
import '../../Widget/AppTextFields.dart';
import '../../Widget/AppColors.dart';
import '../../Widget/AppDropList.dart';
import '../../Widget/AppImagePath.dart';
import 'Login.dart';
import 'package:provider/provider.dart';


class SingUp extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();

  GlobalKey<FormState> singUpKey = GlobalKey();
  String? selectedMajor;
  String? selectedSearch;

   SingUp({Key? key}) : super(key: key);
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
                child: Consumer<ChangConstModel>(builder: (context, model, child) {
                  return Stack(
                    children: [
//Screen name=============================================================
                      Positioned(
                          top: AppWidget.getHeight(context) * 0.11,
                         // bottom: AppWidget.getHeight(context) * 0.12,
                          left: AppWidget.getHeight(context) * 0.04,
                          right: AppWidget.getHeight(context) * 0.02,
                          child: AppText(
                            fontSize: AppSize.titleTextSize,
                            text: model.isSuperviser[0]
                                ? LocaleKeys.singUpTeacherTx.tr()
                                : LocaleKeys.singUpStudentTx.tr(),
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          )),

//Glass container=============================================================
                      Positioned(
                        bottom: AppWidget.getHeight(context) * 0.17,
                        top: AppWidget.getHeight(context) * 0.18,
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
                                          color:
                                              AppColor.black.withOpacity(0.3))
                                    ],
                                    gradient: const LinearGradient(
                                        colors: [
                                          Colors.white60,
                                          Colors.white10
                                        ],
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
                                      key: singUpKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
//no Have Account Tx=============================================================
                                          AppWidget.hSpace(AppSize.hSpace),
                                          AppText(
                                            fontSize: AppSize.subTextSize,
                                            text:
                                                LocaleKeys.noHaveAccountTx.tr(),
                                            color: AppColor.white,
                                          ),
                                          AppWidget.hSpace(AppSize.hSpace + 5),
//name TextField=============================================================

                                          AppTextFields(
                                            controller: nameController,
                                            labelText: LocaleKeys.name.tr(),
                                            validator: (v) =>
                                                AppValidator.validatorName(v),
                                          ),
                                          AppWidget.hSpace(AppSize.hSpace),
//email TextField=============================================================

                                          AppTextFields(
                                            controller: emailController,
                                            labelText: LocaleKeys.emailTx.tr(),
                                            validator: (v) =>
                                                AppValidator.validatorEmail(
                                                    v,
                                                    model.isSuperviser[0]
                                                        ? AppConstants
                                                            .typeIsTeacher
                                                        : AppConstants
                                                            .typeIsStudent),
                                          ),
                                          AppWidget.hSpace(AppSize.hSpace),
//password TextField=============================================================

                                          AppTextFields(
                                            controller: passwordController,
                                            labelText:
                                                LocaleKeys.passwordTx.tr(),
                                            validator: (v) =>
                                                AppValidator.validatorPassword(
                                                    v),
                                            obscureText: true,
                                          ),
                                          AppWidget.hSpace(AppSize.hSpace),
//id or search interest TextField=============================================================
                                          model.isSuperviser[0]
                                              ? AppDropList(
                                                  listItem:
                                                      AppConstants.searchList,
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
                                                    selectedSearch =
                                                        model.setSearch(
                                                            selectedItem!);
                                                    print(
                                                        'selectedSearch: ${selectedSearch}');
                                                  },
                                                  hintText: LocaleKeys
                                                      .selectSearchInterest
                                                      .tr(),
                                                  dropValue: selectedSearch,
                                                )
                                              : AppTextFields(
                                                  controller: idController,
                                                  labelText:
                                                      LocaleKeys.idTx.tr(),
                                                  validator: (v) =>
                                                      AppValidator.validatorID(
                                                          v),
                                                ),
                                          AppWidget.hSpace(AppSize.hSpace),
//major dropList=============================================================
                                          AppDropList(
                                            listItem: AppConstants.majorList,
                                            validator: (v) {
                                              if (v == null) {
                                                return LocaleKeys.mandatoryTx
                                                    .tr();
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (selectedItem) {
                                              selectedMajor =
                                                  model.setMajor(selectedItem!);
                                              print(
                                                  'selectedMajor: ${selectedMajor}');
                                            },
                                            hintText:
                                                LocaleKeys.selectMajor.tr(),
                                            dropValue: selectedMajor,
                                          ),
                                          AppWidget.hSpace(AppSize.hSpace),
//phone TextField=============================================================
                                          AppTextFields(
                                            controller: phoneController,
                                            labelText: LocaleKeys.phoneTx.tr(),
                                            validator: (v) =>
                                                AppValidator.validatorPhone(v),
                                          ),
//create Account button=============================================================
                                          AppWidget.hSpace(10),
                                          AppButtons(
                                            text: LocaleKeys.createAccount.tr(),
                                            onPressed: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              if (singUpKey.currentState
                                                      ?.validate() ==
                                                  true) {
                                                AppLoading.show(
                                                    context, '', 'lode');

                                                model.isSuperviser[0]==false
                                                    ? Database.studentSingUpFu(
                                                        name:
                                                            nameController.text,
                                                        email: emailController
                                                            .text,
                                                        password:
                                                            passwordController
                                                                .text,
                                                        stId: idController.text,
                                                        major: selectedMajor!,
                                                        phone: phoneController
                                                            .text,
                                                      ).then((String v) {
                                                        print(
                                                            '================$v');
                                                        if (v == 'done') {
                                                          Navigator.pop(
                                                              context);
                                                          AppLoading.show(
                                                              context,
                                                              LocaleKeys.singUp
                                                                  .tr(),
                                                              LocaleKeys.done
                                                                  .tr());
                                                        } else if (v ==
                                                            'weak-password') {
                                                          Navigator.pop(
                                                              context);
                                                          AppLoading.show(
                                                              context,
                                                              LocaleKeys.singUp
                                                                  .tr(),
                                                              LocaleKeys
                                                                  .weekPass
                                                                  .tr());
                                                        } else if (v ==
                                                            'email-already-in-use') {
                                                          Navigator.pop(
                                                              context);
                                                          AppLoading.show(
                                                              context,
                                                              LocaleKeys.singUp
                                                                  .tr(),
                                                              LocaleKeys
                                                                  .emailFound
                                                                  .tr());
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          AppLoading.show(
                                                              context,
                                                              LocaleKeys.singUp
                                                                  .tr(),
                                                              LocaleKeys.error
                                                                  .tr());
                                                        }
                                                      })
                                                    : Database
                                                        .supervisorSingUpFu(
                                                        name:
                                                            nameController.text,
                                                        email: emailController
                                                            .text,
                                                        password:
                                                            passwordController
                                                                .text,
                                                        searchInterest:
                                                            selectedSearch!,
                                                        major: selectedMajor!,
                                                        phone: phoneController
                                                            .text,
                                                      ).then((String v) {
                                                        print(
                                                            '================$v');
                                                        if (v == 'done') {
                                                          AppLoading.show(
                                                              context,
                                                              LocaleKeys.singUp
                                                                  .tr(),
                                                              LocaleKeys.done
                                                                  .tr());
                                                        } else if (v ==
                                                            'weak-password') {
                                                          Navigator.pop(
                                                              context);
                                                          AppLoading.show(
                                                              context,
                                                              LocaleKeys.singUp
                                                                  .tr(),
                                                              LocaleKeys
                                                                  .weekPass
                                                                  .tr());
                                                        } else if (v ==
                                                            'email-already-in-use') {
                                                          Navigator.pop(
                                                              context);
                                                          AppLoading.show(
                                                              context,
                                                              LocaleKeys.singUp
                                                                  .tr(),
                                                              LocaleKeys
                                                                  .emailFound
                                                                  .tr());
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          AppLoading.show(
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
                        bottom: AppWidget.getHeight(context) * 0.12,
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
                                      fontSize: AppSize.subTextSize,
                                      text: (model.isSuperviser[0]
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
                                          fontSize: AppSize.subTextSize,
                                          text: LocaleKeys.createAccount.tr(),
                                          color: AppColor.textFieldBorderColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        onTap: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          print('object');

                                          model.setType();
                                          print(
                                              'isTeacher: ${model.isSuperviser[0]}');
                                        }),
                                  ],
                                ),
                              ]),
                        ),
                      ),
//Switch SingUp =============================================================
                      Positioned(
                        bottom: AppWidget.getHeight(context) * 0.08,
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
                                      fontSize: AppSize.subTextSize,
                                      text: LocaleKeys.goTo.tr(),
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(
                                      width: 7.w,
                                    ),
                                    InkWell(
                                        child: AppText(
                                          fontSize: AppSize.subTextSize,
                                          text: LocaleKeys.loginTx.tr(),
                                          color: AppColor.textFieldBorderColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        onTap: () {
                                          AppRoutes.pushReplacementTo(
                                              context,  Login());
                                        }),
                                  ],
                                ),
                              ]),
                        ),
                      )
                    ],
                  );
                })));
      }),
    );
  }
}
