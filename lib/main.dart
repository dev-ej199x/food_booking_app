import 'package:flutter/material.dart';
import 'package:food_booking_app/pages/landing.dart';
import 'package:food_booking_app/pages/login.dart';
import 'package:food_booking_app/pages/address.dart';
import 'package:food_booking_app/pages/dashBoard.dart';
import 'package:food_booking_app/pages/navigation.dart';
import 'package:food_booking_app/pages/orderScreen.dart';
import 'package:food_booking_app/pages/orderWithVariants.dart';
import 'package:food_booking_app/pages/paymentScreen.dart';
import 'package:food_booking_app/pages/profile.dart';
import 'package:food_booking_app/pages/signUp.dart';
import 'package:food_booking_app/defaults/appbar.dart';

import 'defaults/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        Config().init(constraints, orientation);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Food Booking',
          home: LandingScreen()
        );
      });
    });
  }
}
