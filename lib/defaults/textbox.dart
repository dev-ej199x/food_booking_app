import 'package:food_booking_app/defaults/text.dart';
import 'package:flutter/material.dart';

import 'text.dart';
import 'button.dart';
import 'config.dart';

class CustomTextBox extends StatelessWidget {
  TextEditingController controller;
  FocusNode focusNode;
  String text;
  bool obscureText;
  bool enabled;
  bool border;
  bool shadow;
  Function(String) onSubmitted;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  double padding;
  Widget prefixIcon;
  Widget suffixIcon;
  String type;
  
  CustomTextBox({
    Key key,
    @required this.controller,
    @required this.focusNode,
    @required this.text,
    @required this.obscureText,
    @required this.enabled,
    @required this.border,
    @required this.shadow,
    @required this.onSubmitted,
    @required this.keyboardType,
    @required this.textInputAction,
    @required this.padding,
    @required this.prefixIcon,
    @required this.suffixIcon,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding * widthMultiplier),
      child: Container(
        padding: EdgeInsets.only(left: (prefixIcon == null? 6:2) * widthMultiplier, right: (suffixIcon == null? 6:2) * widthMultiplier),
        decoration: type=='none'?null:BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular((type == 'rounded'?10:(type == 'roundedbox'?2:0)) * imageSizeMultiplier),
          border: border?Border.all(color: Color(0xFF707070).withOpacity(.25)):null,
          boxShadow: shadow?[
            BoxShadow(color: Color(0xFF707070).withOpacity(.25), blurRadius: 1 * imageSizeMultiplier, offset: Offset(0, 3))
          ]:[]
        ),
        height: 6 * heightMultiplier,
        width: 100 * widthMultiplier,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                enabled: enabled,
                controller: controller,
                focusNode: focusNode,
                obscureText: obscureText,
                onFieldSubmitted: onSubmitted,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  focusColor: appColor,
                  prefixIconConstraints: BoxConstraints(minWidth: 11 * widthMultiplier, minHeight: 0),
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  hintText: text,
                  border: type == 'none'?null:InputBorder.none,
                  hintStyle: TextStyle(
                    fontFamily: 'Metropolis',
                    color: Color(0xFFB6B7B7),
                    fontSize: 1.8 * textMultiplier,
                    fontWeight: FontWeight.normal
                  )
                ).copyWith(isDense: true),
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  color: Colors.black,
                  fontSize: 1.8 * textMultiplier,
                  fontWeight: FontWeight.normal
                ),
              )
            ),
          ],
        )
      )
    );
  }
}