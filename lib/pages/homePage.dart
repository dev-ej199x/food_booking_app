// import 'package:carousel_pro/carousel_pro.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:http/http.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../defaults/config.dart';
import '../defaults/config.dart';
import '../defaults/config.dart';
import '../defaults/config.dart';
import '../defaults/http.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final List _sampleOrderInfo = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('HOY');
    _getEstablishments();
  }

  _createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xff484545),
            content: Container(
              width: 80 * Config.widthMultiplier,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text(
                        'On the Go',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: Text(
                      'OR',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text(
                        'Book',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _getEstablishments() async {
    // Http().showLoadingOverlay(context);
    var response = await Http(url: 'restaurants', body: {}).getWithHeader();
    log(response.body);
    if (response is String) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text(
            response,
            textScaleFactor: .8,
            style: TextStyle(
              color: Colors.white,
              fontSize: 2.2 * Config.textMultiplier,
            ),
          ),
        ),
      );
    } else if (response is Response) {
      if (response.statusCode != 200) {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF323232),
            content: Text(
              response.body,
              textScaleFactor: .8,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 2.2 * Config.textMultiplier,
              ),
            ),
          ),
        );
      } else {
        Map<String, dynamic> body = json.decode(response.body);
        body['restaurant'].forEach((restaurant) {
          print({
            "name": restaurant['name'],
            "opentime": restaurant['opening_time'],
            "closetime": restaurant['closing_time'],
            "distance": restaurant['address'],
          });
          setState(() {
            _sampleOrderInfo.add({
              "name": restaurant['name'],
              "opentime": restaurant['opening_time'],
              "closetime": restaurant['closing_time'],
              "distance": restaurant['address'],
            });
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Color(0xffeb4d4d),
          elevation: 0,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    height: 100.0,
                    width: double.infinity,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 150.0,
                        enlargeCenterPage: false,
                        viewportFraction: 1,
                        autoPlay: true,
                      ),
                      items: [
                        Image.asset(
                          'assets/images/Mask Group 2.png',
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                        Image.asset(
                          'assets/images/Restaurant.jpg',
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      ].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return i;
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: Container(
                        height: 40.0,
                        width: 80 * Config.widthMultiplier,
                        margin: EdgeInsets.only(top: 80.0),
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              2 * Config.imageSizeMultiplier),
                          // border: Border.all(color: Colors.grey[800]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.4),
                              offset: Offset(0, 1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.grey[800]),
                            hintText: ('Search Restaurant'),
                            hintStyle: TextStyle(
                              color: Colors.grey[800],
                              fontFamily: 'Segoe UI',
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // Establishment Banner
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0,
                            left: 8 * Config.widthMultiplier,
                            right: 8 * Config.widthMultiplier),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Featured Restaurant',
                                style: TextStyle(
                                    fontSize: 2 * Config.textMultiplier,
                                    fontFamily: 'Segoe UI',
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xff707070)),
                              ),
                              TextButton(
                                child: Text(
                                  'See All Featured',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                      fontSize: 1.2 * Config.textMultiplier,
                                      fontFamily: 'Segoe UI',
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff707070)),
                                ),
                              ),
                            ]),
                      ),
                      // featured restaurant information
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: Container(
                          height: 150.0,
                          width: double.infinity,
                          child: CarouselSlider(
                            options: CarouselOptions(
                                enlargeCenterPage: true, viewportFraction: .7),
                            items: [
                              Image.asset(
                                'assets/images/CoffeeShop.png',
                                fit: BoxFit.fill,
                                width: double.infinity,
                              ),
                              Image.asset(
                                'assets/images/Restaurant.jpg',
                                fit: BoxFit.fill,
                                width: double.infinity,
                              ),
                              Image.asset(
                                'assets/images/Pastry.jpg',
                                fit: BoxFit.fill,
                                width: double.infinity,
                              )
                            ].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return i;
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 5.0,
                            left: 8 * Config.widthMultiplier,
                            right: 8 * Config.widthMultiplier),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Nearby Restaurants',
                              style: TextStyle(
                                  fontSize: 2 * Config.textMultiplier,
                                  fontFamily: 'Segoe UI',
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  color: Color(0xff707070)),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'See All Nearby',
                                style: TextStyle(
                                    fontSize: 1.2 * Config.textMultiplier,
                                    fontFamily: 'Segoe UI',
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xff707070)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 200.0,
                        width: double.infinity,
                        padding: EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            _createAlertDialog(context);
                          },
                          child: ListView.builder(
                            itemCount: _sampleOrderInfo.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.1 * Config.heightMultiplier),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    vertical: 1 * Config.heightMultiplier,
                                    horizontal: 0.4 * Config.widthMultiplier),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.topLeft,
                                      colors: [
                                        Colors.orange.shade900,
                                        Colors.white60
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        2 * Config.imageSizeMultiplier)),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 2 * Config.widthMultiplier),
                                          child: Image(
                                            image: AssetImage(
                                                Images.sampleRestaurant),
                                            fit: BoxFit.fill,
                                            width:
                                                40 * Config.imageSizeMultiplier,
                                            height:
                                                10 * Config.imageSizeMultiplier,
                                          ),
                                        ),
                                        // SizedBox(width: 27.0),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right:
                                                  1.8 * Config.widthMultiplier),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                _sampleOrderInfo[index]['name'],
                                                style: TextStyle(
                                                  fontSize: 2.5 *
                                                      Config.textMultiplier,
                                                  fontFamily: 'Segoe UI',
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                '${_sampleOrderInfo[index]['opentime']} - ${_sampleOrderInfo[index]['closetime']}',
                                                style: TextStyle(
                                                  fontSize: 1.4 *
                                                      Config.textMultiplier,
                                                  fontFamily: 'Segoe UI',
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                2.5 * Config.widthMultiplier),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SmoothStarRating(
                                              starCount: 5,
                                            ),
                                            Text(
                                              _sampleOrderInfo[index]
                                                  ['distance'],
                                              style: TextStyle(
                                                fontSize:
                                                    2 * Config.textMultiplier,
                                                fontFamily: 'Segoe UI',
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
