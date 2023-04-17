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
import '../../../Widget/AppWidget.dart';

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
  @override
  Widget buildResults(BuildContext context) {
    saveToRecentSearchesSupervisor(query);
    return StreamBuilder(
        stream: userCollection.where("name", isEqualTo: query).snapshots(),
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
    getRecentSearchesCelebrity().then((value) {
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
        ? const SizedBox()
        : query.isEmpty && _oldFilters.isNotEmpty
            ? showHistory(context, _oldFilters)
            : getSuggestionList(listSearch);
  }

//save To Recent Searches Celebrity=====================================================================
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

//save To Recent Searches Celebrity=====================================================================
  Future<List<String>> getRecentSearchesCelebrity() async {
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
                        color: AppColor.iconColor,
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

  //save To Recent Searches Celebrity=====================================================================
  Widget showHistory(context, List suggestions) {
    // print('history suggestions $suggestions');
    return suggestions.isEmpty && query == ''
        ? const SizedBox()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 22.w, top: 15.h),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "عمليات البحث الأخيرة",
                          style: TextStyle(
                            fontSize: 17.sp,
                            color: AppColor.black,
                            fontFamily: local.toString() == 'en'
                                ? GoogleFonts.quicksand().fontFamily
                                : GoogleFonts.almarai().fontFamily,
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 22.w, top: 15.h),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            // removeHistory();
                            query = '';

                            removeHistory();
                          },
                          child: Text(
                            'مسح',
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: AppColor.iconColor,
                              fontFamily: local.toString() == 'en'
                                  ? GoogleFonts.quicksand().fontFamily
                                  : GoogleFonts.almarai().fontFamily,
                            ),
                          ),
                        )),
                  ),
                ],
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
                              color: AppColor.iconColor,
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
    return Container(
      height: AppWidget.getHeight(context) * 0.55,
      decoration: AppWidget.decoration(radius: 10.r, color: AppColor.noColor),
      width: AppWidget.getWidth(context),
      child: snapshot.data.docs.length >= 0
          ? Container(
              height: AppWidget.getHeight(context) * 0.55,
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
                        height: 120,
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
                                text: data['name'],
                                fontSize: AppSize.title2TextSize,
                                fontFamily: local.toString() == 'en'
                                    ? GoogleFonts.quicksand().fontFamily
                                    : GoogleFonts.almarai().fontFamily,
                              ),
                            ),
//search interest=================================================================
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: AppText(
                                text: AppWidget.getTranslate(
                                    data['searchInterest']),
                                fontSize: AppSize.title2TextSize,
                                fontFamily: local.toString() == 'en'
                                    ? GoogleFonts.quicksand().fontFamily
                                    : GoogleFonts.almarai().fontFamily,
                              ),
                            ),
//send icon=================================================================
                            trailing: Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(
                                    local.toString() == 'en' ? 0 : math.pi),
                                child: SvgPicture.asset(
                                  AppSvg.sendSvg,
                                  height: 40.r,
                                  width: 40.r,
                                ),
                              ),
                            ),
                          ),
//==========================================================================
                        ),
                      ),
                    );
                  }),
            )
          : Center(
              child: Padding(
                  padding:
                      EdgeInsets.only(top: AppWidget.getHeight(context) / 2),
                  child: AppText(
                      color: Colors.black,
                      text: LocaleKeys.noData.tr(),
                      fontSize: AppSize.titleTextSize,
                      fontWeight: FontWeight.bold)),
            ),
    );
  }
}
