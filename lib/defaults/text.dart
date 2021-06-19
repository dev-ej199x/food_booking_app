import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';

class CustomText extends StatelessWidget {
  String text;
  Color color;
  double size;
  FontWeight weight;
  TextAlign align;
  double spacing;
  
  CustomText({
    Key key,
    @required this.text,
    @required this.color,
    @required this.size,
    @required this.weight,
    @required this.align,
    this.spacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: 1,
      textAlign: align,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: size * textMultiplier,
        color: color,
        fontWeight: weight,
        // letterSpacing: (spacing??0) * widthMultiplier
      ),
    );
  }
}