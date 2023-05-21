import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:library_project/BackEnd/Database/DatabaseMethods.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import '../../../BackEnd/Provider/ChangConstModel.dart';
import '../../../Widget/AppBarMain.dart';
import '../../../Widget/AppButtons.dart';
import '../../../Widget/AppConstants.dart';
import '../../../Widget/AppDropList.dart';
import '../../../Widget/AppLoading.dart';
import '../../../Widget/AppSize.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Widget/AppTextFields.dart';
import '../../../Widget/AppValidator.dart';
import '../../../Widget/AppWidget.dart';

class Profile extends StatefulWidget {
  final String type;
  const Profile({required this.type});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> updateKey = GlobalKey<FormState>();

  String? userId;
  String? selectedMajor;
  String? selectedSearch;
  String? docId;
  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    Future.delayed(Duration.zero, () async {
      await getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(
        title: LocaleKeys.myTeam.tr(),
      ),
      body: Consumer<ChangConstModel>(builder: (context, model, child) {
        return AppWidget.body(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: Form(
              key: updateKey,
              child: Column(
                children: [
                  AppWidget.hSpace(AppSize.hSpace),
                  AppWidget.hSpace(AppSize.hSpace),
                  AppTextFields(
                    controller: nameController,
                    labelText: LocaleKeys.name.tr(),
                    validator: (v) => AppValidator.validatorName(v),
                  ),
                  AppWidget.hSpace(AppSize.hSpace),
//id TextField===================================================================================
                  AppTextFields(
                    controller: idController,
                    labelText: LocaleKeys.idTx.tr(),
                    validator: (v) => AppValidator.validatorID(v),
                  ),
                  AppWidget.hSpace(AppSize.hSpace),
//phone TextField=============================================================
                  AppTextFields(
                    controller: phoneController,
                    labelText: LocaleKeys.phoneTx.tr(),
                    validator: (v) => AppValidator.validatorPhone(v),
                  ),
                  AppWidget.hSpace(AppSize.hSpace),
//search interest TextField========================================================================
                  AppDropList(
                    listItem: AppConstants.searchList,
                    validator: (v) {
                      if (v == null) {
                        return LocaleKeys.mandatoryTx.tr();
                      } else {
                        return null;
                      }
                    },
                    onChanged: (selectedItem) {
                      selectedSearch = model.setSearch(selectedItem!);
                      print('selectedSearch: $selectedSearch');
                    },
                    hintText: selectedSearch,
                    dropValue: selectedSearch,
                  ),
                  AppWidget.hSpace(AppSize.hSpace),

//major dropList=============================================================
                  AppDropList(
                    listItem: AppConstants.majorList,
                    validator: (v) {
                      if (v == null) {
                        return LocaleKeys.mandatoryTx.tr();
                      } else {
                        return null;
                      }
                    },
                    onChanged: (selectedItem) {
                      selectedMajor = model.setMajor(selectedItem!);
                      print('selectedMajor: $selectedMajor');
                    },
                    hintText: selectedMajor,
                    dropValue: selectedMajor,
                  ),
                  AppWidget.hSpace(AppSize.hSpace),

//update buttom----------------------------------------------------------------
                  AppButtons(
                    text: LocaleKeys.update.tr(),
                    onPressed: () {
                      updateProfile();
                    },
                    bagColor: AppColor.cherryLightPink,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

//update buttom----------------------------------------------------------------
  Future<void> updateProfile() async {
    if (updateKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      AppLoading.show(context, '', 'lode');
      Database.updateProfile(
              name: nameController.text,
              stId: idController.text,
              major: AppWidget.setEnTranslateMajor(selectedMajor!),
              phone: phoneController.text,
              searchInterest:
                  AppWidget.setEnTranslateSearchInterest(selectedSearch!),
              docId: docId!,
              type: widget.type)
          .then((String v) {
        print('================$v');
        if (v == 'done') {
          Navigator.pop(context);
          AppLoading.show(
              context, LocaleKeys.singUp.tr(), LocaleKeys.done.tr());
        } else {
          Navigator.pop(context);
          AppLoading.show(
              context, LocaleKeys.singUp.tr(), LocaleKeys.error.tr());
        }
      });
    }
  }

//========================================================================
  Future<void> getData() async {
    await AppConstants.userCollection
        .where("userId", isEqualTo: userId!)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          emailController = TextEditingController(text: "${element["email"]}");
          emailController = TextEditingController(text: "${element["email"]}");
          nameController = TextEditingController(text: "${element["name"]}");
          idController = TextEditingController(text: "${element["stId"]}");
          phoneController = TextEditingController(text: "${element["phone"]}");
          selectedSearch = AppWidget.getTranslateSearchInterest(
              "${element["searchInterest"]}");
          selectedMajor = AppWidget.getTranslateMajor("${element["major"]}");
          docId = element.id;
        });
      });
    });
  }
}
