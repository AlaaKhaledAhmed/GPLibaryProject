import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'AppSize.dart';
import 'AppText.dart';
import 'AppColors.dart';

class AppDropList extends StatelessWidget {
  final List<String> listItem;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? dropValue;
  final void Function(String?)? onChanged;
  const AppDropList(
      {Key? key,
      required this.listItem,
      required this.validator,
      required this.hintText,
      required this.onChanged,
      required this.dropValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: DropdownButtonFormField2<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        hint: AppText(
          fontSize: AppSize.textFieldsFontSize,
          text: hintText ?? '',
          color: AppColor.labelTextFieldsColor,
        ),
        items: listItem
            .map((item) => DropdownMenuItem(
                  // alignment: Alignment.centerRight,
                  value: item,
                  child: AppText(
                    fontSize: AppSize.textFieldsFontSize,
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
                  BorderRadius.circular(AppSize.textFieldsBorderRadius),
              borderSide: BorderSide(
                color: Colors.blue,
                width: AppSize.textFieldsBorderWidth,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppSize.textFieldsBorderRadius),
              borderSide: BorderSide(
                color: AppColor.buttonsColor,
                width: AppSize.textFieldsBorderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppSize.textFieldsBorderRadius),
              borderSide: BorderSide(
                color: AppColor.textFieldBorderColor,
                width: AppSize.textFieldsBorderWidth,
              ),
            ),
            //labelText: labelText,
            //errorStyle: TextStyle(color: AppColor.errorColor, fontSize: WidgetSize.errorSize),
            contentPadding: EdgeInsets.all(AppSize.dropListContentPadding)),
        onChanged: onChanged,
        dropdownMaxHeight: 300.h,
        dropdownDecoration: BoxDecoration(

            color: AppColor.white,
            borderRadius: BorderRadius.all(
                Radius.circular(AppSize.textFieldsBorderRadius))),
        iconDisabledColor: AppColor.buttonsColor,
        iconEnabledColor: AppColor.buttonsColor,

        scrollbarAlwaysShow: true,
      ),
    );
  }
}
