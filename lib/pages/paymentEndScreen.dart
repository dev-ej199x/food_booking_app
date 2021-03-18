import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';

class PaymentEndScreen extends StatefulWidget {
  @override
  _PaymentEndScreenState createState() => _PaymentEndScreenState();
}

class _PaymentEndScreenState extends State<PaymentEndScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(43.0),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 100.0),
                  color: Color(0xff323030),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(43.0),
                      topRight: Radius.circular(43.0),
                    ),
                  ),
                  child: Text(
                    'Payment Method',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 5 * Config.textMultiplier,
                      color: const Color(0xffffffff),
                    ),
                  ),
                ),
                Container(
                  height: 221,
                  width: 175,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(Images.thankYou)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 3 * Config.heightMultiplier),
                  child: Text(
                    'THANK YOU!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 6 * Config.textMultiplier,
                      color: const Color(0xff5F5959),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 2 * Config.heightMultiplier,
                      horizontal: 8 * Config.widthMultiplier),
                  child: ButtonTheme(
                      height: 5 * Config.heightMultiplier,
                      child: RaisedButton(
                        onPressed: () {},
                        color: Color(0xFFFC4646),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10 * Config.imageSizeMultiplier),
                        ),
                        splashColor: Colors.white.withOpacity(.4),
                        child: Container(
                          child: Center(
                            child: Text(
                              "Done",
                              textScaleFactor: 1,
                              style: TextStyle(
                                  fontSize: 3 * Config.textMultiplier,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
