// import 'package:carousel_pro/carousel_pro.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/pages/orderScreen.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
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
  List _restaurants = [];
  String dropdownValue = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getEstablishments();
    });
  }

  _onTheGo(int index, List<String> quantity) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              // backgroundColor: Color(0xff747473),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(3 * Config.imageSizeMultiplier),
                ),
              ),
              content: Container(
                height: 35 * Config.widthMultiplier,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'No. of Person\'s',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: 2.2 * Config.textMultiplier,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 5 * Config.heightMultiplier,
                        margin: EdgeInsets.symmetric(
                            horizontal: 20 * Config.widthMultiplier,
                            vertical: 1 * Config.heightMultiplier),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(
                                10 * Config.imageSizeMultiplier)),
                        child: DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValue,
                            icon: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xffF85A5A),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                          10 * Config.imageSizeMultiplier),
                                      bottomRight: Radius.circular(
                                          10 * Config.imageSizeMultiplier))),
                              child: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.white,
                              ),
                            ),
                            iconSize: 42,
                            underline: SizedBox(),
                            onChanged: (String newValue) {
                              // print(newValue);
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: quantity
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 3 * Config.textMultiplier),
                                  child: Text(
                                    value,
                                    textDirection: TextDirection.rtl,
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList()),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10 * Config.widthMultiplier,
                          right: 10 * Config.widthMultiplier,
                        ),
                        child: ButtonTheme(
                          height: 5 * Config.heightMultiplier,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4 * Config.widthMultiplier),
                            onPressed: () {
                              // print(_restaurants[index]);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: OrderScreen(
                                    details: _restaurants[index],
                                  ),
                                ),
                              );
                            },
                            color: Color(0xffE44D36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10 * Config.imageSizeMultiplier),
                            ),
                            child: Container(
                              child: Center(
                                child: Text(
                                  "Proceed",
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                      fontSize: 2.2 * Config.textMultiplier,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  _booking(int index, List<String> quantity) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            // backgroundColor: Color(0xff747473),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3 * Config.imageSizeMultiplier),
              ),
            ),
            content: Container(
              height: 53 * Config.widthMultiplier,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'No. of Person\'s',
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 2.2 * Config.textMultiplier,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 5 * Config.heightMultiplier,
                      margin: EdgeInsets.symmetric(
                          horizontal: 20 * Config.widthMultiplier,
                          vertical: 1 * Config.heightMultiplier),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(
                              10 * Config.imageSizeMultiplier)),
                      child: DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownValue,
                          icon: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffF85A5A),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        10 * Config.imageSizeMultiplier),
                                    bottomRight: Radius.circular(
                                        10 * Config.imageSizeMultiplier))),
                            child: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Colors.white,
                            ),
                          ),
                          iconSize: 42,
                          underline: SizedBox(),
                          onChanged: (String newValue) {
                            // print(newValue);
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: quantity
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 3 * Config.textMultiplier),
                                child: Text(
                                  value,
                                  textDirection: TextDirection.rtl,
                                  // textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }).toList()),
                    ),
                    Text(
                      'Book Time',
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 2.2 * Config.textMultiplier,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 18 * Config.widthMultiplier,
                          vertical: 1 * Config.heightMultiplier),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(
                              10 * Config.imageSizeMultiplier)),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 3 * Config.widthMultiplier),
                            child: Text(
                              'asdsa',
                              textScaleFactor: 1,
                              style: TextStyle(
                                  fontSize: 2.2 * Config.textMultiplier,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xffF85A5A),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        10 * Config.imageSizeMultiplier),
                                    bottomRight: Radius.circular(
                                        10 * Config.imageSizeMultiplier))),
                            child: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10 * Config.widthMultiplier,
                          right: 10 * Config.widthMultiplier,
                          top: .5 * Config.heightMultiplier),
                      child: ButtonTheme(
                        height: 5 * Config.heightMultiplier,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4 * Config.widthMultiplier),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child:
                                    OrderScreen(details: _restaurants[index]),
                              ),
                            );
                          },
                          color: Color(0xffE44D36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10 * Config.imageSizeMultiplier),
                          ),
                          child: Container(
                            child: Center(
                              child: Text(
                                "Proceed",
                                textScaleFactor: 1,
                                style: TextStyle(
                                    fontSize: 2.2 * Config.textMultiplier,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _createAlertDialog(int index) {
    return showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(.6),
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            // backgroundColor: Color(0xff747473),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3 * Config.imageSizeMultiplier),
              ),
            ),
            content: Container(
              width: 70 * Config.widthMultiplier,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        List<String> quantity = [];
                        setState(() {
                          dropdownValue = '1';
                        });
                        for (int x = 1;
                            x <=
                                _restaurants[index]
                                    ['max_persons_per_restaurant'];
                            x++) {
                          quantity.add(x.toString());
                        }
                        // print(quantity);
                        _onTheGo(index, quantity);
                      },
                      // color: Color(0xffD32F2F),
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(Colors.red),
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xfff96167),
                        ),
                      ),
                      child: Text(
                        'On the Go',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        List<String> quantity = [];
                        setState(() {
                          dropdownValue = '1';
                        });
                        for (int x = 1;
                            x <=
                                _restaurants[index]
                                    ['max_persons_per_restaurant'];
                            x++) {
                          quantity.add(x.toString());
                        }
                        // print(quantity);
                        _booking(index, quantity);
                      },
                      // color: Color(0xffD32F2F),
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(Colors.red),
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xfff96167),
                        ),
                      ),
                      child: Text(
                        'Book',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
    Http().showLoadingOverlay(context);
    var response = await Http(url: 'restaurants', body: {}).getWithHeader();
    // log(response.body);
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
        Navigator.pop(context);
        Map<String, dynamic> body = json.decode(response.body);
        List<Map<String, dynamic>> restaurants = [];
        body['restaurant'].forEach((restaurant) {
          List<Map<String, dynamic>> categories = [];
          restaurant['product_category'].forEach((category) {
            List<Map<String, dynamic>> product = [];
            category['products'].forEach((products) {
              List<Map<String, dynamic>> variant = [];
              products['variants'].forEach((variants) {
                List<Map<String, dynamic>> productoption = [];
                variants['product_option'].forEach((productOptions) {
                  List<Map<String, dynamic>> productoptionitem = [];
                  productOptions['product_option_items']
                      .forEach((productOptionItem) {
                    productoptionitem.add({
                      "productOptItmId": productOptionItem['id'],
                      "productOptItmName": productOptionItem['item_name'],
                      "productOptItmPrice": productOptionItem['price'],
                    });
                  });
                  productoption.add({
                    "productOptId": productOptions['id'],
                    "productOptName": productOptions['name'],
                    "productOptType": productOptions['type'],
                    "productOptSelection": productOptions['selection'],
                    "productOptionItem": productoptionitem,
                  });
                });
                variant.add({
                  "variantId": variants['id'],
                  "variantName": variants['name'],
                  "variantPrice": variants['price'],
                  "variantDescription": variants['description'],
                  "variantBanner": variants['image'],
                  "vairantOption": productoption,
                });
              });
              product.add({
                "productId": products['id'],
                "productName": products['name'],
                "productDescription": products['description'],
                "banner": products['image'],
                "productVariants": variant,
              });
            });
            categories.add({
              "categoriesID": category['id'],
              "categoriesName": category['name'],
              "products": product,
            });
          });
          restaurants.add({
            "id": restaurant['id'],
            "name": restaurant['name'],
            "opentime": restaurant['opening_time'],
            "closetime": restaurant['closing_time'],
            "distance": restaurant['address'],
            "max_persons_per_restaurant": 6,
            "productCategories": categories,
          });
        });
        setState(() {
          _restaurants = new List.from(restaurants);
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
                        child: ListView.builder(
                          itemCount: _restaurants.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.1 * Config.heightMultiplier),
                            child: FlatButton(
                              onPressed: () {
                                _createAlertDialog(index);
                              },
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
                                                _restaurants[index]['name'],
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
                                                '${_restaurants[index]['opentime']} - ${_restaurants[index]['closetime']}',
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
                                              _restaurants[index]['distance'],
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
