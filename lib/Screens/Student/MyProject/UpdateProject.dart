import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_project/BackEnd/Database/DatabaseMethods.dart';
import 'package:library_project/BackEnd/Provider/ChangConstModel.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:library_project/Widget/AppDropList.dart';
import 'package:library_project/Widget/AppLoading.dart';
import 'package:library_project/Widget/AppTextFields.dart';
import 'package:library_project/Widget/AppValidator.dart';
import 'package:path/path.dart' as path;
import 'package:library_project/Widget/AppBarMain.dart';
import 'package:library_project/Widget/AppButtons.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class UpdateProject extends StatefulWidget {
  final String nameController;
  final String dateController;
  final String fileName;
  final String superNameController;
  final String selectedSearch;
  final String selectedMajor;
  final String docId;

  const UpdateProject(
      {Key? key,
      required this.nameController,
      required this.dateController,
      required this.fileName,
      required this.superNameController,
      required this.docId,
      required this.selectedSearch,
      required this.selectedMajor})
      : super(key: key);

  @override
  State<UpdateProject> createState() => _UpdateProjectState();
}

class _UpdateProjectState extends State<UpdateProject> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController projectPathController = TextEditingController();
  TextEditingController superNameController = TextEditingController();

  GlobalKey<FormState> addKey = GlobalKey();
  Reference? fileRef;
  String? selectedMajor;
  String? selectedSearch;
  String? fileURL;
  File? file;
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    nameController.text = widget.nameController;
    dateController.text = widget.dateController;
    projectPathController.text = widget.fileName;
    superNameController.text = widget.superNameController;
    selectedMajor = widget.selectedMajor;
    selectedSearch = widget.selectedSearch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.mainColor,
        appBar: AppBarMain(
          title: LocaleKeys.myProject.tr(),
          radius: 52.r,
        ),
        body: Consumer<ChangConstModel>(builder: (context, model, child) {
          return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 30.h),
                child: Form(
                  key: addKey,
                  child: Column(
                    children: [
                      // icon(),
                      AppWidget.hSpace(AppSize.hSpace),
//==============================project name===============================================================
                      AppTextFields(
                        controller: nameController,
                        labelText: LocaleKeys.projectName.tr(),
                        validator: (v) => AppValidator.validatorNameEnAr(v),
                        obscureText: false,
                      ),
                      AppWidget.hSpace(AppSize.hSpace),
//==============================supervisor name===============================================================
                      AppTextFields(
                        controller: superNameController,
                        labelText: LocaleKeys.mySuperVisor.tr(),
                        validator: (v) => AppValidator.validatorEmpty(v),
                        obscureText: false,
                      ),
                      AppWidget.hSpace(AppSize.hSpace),
//============================== date===============================================================
                      AppTextFields(
                        controller: dateController,
                        labelText: LocaleKeys.year.tr(),
                        validator: (v) => AppValidator.validatorEmpty(v),
                        obscureText: false,
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onTap: onTapDate,
                      ),
                      AppWidget.hSpace(AppSize.hSpace),
//==============================file===============================================================
                      AppTextFields(
                        controller: projectPathController,
                        labelText: LocaleKeys.attachFile.tr(),
                        validator: (v) => AppValidator.validatorEmpty(v),
                        obscureText: false,
                        keyboardType: TextInputType.datetime,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onTap: () {
                          setState(() {
                            getFile(context).whenComplete(() {
                              print('fillllllllllllle:${file!.path}');
                              projectPathController.text =
                                  path.basename(file!.path);
                            });
                          });
                        },
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
                        hintText: LocaleKeys.selectSearchInterest.tr(),
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
                        hintText: LocaleKeys.selectMajor.tr(),
                        dropValue: selectedMajor,
                      ),
                      AppWidget.hSpace(AppSize.hSpace),
//==============================add ===============================================================

                      AppButtons(
                        text: LocaleKeys.update.tr(),
                        bagColor: AppColor.cherryLightPink,
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (addKey.currentState?.validate() == true) {
                            AppLoading.show(context, '', 'lode');
                            if (file == null) {
                              Database.updateProject(
                                      name: nameController.text,
                                      year: dateController.text,
                                      link: projectPathController.text,
                                      fileName: projectPathController.text,
                                      docId: widget.docId,
                                      superName: superNameController.text,
                                      major: AppWidget.setEnTranslateMajor(
                                          selectedMajor!),
                                      searchInterest: AppWidget
                                          .setEnTranslateSearchInterest(
                                              selectedSearch!))
                                  .then((String v) {
                                print('================$v');
                                if (v == "done") {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  AppLoading.show(
                                      context,
                                      LocaleKeys.update.tr(),
                                      LocaleKeys.done.tr());
                                } else {
                                  Navigator.pop(context);
                                  AppLoading.show(
                                      context,
                                      LocaleKeys.update.tr(),
                                      LocaleKeys.error.tr());
                                }
                              });
                            } else {
                              fileRef = FirebaseStorage.instance
                                  .ref('project')
                                  .child(projectPathController.text);
                              await fileRef
                                  ?.putFile(file!)
                                  .then((getValue) async {
                                fileURL = await fileRef!.getDownloadURL();
                                print('fileURLllllllllllllllllllll $fileURL');
                                // setState(() {file=null;});
                                Database.updateProject(
                                  name: nameController.text,
                                  year: dateController.text,
                                  link: fileURL!,
                                  fileName: projectPathController.text,
                                  docId: widget.docId,
                                  superName: superNameController.text,
                                  major: AppWidget.setEnTranslateMajor(
                                      selectedMajor!),
                                  searchInterest:
                                      AppWidget.setEnTranslateSearchInterest(
                                          selectedSearch!),
                                ).then((String v) {
                                  print('================$v');
                                  if (v == "done") {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    AppLoading.show(
                                        context,
                                        LocaleKeys.update.tr(),
                                        LocaleKeys.done.tr());
                                  } else {
                                    Navigator.pop(context);
                                    AppLoading.show(
                                        context,
                                        LocaleKeys.update.tr(),
                                        LocaleKeys.error.tr());
                                  }
                                });
                              });
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ));
        }));
  }

//show file picker=========================================
  Future getFile(context) async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf']);
    if (pickedFile == null) {
      return null;
    }
    setState(() {
      file = File(pickedFile.paths.first!);
    });
  }

  //show date picker----------------------------------------
  void onTapDate() async {
    FocusScope.of(context).unfocus();
    DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(20100));
    setState(() {
      if (datePicker != null) {
        dateController.text =
            '${datePicker.day}-${datePicker.month}-${datePicker.year}';
        '${datePicker.weekday}';
      }
    });
  }
}
