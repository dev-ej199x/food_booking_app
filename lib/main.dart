import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_booking_app/pages/dashBoard.dart';
import 'package:food_booking_app/pages/landing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'defaults/firebase_settings.dart';
import 'defaults/config.dart';

SharedPreferences _sharedPrefences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _sharedPrefences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            FirebaseSettings().init(context);
            Config().init(constraints, orientation);
            return MaterialApp(
              theme: ThemeData.light().copyWith(accentColor: Color(0xFFED1F56), splashColor:  Color(0xFFED1F56)),
              debugShowCheckedModeBanner: false,
              title: 'Cheebook',
              home: _sharedPrefences.containsKey('token')?DashBoard():LandingScreen(),
            );
          },
        );
      },
    );
  }
}