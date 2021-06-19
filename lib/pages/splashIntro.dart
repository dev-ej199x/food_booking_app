import 'package:flutter/material.dart';
import 'package:food_booking_app/pages/dashBoard.dart';
import 'package:food_booking_app/pages/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashIntroScreen extends StatefulWidget {
  @override
  _SplashIntroScreenState createState() => _SplashIntroScreenState();
}

class _SplashIntroScreenState extends State<SplashIntroScreen> {
  SharedPreferences _sharedPreferences;
  _configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setBool('not-first-open', false);
    if (_sharedPreferences.getString('token') != null) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: DashBoard(),
        ),
      );
    } else {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: LoginScreen(
            from: null,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _configure();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFED1F56),
    );
  }
}
