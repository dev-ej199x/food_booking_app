import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(43.0),
          ),
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
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Delivery Address',
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 2 * Config.textMultiplier,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.bold),
                //Here is the maping of address API
              ),
              Text(
                'Land Mark',
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 2 * Config.textMultiplier,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3 * Config.widthMultiplier),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Payment Cards',
                          textAlign: TextAlign.center,
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 1 * Config.textMultiplier,
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.bold),
                        ),
                        // Widgets of Different Bank Cards
                        RaisedButton(
                          color: Color(0xff3CE78C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          onPressed: () {},
                          child: Text("Cash",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3 * Config.widthMultiplier),
                    child: Container(
                      width: 1.0,
                      height: 113.0,
                      color: Color(0xffCEC9C9),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3 * Config.widthMultiplier),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Sub Fee',
                              textAlign: TextAlign.center,
                              textScaleFactor: 1,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 2 * Config.textMultiplier,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.bold),
                            ),
                            // Insert here API of payment
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Service Fee',
                              textAlign: TextAlign.center,
                              textScaleFactor: 1,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 2 * Config.textMultiplier,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.bold),
                            ),
                            // Insert here API of payment
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Grand Total',
                              textAlign: TextAlign.center,
                              textScaleFactor: 1,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 2 * Config.textMultiplier,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.bold),
                            ),
                            // Insert here API of payment
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 3 * Config.heightMultiplier),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        color: Color(0xffFC4646),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        onPressed: () {},
                        child: Text("Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      RaisedButton(
                        color: Color(0xffFC4646),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        onPressed: () {},
                        child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
