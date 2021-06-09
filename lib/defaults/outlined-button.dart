import 'package:food_booking_app/defaults/text.dart';
import 'package:flutter/material.dart';

import 'button.dart';
import 'config.dart';

class OutlinedCustomButton extends StatelessWidget {
  String text;
  Function onPressed;
  double padding;
  
  OutlinedCustomButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    @required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding * widthMultiplier),
      child: CustomButton(
        height: 6 * heightMultiplier,
        minWidth: 100 * widthMultiplier,
        child: FlatButton(
          splashColor: Colors.white.withOpacity(.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10 * imageSizeMultiplier),
            side: BorderSide(color: appColor)
          ),
          height: 6 * heightMultiplier,
          minWidth: 100 * widthMultiplier,
          onPressed: onPressed,
          child: CustomText(
            text: text,
            align: TextAlign.center,
            color: appColor,
            size: 1.9 * textMultiplier,
            weight: FontWeight.normal,
          ),
        )
      )
    );
  }
}