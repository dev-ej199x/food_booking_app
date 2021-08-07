import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_booking_app/pages/dashBoard.dart';
import 'package:food_booking_app/pages/landing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'defaults/firebase_settings.dart';
import 'defaults/config.dart';
import 'defaults/http.dart';

SharedPreferences _sharedPreferences;

_configure() async {
  bool loggedIn = false;
  if (_sharedPreferences.containsKey('token')) {
    var response = await Http(url: 'user').getWithHeader();
    if (response is Response) {
      if (response.statusCode == 200) {
        await FirebaseSettings().updateToken();
        loggedIn = true;
      }
    }
  }

  if (!loggedIn) _sharedPreferences.clear();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  _configure();
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
              theme: ThemeData.light().copyWith(accentColor: Color(0xFFED1F56), primaryColor: Color(0xFFED1F56), splashColor: Colors.black12.withOpacity(0.05)),
              debugShowCheckedModeBanner: false,
              title: 'Cheebook',
              home: _sharedPreferences.containsKey('token')?DashBoard():LandingScreen(),
            );
          },
        );
      },
    );
  }
}