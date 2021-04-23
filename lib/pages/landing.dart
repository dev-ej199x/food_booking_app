import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/flutter_setting.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/pages/dashBoard.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashBoard.dart';
import 'dashBoard.dart';
import 'login.dart';
import 'signUp.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
    }
    else {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: LoginScreen(from: null),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int count = 0;
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        count++;
        if (count == 3) {
          timer.cancel();
          _configure();
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFEB4D4D),
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Text(
            'COMPANY NAME',
            textScaleFactor: 1,
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 4 * Config.textMultiplier,
              color: Colors.white,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
