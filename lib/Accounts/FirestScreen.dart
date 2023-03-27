import 'package:flutter/material.dart';
import 'package:library_project/Accounts/Logging.dart';

import '../Model/Routs.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
         onTap: (){
           Routes.pushTo(context, const Login());
         },
        child: Container(
          decoration: const BoxDecoration(),
          height: double.infinity,
          width: double.infinity,

        ),
      ),
    );
  }
}
