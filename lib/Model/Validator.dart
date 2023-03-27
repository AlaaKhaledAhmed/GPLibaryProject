import 'package:library_project/Model/Messages.dart';

class Validator{

  static String? validatorEmpty(String v){
   if(v.isEmpty){
     return Messages.mandatoryTx;
   }else{
     return null;
   }

  }
}