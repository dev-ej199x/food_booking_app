import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_booking_app/pages/landing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'defaults/firebase_settings.dart';
import 'defaults/config.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
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
              theme: ThemeData.light().copyWith(primaryColor: Color(0xFFFEB4D4D), accentColor: Colors.black),
              debugShowCheckedModeBanner: false,
              title: 'Cheebook',
              home: LandingScreen(),
            );
          },
        );
      },
    );
  }
}