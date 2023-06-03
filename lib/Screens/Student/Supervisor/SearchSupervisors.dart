import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_project/Widget/AppSize.dart';
import 'package:library_project/Widget/AppText.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:library_project/translations/locale_keys.g.dart';
import '../../../../Widget/AppSize.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_project/Widget/AppSvg.dart';
import 'dart:math' as math;
import '../../../BackEnd/Database/DatabaseMethods.dart';
import '../../../BackEnd/Provider/ChangConstModel.dart';
import '../../../Widget/AppConstants.dart';
import '../../../Widget/AppLoading.dart';
import '../../../Widget/AppTextFields.dart';
import '../../../Widget/AppValidator.dart';
import '../../../Widget/AppWidget.dart';
import 'package:provider/provider.dart';

class SearchSupervisors extends SearchDelegate {
  List<String> _oldFilters = [];
  final List<dynamic> supervisorsNamesList;
  final BuildContext context;
  final Locale local;
  final String userId;
  SearchSupervisors(
      {required this.supervisorsNamesList,
      required this.context,
      required this.userId,
      required this.local})
      : super(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Action of app bar
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              Navigator.pop(context);
            } else {
              query = "";
              showSuggestions(context);
            }
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // الايقون الموجودة قبل المربع النصي
    return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  var userCollection = FirebaseFirestore.instance.collection("users");
  TextEditingController descriptionController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  GlobalKey<FormState> addKey = GlobalKey();
  int? tab;
  @override
  Widget buildResults(BuildContext context) {
    saveToRecentSearchesSupervisor(query);
    return StreamBuilder(
        stream: userCollection
            .where("type", isEqualTo: AppConstants.supervisor)
            .where("name", isEqualTo: query)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error check internet!"));
          }
          if (snapshot.hasData) {
            return body(snapshot);
          }
          if (snapshot.hasData) {
            return body(snapshot);
          }

          return const Center(
              child: CircularProgressIndicator(
            color: AppColor.appBarColor,
          ));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    getRecentSearches().then((value) {
      _oldFilters = value;
    });

    List listSearch = supervisorsNamesList.where((name) {
      // print('name ${name}');
      final nameLower = name.toLowerCase();
      final queryLower = query.toLowerCase();
      // print('nameLower  ${nameLower}');
      return nameLower.startsWith(queryLower);
    }).toList();
    return query.isEmpty && _oldFilters.isEmpty
        ?  Center(
          child: AppText(
              text: LocaleKeys.history.tr(),
              fontSize: 15,
            ),
        )
        : query.isEmpty && _oldFilters.isNotEmpty
            ? showHistory(context, _oldFilters)
            : getSuggestionList(listSearch);
  }

//save To Recent Searches =====================================================================
  saveToRecentSearchesSupervisor(String searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }

//save To Recent Searches =====================================================================
  Future<List<String>> getRecentSearches() async {
    final pref = await SharedPreferences.getInstance();
    // var allSearches = pref.getString(key) ?? [];
    final allSearches = pref.getStringList("recentSearches") ?? [];
    print('allSearches= $allSearches');
    return allSearches;
  }

//build Suggestion=====================================================================
  Widget getSuggestionList(List suggestions) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                final queryText = suggestion.substring(0, query.length);
                final remainingText = suggestion.substring(query.length);
                return ListTile(
                  minLeadingWidth: 5.w,
                  onTap: () {
                    query = suggestion;
                    showResults(context);
                  },
                  leading: SvgPicture.asset(
                    AppSvg.supervisorColor,
                    height: 25,
                    width: 25,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: queryText,
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                  text: remainingText,
                                  style: const TextStyle(color: Colors.grey)),
                            ]),
                      ),
                      Icon(
                        Icons.north_west,
                        color: AppColor.grey600,
                        size: 22.sp,
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  //save To Recent Searches =====================================================================
  Widget showHistory(context, List suggestions) {
    // print('history suggestions $suggestions');
    return suggestions.isEmpty && query == ''
        ? const SizedBox()
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          LocaleKeys.history.tr(),
                          style: TextStyle(
                            fontSize: AppSize.subTextSize,
                            color: AppColor.black,
                            fontFamily: local.toString() == 'en'
                                ? GoogleFonts.quicksand().fontFamily
                                : GoogleFonts.almarai().fontFamily,
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            // removeHistory();
                            query = '';

                            removeHistory();
                          },
                          child: Text(
                            LocaleKeys.delete.tr(),
                            style: TextStyle(
                              fontSize: AppSize.subTextSize,
                              color: AppColor.grey600,
                              fontFamily: local.toString() == 'en'
                                  ? GoogleFonts.quicksand().fontFamily
                                  : GoogleFonts.almarai().fontFamily,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        minLeadingWidth: 5.w,
                        onTap: () {
                          query = suggestions[index];
                          //pagIndex = suggestions[index].;
                          showResults(context);
                        },
                        leading: const Icon(Icons.history),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: suggestions[index],
                              fontSize: AppSize.subTextSize,
                              fontFamily: local.toString() == 'en'
                                  ? GoogleFonts.quicksand().fontFamily
                                  : GoogleFonts.almarai().fontFamily,
                            ),
                            Icon(
                              Icons.north_west,
                              color: AppColor.grey600,
                              size: 22.sp,
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          );
  }

//remove history-----------------------------------------------------------------
  void removeHistory() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'recentSearches';
    bool de = await prefs.remove(key);
    print('delete history $de');
  }

  @override
  String get searchFieldLabel => LocaleKeys.search.tr();
//================================================================================================
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double size = MediaQuery.of(context).size.width;
    return ThemeData(
      primarySwatch: Colors.grey,
      appBarTheme: AppBarTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(60.r),
          ),
        ),
        toolbarHeight: 100.h,
        backgroundColor: AppColor.appBarColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 2,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white,
          fontSize: AppSize.titleTextSize,
          fontFamily: local.toString() == 'en'
              ? GoogleFonts.quicksand().fontFamily
              : GoogleFonts.almarai().fontFamily,
        ),
        titleMedium: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.black87,
          fontSize: AppSize.titleTextSize.sp,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        hintStyle: TextStyle(
          color: Colors.grey[300],
          fontSize: AppSize.titleTextSize,
        ),
        fillColor: Colors.white12,
        errorStyle: TextStyle(color: Colors.red, fontSize: 13.0.sp),
      ),
    );
  }

//show data from database========================================================================
  Widget body(snapshot) {
    return snapshot.data.docs.isNotEmpty
        ? Consumer<ChangConstModel>(builder: (context, model, child) {
            return
              Container(
                //height: AppWidget.getHeight(context) * 0.55,
                  decoration:
                  AppWidget.decoration(radius: 10.r, color: AppColor.noColor),
                  width: AppWidget.getWidth(context),
                  child: Container(
                    //height: AppWidget.getHeight(context) * 0.55,
                    decoration:
                    AppWidget.decoration(radius: 10.r, color: AppColor.noColor),
                    width: AppWidget.getWidth(context),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, i) {
                          var data = snapshot.data.docs[i].data();
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: SizedBox(
                              height: tab == i ? 400.h : 200,
                              width: AppWidget.getWidth(context),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  //set border radius more than 50% of height and width to make circle
                                ),
//dr name=================================================================
                                child: ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.only(top: 30.h),
                                    child: AppText(
                                      text: '${LocaleKeys.dr.tr()}: ${data['name']}',
                                      fontSize: AppSize.title2TextSize,
                                    ),
                                  ),
//description =====================================================================
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Center(
                                      child: Form(
                                        key: tab == i ? addKey : null,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text:
                                              '${LocaleKeys.searchInterestTx.tr()}: ' +
                                                  AppWidget
                                                      .getTranslateSearchInterest(
                                                      data['searchInterest']),
                                              fontSize: AppSize.subTextSize + 2,
                                            ),
                                            AppWidget.hSpace(8),
                                            AppText(
                                              text:
                                              '${LocaleKeys.superVisorMajorTx.tr()}: ' +
                                                  AppWidget.getTranslateMajor(
                                                      data['major']),
                                              fontSize: AppSize.subTextSize + 2,
                                            ),
                                            AppWidget.hSpace(8),
                                            AppText(
                                              text: '${LocaleKeys.emailTx.tr()}: ' +
                                                  data['email'],
                                              fontSize: AppSize.subTextSize + 2,
                                            ),
                                            AppWidget.hSpace(20),
                                            tab == i
                                                ? AppTextFields(
                                              controller: projectNameController,
                                              labelText:
                                              LocaleKeys.projectName.tr(),
                                              validator: (v) =>
                                                  AppValidator.validatorEmpty(
                                                      v),
                                              maxLines: 1,
                                              minLines: 1,
                                            )
                                                : const SizedBox(),
                                            tab == i
                                                ? AppWidget.hSpace(8)
                                                : const SizedBox(),
                                            tab == i
                                                ? AppTextFields(
                                              controller: descriptionController,
                                              labelText:
                                              LocaleKeys.description.tr(),
                                              validator: (v) =>
                                                  AppValidator.validatorEmpty(
                                                      v),
                                              maxLines: 4,
                                              minLines: 4,
                                            )
                                                : const SizedBox(),

                                            // AppWidget.hSpace(7),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
//send icon==========================================================================

                                  trailing: FittedBox(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 20.h),
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(
                                            context.locale.toString() == 'en'
                                                ? 0
                                                : math.pi),
                                        child: FutureBuilder(
                                            future: getStatus(
                                                stId: userId, supId: data['userId']),
                                            builder: (context, AsyncSnapshot sn) {
                                              if (sn.hasError) {
                                                return const Center(child: Text("!"));
                                              }
                                              if (sn.hasData) {
                                                return SvgPicture.asset(
                                                  sn.data ==
                                                      AppConstants.statusIsWaiting
                                                      ? AppSvg.waitSvg
                                                      : sn.data ==
                                                      AppConstants
                                                          .statusIsRejection
                                                      ? AppSvg.rejectFileSvg
                                                      : sn.data ==
                                                      AppConstants
                                                          .statusIsAcceptation
                                                      ? AppSvg.acceptFileSvg
                                                      : AppSvg.sendSvg,
                                                  height: 40.r,
                                                  width: 40.r,
                                                );
                                              }

                                              return const Center(
                                                  child: CircularProgressIndicator(
                                                    color: AppColor.appBarColor,
                                                  ));
                                            }),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    tab = i;
                                    model.refreshPage();
                                    if (addKey.currentState?.validate() == true) {
                                      await getStatus(
                                          stId: userId,
                                          supId: data['userId']) ==
                                          AppConstants.statusIsNotSendYet
                                          ? AppLoading.show(
                                        context,
                                        LocaleKeys.sendRequest.tr(),
                                        '${LocaleKeys.sendRequestTo.tr()} ' +
                                            data['name'],
                                        higth: 100.h,
                                        showButtom: true,
                                        noFunction: () {
                                          Navigator.pop(context);
                                          tab = null;
                                          model.refreshPage();
                                        },
                                        yesFunction: () async => Database
                                            .studentSupervisionRequests(
                                            description:
                                            descriptionController
                                                .text,
                                            projectName:
                                            projectNameController
                                                .text,
                                            context: context,
                                            studentUid: userId,
                                            supervisorUid:
                                            data['userId'],
                                            supervisorName:
                                            data['name'],
                                            supervisorInterest:
                                            data['searchInterest'],
                                            studentName: await Database
                                                .getDataViUserId(
                                                currentUserUid:
                                                userId))
                                            .then((v) {
                                          print('================$v');
                                          if (v == 'done') {
                                            tab = null;
                                            model.refreshPage();
                                            Navigator.pop(context);
                                            AppLoading.show(
                                                context,
                                                LocaleKeys.mySuperVisor.tr(),
                                                LocaleKeys.done.tr());
                                          } else {
                                            Navigator.pop(context);
                                            AppLoading.show(
                                                context,
                                                LocaleKeys.mySuperVisor.tr(),
                                                LocaleKeys.error.tr());
                                          }
                                        }),
                                      )
                                          : AppLoading.show(
                                          context,
                                          LocaleKeys.sendRequest.tr(),
                                          LocaleKeys.canNotSend.tr());
                                    }
                                  },
                                ),
                              ),
//==========================================================================
                            ),
                          );
                        }),
                  ));
          })
        : Center(
            child: AppText(
                text: LocaleKeys.noData.tr(),
                fontSize: AppSize.subTextSize,
                fontWeight: FontWeight.bold),
          );
  }

//get Status of student request=======================================================================
  getStatus({required String stId, required String supId}) async {
    // print('stId:$stId');
    // print('supId:$supId');
    late int st = 0;
    await AppConstants.requestCollection
        .where('studentUid', isEqualTo: stId)
        .where('supervisorUid', isEqualTo: supId)
        .get()
        .then((getData) {
      for (QueryDocumentSnapshot element in getData.docs) {
        if (element.exists) {
          st = element['status'];
        }
      }
    });

    return st;
  }
}
