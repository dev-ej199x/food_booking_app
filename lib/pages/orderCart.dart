import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';

class OrderCart extends StatefulWidget {
  @override
  _OrderCartState createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
            backgroundColor: Color(0xffeb4d4d),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => {},
            )),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60.0),
                    bottomRight: Radius.circular(60.0)),
                color: Color(0xffeb4d4d),
              ),
              child: Text(
                'CART',
                style: TextStyle(
                  fontSize: 2 * Config.textMultiplier,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 4 * Config.heightMultiplier,
                    horizontal: 7 * Config.widthMultiplier),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    color: Color(0xff494848),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(60.0),
                          ),
                          image: DecorationImage(
                            image: AssetImage(Images.menuLogo),
                            fit: BoxFit.fill,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(''),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'ADD ONs',
                          style: TextStyle(
                            fontSize: 1 * Config.textMultiplier,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: 5 * Config.heightMultiplier),
            child: Container(
              alignment: Alignment.bottomLeft,
              height: 200.0,
              width: 220.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xff393737),
              ),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 2 * Config.heightMultiplier),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 1 * Config.textMultiplier,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 1 * Config.textMultiplier,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 2 * Config.heightMultiplier),
                      child: Container(
                        height: 80,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Note',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 5.0,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 2 * Config.heightMultiplier),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 1 * Config.textMultiplier,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 1 * Config.textMultiplier,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 1 * Config.textMultiplier,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 10 * Config.heightMultiplier, horizontal: 5.0),
            child: Container(
              alignment: Alignment.bottomRight,
              height: 20.0,
              width: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: Color(0xff393737),
              ),
              child: Text(
                'Total Price',
                style: TextStyle(
                  fontSize: 4 * Config.textMultiplier,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 2 * Config.heightMultiplier,
                horizontal: 3 * Config.widthMultiplier),
            child: RaisedButton(
              onPressed: () {},
              color: Color(0xffFC4646),
              child: Text(
                '',
                style: TextStyle(
                  fontSize: 2 * Config.textMultiplier,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
