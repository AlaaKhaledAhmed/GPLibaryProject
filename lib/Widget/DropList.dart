import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Model/WidgetSize.dart';
import 'AppText.dart';
import 'Colors.dart';

class DropList extends StatelessWidget {
  final List<String> listItem;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? dropValue;
  final void Function(String?)? onChanged;
  const DropList(
      {Key? key,
      required this.listItem,
      required this.validator,
      required this.hintText,
      required this.onChanged,
      required this.dropValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      hint: AppText(
        fontSize: WidgetSize.textFieldsFontSize,
        text: hintText ?? '',
        color: AppColor.labelTextFieldsColor,
      ),
      items: listItem
          .map((item) => DropdownMenuItem(
                // alignment: Alignment.centerRight,
                value: item,
                child: AppText(
                  fontSize: WidgetSize.textFieldsFontSize,
                  text: item,
                  color: AppColor.labelTextFieldsColor,
                ),
              ))
          .toList(),
      value: dropValue,
      decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColor.white,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(WidgetSize.textFieldsBorderRadius),
            borderSide: BorderSide(
              color: Colors.blue,
              width: WidgetSize.textFieldsBorderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(WidgetSize.textFieldsBorderRadius),
            borderSide: BorderSide(
              color: AppColor.buttonsColor,
              width: WidgetSize.textFieldsBorderWidth,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(WidgetSize.textFieldsBorderRadius),
            borderSide: BorderSide(
              color: AppColor.textFieldBorderColor,
              width: WidgetSize.textFieldsBorderWidth,
            ),
          ),
          //labelText: labelText,
          //errorStyle: TextStyle(color: AppColor.errorColor, fontSize: WidgetSize.errorSize),
          contentPadding: EdgeInsets.all(WidgetSize.dropListContentPadding)),
      onChanged: onChanged,
      dropdownMaxHeight: 300.h,
      dropdownDecoration: BoxDecoration(

          color: AppColor.buttonsColor,
          borderRadius: BorderRadius.all(
              Radius.circular(WidgetSize.textFieldsBorderRadius))),
      iconDisabledColor: AppColor.buttonsColor,
      iconEnabledColor: AppColor.buttonsColor,

      scrollbarAlwaysShow: true,
    );
  }
}
