import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:library_project/Screens/Student/MyProject/UpdateProject.dart';
import 'package:library_project/Widget/AppButtons.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppLoading.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:library_project/Widget/AppTextFields.dart';
import 'package:library_project/Widget/AppValidator.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../BackEnd/Database/DatabaseMethods.dart';
import '../../../Widget/AppBarMain.dart';
import '../../../Widget/AppRoutes.dart';
import '../../../Widget/AppSize.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class CommentPage extends StatefulWidget {
  final String name;
  final String userId;
  final int projectId;
  const CommentPage(
      {Key? key,
      required this.name,
      required this.userId,
      required this.projectId})
      : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();
  GlobalKey<FormState> addKey = GlobalKey();
  CollectionReference commentCollection =
      FirebaseFirestore.instance.collection("comments");
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBarMain(
          title: LocaleKeys.myProject.tr(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            children: [
              Expanded(
                flex: 9,
                child: StreamBuilder(
                  stream: commentCollection
                      .orderBy('createdOn', descending: true)
                      .where("projectId", isEqualTo: widget.projectId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshat) {
                    if (snapshat.hasError) {
                      return Center(child: Text('${snapshat.error}'));
                    }
                    if (snapshat.hasData) {
                      return mainComment(context, snapshat);
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(flex: 1, child: addComment()),
            ],
            //
          ),
        ));
  }

//==========================================================
  Widget addComment() {
    return Row(
      children: [
        Expanded(
            flex: 7,
            child: Form(
              key: addKey,
              child: AppTextFields(
                  validator: (v) => AppValidator.validatorEmpty(v),
                  controller: commentController,
                  labelText: LocaleKeys.add.tr()),
            )),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          flex: 2,
          child: AppButtons(
              text: LocaleKeys.add.tr(),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();

                if (addKey.currentState?.validate() == true) {
                  Database.addComment(
                          comment: commentController.text,
                          data:
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          name: widget.name,
                          userId: widget.userId,
                          projectId: widget.projectId)
                      .then((v) {
                    print('value: $v');
                    if (v == 'done') {
                      commentController.text = '';
                    } else {
                      Navigator.pop(context);
                      AppLoading.show(
                          context, LocaleKeys.add.tr(), LocaleKeys.error.tr());
                    }
                  });
                }
              },
              bagColor: AppColor.cherryLightPink),
        ),
      ],
    );
  }

//======================================================================
  Widget mainComment(context, snapshat) {
    return snapshat.data.docs.length > 0
        ? ListView.builder(
            itemCount: snapshat.data.docs.length,
            itemBuilder: (context, i) {
              var data = snapshat.data.docs[i].data();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title:
                      AppText(text: data['name'], fontSize: AppSize.subTextSize),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            text: data['comment'], fontSize: AppSize.subTextSize),
                        AppText(
                            text: data['data'], fontSize: AppSize.subTextSize),
                      ]),
                  leading:  CircleAvatar(
                    backgroundColor: AppColor.cherryLightPink,
                    child: Icon(Icons.person,color: AppColor.white),
                  ),
                ),
              );
            })
        : Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
            child: Center(
              child: AppText(
                  text: LocaleKeys.noData.tr(), fontSize: AppSize.subTextSize),
            ),
          );
  }
}
