import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Widget child;
  double height;
  double minWidth;
  
  CustomButton({
    Key key,
    @required this.child,
    @required this.height,
    @required this.minWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: height,
      minWidth: minWidth,
      splashColor: Colors.white.withOpacity(.2),
      highlightColor: Colors.white.withOpacity(.2),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: child,
    );
  }
}