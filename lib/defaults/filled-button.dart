import 'package:food_booking_app/defaults/text.dart';
import 'package:flutter/material.dart';

import 'button.dart';
import 'config.dart';

class FilledCustomButton extends StatelessWidget {
  String text;
  Function onPressed;
  double padding;
  Color color;
  String type;
  
  FilledCustomButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    @required this.padding,
    @required this.color,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding * widthMultiplier),
      child: CustomButton(
        height: 6 * heightMultiplier,
        minWidth: 100 * widthMultiplier,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: type=='none'?null:MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular((type == 'rounded'?10:(type == 'roundedbox'?2:0)) * imageSizeMultiplier),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(color),
            alignment: Alignment.center,
            shadowColor: MaterialStateProperty.all(Color(0xFF707070).withOpacity(.25)),
            elevation: MaterialStateProperty.all(1.5 * imageSizeMultiplier)
          ),
          onPressed: onPressed,
          child: Container(
            height: 6 * heightMultiplier,
            width: 100 * widthMultiplier,
            alignment: Alignment.center,
            child: CustomText(
              text: text,
              align: TextAlign.center,
              color: Colors.white,
              size: 1.6,
              weight: FontWeight.normal,
            ),
          )
        )
      )
    );
  }
}