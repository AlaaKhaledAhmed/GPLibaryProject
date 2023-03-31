import 'package:flutter/material.dart';
import 'package:library_project/Widget/Colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_project/Model/translations/codegen_loader.g.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Screens/Accounts/Logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(413, 763),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            //visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: context.locale.toString() == 'en'
                ? GoogleFonts.quicksand().fontFamily
                : GoogleFonts.notoKufiArabic().fontFamily, //"DroidKufi",
            scaffoldBackgroundColor: AppColor.white,
          ),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
        
          home: const Login(),
        );
      },
    );

  }
}
