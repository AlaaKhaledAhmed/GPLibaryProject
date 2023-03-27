import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_project/Widget/Colors.dart';

import '../Model/WidgetSize.dart';

class AppTextFields extends StatelessWidget {
  final bool obscureText = false;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? labelText;
  final FontWeight? fontWeight;
  const AppTextFields({
    Key? key,
    required this.validator,
    this.inputFormatters,
    this.keyboardType,
    required this.controller,
    required this.labelText,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: false,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      controller: controller,
      style: TextStyle(color: AppColor.mainTextFieldsColor, fontSize: WidgetSize.textFieldsFontSize),
      decoration: InputDecoration(
          isDense: true,
          filled: true,
          hintStyle: TextStyle(color: AppColor.labelTextFieldsColor, fontSize: WidgetSize.textFieldsHintSize),
          fillColor: AppColor.white,
          labelStyle: TextStyle(color:  AppColor.labelTextFieldsColor, fontSize: WidgetSize.textFieldsFontSize),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(WidgetSize.textFieldsBorderRadius),
            borderSide:  BorderSide(
              color: Colors.blue,
              width:  WidgetSize.textFieldsBorderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(WidgetSize.textFieldsBorderRadius),
            borderSide:  BorderSide(
              color: Colors.pink,
              width: WidgetSize.textFieldsBorderWidth,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(WidgetSize.textFieldsBorderRadius),
            borderSide:  BorderSide(
              color: AppColor.textFieldBorderColor,
              width:  WidgetSize.textFieldsBorderWidth,
            ),
          ),
          labelText: labelText,
          //errorStyle: TextStyle(color: AppColor.errorColor, fontSize: WidgetSize.errorSize),
          contentPadding: EdgeInsets.all(WidgetSize.contentPadding)),
    );
  }
}
