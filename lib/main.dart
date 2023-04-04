import 'package:flutter/material.dart';
import 'package:library_project/Screens/Student/NavStudent.dart';
import 'package:library_project/Widget/Colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:library_project/Model/translations/codegen_loader.g.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'Screens/Accounts/Login.dart';

//token: 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
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child:
      //rebuild app
      Phoenix(child: const MyApp())));
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
                : GoogleFonts.almarai().fontFamily,
            //"DroidKufi",
            scaffoldBackgroundColor: AppColor.white70,
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
