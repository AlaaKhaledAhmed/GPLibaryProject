import 'package:flutter/material.dart';
import 'package:library_project/Widget/AppColors.dart';
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
import '../../../Widget/AppRoutes.dart';
import '../../../Widget/AppTextFields.dart';
import '../../../Widget/AppValidator.dart';
import '../../../Widget/AppWidget.dart';
import 'package:provider/provider.dart';

import '../MyProject/DawonlodeProject.dart';
import '../MyProject/ViewProject.dart';
import 'CommentPage.dart';
import 'model.dart';

class SearchProject extends SearchDelegate {
  List<String> _oldFiltersProjectsName = [];
  List<String> _oldFiltersSearchInterset = [];
  final List<Model> projectNamesList;
  //final List<dynamic> projectSearchIntersetList;
  final BuildContext context;
  final Locale local;
  final String userId;
  final String name;
  SearchProject(
      {required this.projectNamesList,
      //required this.projectSearchIntersetList,
      required this.context,
      required this.name,
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

  @override
  Widget buildResults(BuildContext context) {
    saveProjectName(query);

    return StreamBuilder(
        stream: AppConstants.projectCollection
            .where("status", isEqualTo: AppConstants.statusIsComplete)
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
    getProjectName().then((value) {
      _oldFiltersProjectsName = value;
    });
    getSearchInterest().then((value) {
      _oldFiltersSearchInterset = value;
    });

    List<Model> listSearch = projectNamesList.where((name) {
      final nameLower = name.name.toLowerCase();
      final queryLower = query.toLowerCase();
      // print('nameLower  ${nameLower}');
      return nameLower.startsWith(queryLower);
    }).toList();

    return query.isEmpty && _oldFiltersProjectsName.isEmpty
        ? Center(
            child: AppText(
              text: LocaleKeys.history.tr(),
              fontSize: 15,
            ),
          )
        : query.isEmpty && _oldFiltersProjectsName.isNotEmpty
            ? showHistory(
                context, _oldFiltersProjectsName, _oldFiltersSearchInterset)
            : getSuggestionList(listSearch);
  }

//build Suggestion=====================================================================
  Widget getSuggestionList(List<Model> suggestions) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                final queryText = suggestion.name.substring(0, query.length);
                final remainingText = suggestion.name.substring(query.length);
                return ListTile(
                  minLeadingWidth: 5.w,
                  onTap: () {
                    query = suggestion.name;
                    saveSearInterest(AppWidget.setEnTranslateSearchInterest(
                        suggestions[index].searchInterest));
                    showResults(context);
                  },
                  leading: SvgPicture.asset(
                    AppSvg.myProjectColor,
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
                  subtitle: Text(
                    suggestions[index].searchInterest,
                    style: TextStyle(
                      fontSize: AppSize.subTextSize,
                      color: AppColor.black,
                      fontFamily: local.toString() == 'en'
                          ? GoogleFonts.quicksand().fontFamily
                          : GoogleFonts.almarai().fontFamily,
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

//==========================================================================
  Widget showHistory(
      context, List<String> projectName, List<String> projectSearchInterest) {
    return Column(
      children: [
//history===============================================================
        projectName.isEmpty && query == ''
            ? const SizedBox()
            : SizedBox(
                height: 163.h,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
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
//history===========================================================================
                    Expanded(
                      child: ListView.builder(
                          itemCount: projectName.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              minLeadingWidth: 5.w,
                              onTap: () {
                                query = projectName[index];
                                showResults(context);
                              },
                              leading: const Icon(Icons.history),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText(
                                    text: projectName[index],
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
                              subtitle: AppText(
                                text: AppWidget.getTranslateSearchInterest(
                                    projectSearchInterest[index]),
                                fontSize: AppSize.subTextSize,
                                fontFamily: local.toString() == 'en'
                                    ? GoogleFonts.quicksand().fontFamily
                                    : GoogleFonts.almarai().fontFamily,
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
//Simeler text===========================================================================
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Row(
            children: [
              Text(
                LocaleKeys.similarProjects.tr(),
                style: TextStyle(
                    fontSize: AppSize.subTextSize,
                    color: AppColor.black,
                    fontFamily: local.toString() == 'en'
                        ? GoogleFonts.quicksand().fontFamily
                        : GoogleFonts.almarai().fontFamily,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
//Simeler list===========================================================================

        Expanded(
          child: StreamBuilder(
              stream: AppConstants.projectCollection
                  .where("status", isEqualTo: AppConstants.statusIsComplete)
                  .where("searchInterest",
                      isEqualTo: projectSearchInterest.isEmpty
                          ? ""
                          : projectSearchInterest[0])
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error check internet!"));
                }

                if (snapshot.hasData) {
                  return body(snapshot);
                }

                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColor.appBarColor,
                ));
              }),
        ),
      ],
    );
  }

//show data from database========================================================================
  Widget body(snapshot, {bool? showHorizontal}) {
    return snapshot.data.docs.isNotEmpty
        ? Consumer<ChangConstModel>(builder: (context, model, child) {
            return SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: ListView.builder(
                    scrollDirection: showHorizontal == true
                        ? Axis.horizontal
                        : Axis.vertical,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, i) {
                      var data = snapshot.data.docs[i].data();
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        height: 270.h,
                        child: Card(
                            color: AppColor.white,
                            elevation: 5,
                            child: ListTile(
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.h),
                                  Expanded(
                                      child: Container(
                                    decoration: AppWidget.decoration(
                                      color: AppColor.cherryLightPink,
                                    ),
                                    width: double.infinity,
                                    child: Center(
                                      child: AppText(
                                        fontSize: AppSize.subTextSize,
                                        text: LocaleKeys.projectName.tr() +
                                            ": ${data['name']}",
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                                  SizedBox(height: 20.h),
                                  Expanded(
                                      child: AppText(
                                    fontSize: AppSize.subTextSize,
                                    text: LocaleKeys.year.tr() +
                                        ": ${data['year']}",
                                    color: AppColor.appBarColor,
                                  )),
                                  Expanded(
                                      child: AppText(
                                    fontSize: AppSize.subTextSize,
                                    text:
                                        '${LocaleKeys.superVisorMajorTx.tr()}: ' +
                                            AppWidget.getTranslateMajor(
                                                data['major']),
                                    color: AppColor.appBarColor,
                                  )),
                                  Expanded(
                                      child: AppText(
                                    fontSize: AppSize.subTextSize,
                                    text: LocaleKeys.searchInterestTx.tr() +
                                        ": ${AppWidget.getTranslateSearchInterest(data['searchInterest'])}",
                                    color: AppColor.appBarColor,
                                  )),
                                  Expanded(
                                      child: AppText(
                                    fontSize: AppSize.subTextSize,
                                    text: LocaleKeys.mySuperVisor.tr() +
                                        ": ${data['superName']}",
                                    color: AppColor.appBarColor,
                                  )),
                                  Expanded(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
//view comment---------------------------------------------------------------------------------

                                      IconButton(
                                          onPressed: () {
                                            AppRoutes.pushTo(
                                                context,
                                                CommentPage(
                                                  name: name,
                                                  projectId: data['projectId'],
                                                  userId: userId,
                                                ));
                                          },
                                          icon: const Icon(Icons.comment)),
//view file---------------------------------------------------------------------------------
                                      IconButton(
                                          onPressed: () async {
                                            AppLoading.show(
                                                context, "", "lode");
                                            final file =
                                                await Database.lodeFirbase(
                                                        data['fileName'])
                                                    .whenComplete(() {
                                              Navigator.pop(context);
                                            });
                                            // ignore: unnecessary_null_comparison
                                            if (file == null) return;
                                            AppRoutes.pushTo(
                                                context,
                                                ViewPdf(
                                                  file: file,
                                                  fileName: data['fileName'],
                                                  link: data['link'],
                                                ));
                                          },
                                          icon: const Icon(
                                              Icons.view_carousel_sharp,
                                              color: AppColor.cherryLightPink)),
//dwonlode file---------------------------------------------------------------------------------
                                      IconButton(
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  DownloadingDialog(
                                                fileName: data['fileName'],
                                                url: data['link'],
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.download)),
//-----------------------------------------------------------------------------------------------
                                    ],
                                  )),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            )),
                      );
                    }),
              ),
            );
          })
        : Center(
            child: AppText(
                text: LocaleKeys.noData.tr(),
                fontSize: AppSize.subTextSize,
                fontWeight: FontWeight.bold),
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

//save Project Name =====================================================================
  saveProjectName(String searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }

//get Project Name =====================================================================
  Future<List<String>> getProjectName() async {
    final pref = await SharedPreferences.getInstance();
    // var allSearches = pref.getString(key) ?? [];
    final allSearches = pref.getStringList("recentSearches") ?? [];
    print('getProjectName= $allSearches');
    return allSearches;
  }

//save Sear Interest =====================================================================
  saveSearInterest(String searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches = pref.getStringList("recent")?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recent", allSearches.toList());
  }

//get Search Interest=====================================================================
  Future<List<String>> getSearchInterest() async {
    final pref = await SharedPreferences.getInstance();
    // var allSearches = pref.getString(key) ?? [];
    final allSearches = pref.getStringList("recent") ?? [];
    print('getSearchInterest= $allSearches');
    return allSearches;
  }
}
