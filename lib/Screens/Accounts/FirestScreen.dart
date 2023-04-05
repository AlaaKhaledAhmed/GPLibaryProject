import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Widget/AppRoutes.dart';
import 'Login.dart';


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
           AppRoutes.pushTo(context,  Login());
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
