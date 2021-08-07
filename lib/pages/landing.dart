import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/firebase_settings.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/defaults/text.dart';
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
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  SharedPreferences _sharedPreferences;

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
          Navigator.of(context).pop();
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: LoginScreen(from: null),
            ),
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
      },
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          backgroundColor: appColor,
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
              _scaffoldKey.currentState.removeCurrentSnackBar();
            },
            child: Center(
              child: CustomText(
                text: 'CHEEBOOK',
                size: 4,
                color: Colors.white,
                weight: FontWeight.w300,
                align:TextAlign.left,
              ),
            ),
          ),
        )
      )
    );
  }
}
