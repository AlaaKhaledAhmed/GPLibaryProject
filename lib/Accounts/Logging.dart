import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:library_project/Model/Device.dart';
import 'package:library_project/Model/Messages.dart';
import 'package:library_project/Widget/AppButtons.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppTextFields.dart';
import 'package:library_project/Widget/ImagePath.dart';
import 'package:library_project/Model/WidgetSize.dart';
import '../Model/Validator.dart';
import '../Widget/Colors.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> singUpKey = GlobalKey();

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
//Glass container=============================================================
                    Positioned(
                        top: Device.getHeight(context) * 0.27,
                        bottom: Device.getHeight(context) * 0.12,
                        left: Device.getHeight(context) * 0.04,
                        right: Device.getHeight(context) * 0.02,
//Screen name=============================================================
                        child: AppText(
                          fontSize: WidgetSize.titleTextSize,
                          text: Messages.singUpStudentTx,
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        )),
//TextField container=============================================================
                    Positioned(
                      bottom: Device.getHeight(context) * 0.11,
                      top: Device.getHeight(context) * 0.32,
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
                                          text: Messages.noHaveAccountTx,
                                          color: AppColor.white,
                                        ),
                                        Device.hSpace(15),
//Glass TextField=============================================================

                                        AppTextFields(
                                          controller: emailController,
                                          labelText: 'labelText',
                                          validator: (v) =>
                                              Validator.validatorEmpty(v!),
                                        ),
                                        Device.hSpace(15),
//Glass TextField=============================================================

                                        AppTextFields(
                                          controller: emailController,
                                          labelText: 'labelText',
                                          validator: (v) =>
                                              Validator.validatorEmpty(v!),
                                        ),
                                        Device.hSpace(15),
//Glass TextField=============================================================
                                        AppTextFields(
                                          controller: emailController,
                                          labelText: 'labelText',
                                          validator: (v) =>
                                              Validator.validatorEmpty(v!),
                                        ),
                                        Device.hSpace(15),
//Glass TextField=============================================================
                                        AppTextFields(
                                          controller: emailController,
                                          labelText: 'labelText',
                                          validator: (v) =>
                                              Validator.validatorEmpty(v!),
                                        ),
                                        Device.hSpace(15),
//Glass TextField=============================================================
                                        AppTextFields(
                                          controller: emailController,
                                          labelText: 'labelText',
                                          validator: (v) =>
                                              Validator.validatorEmpty(v!),
                                        ),
//Glass TextField=============================================================
                                        Device.hSpace(15),
                                        AppButtons(
                                            onPressed: () {}, text: 'SING UP')
//Glass TextField=============================================================

                                      ],
                                    ),
                                  ),
                                ),
                              ))),
                        ),
                      ),
                    ),
                  ],
                )));
      }),
    );
  }
}
