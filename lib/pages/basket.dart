import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_booking_app/defaults/button.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/filled-button.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:food_booking_app/defaults/textbox.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'orderCart.dart';

class BasketScren extends StatefulWidget {
  BasketScren(
      {Key key})
      : super(key: key);
  @override
  _BasketScrenState createState() => _BasketScrenState();
}

class _BasketScrenState extends State<BasketScren> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  SharedPreferences _sharedPreferences;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _loading = false;
  var _cart = {};
  
  void initState() {
    //TODO: implement initstate
    super.initState();
    _configure();
  }

  _configure() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _cart = _sharedPreferences.getString('cart').isNotEmpty?json.decode(_sharedPreferences.getString('cart')):{};
    });
    log(_cart.toString());
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        // backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(10 * heightMultiplier),
          child: Ink(
            width: 100 * widthMultiplier,
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(right: 4 * widthMultiplier, top: 2 * heightMultiplier),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      splashColor: Colors.black12.withOpacity(0.05),
                      hoverColor: Colors.black12.withOpacity(0.05),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 6 * imageSizeMultiplier,
                        color: appColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // Expanded(
                    //   child: CustomText(
                    //     text: widget.details['name'],
                    //     // text: _products[index]['productDescription'],
                    //     align: TextAlign.center,
                    //     size: 3,
                    //     weight: FontWeight.bold,
                    //     color: Colors.black,
                    //   ),
                    // )
                  ]
                )
              )
            ),
          )
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 4 * heightMultiplier),
                  padding: EdgeInsets.only(bottom: 2 * heightMultiplier),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Color(0xFF707070).withOpacity(.2), blurRadius: 0.2 * imageSizeMultiplier, offset: Offset(0, 3))
                    ]
                  ),
                  child: Column(
                    children: [
                      if (_cart.isNotEmpty)
                      for (var product in _cart['order_request_products'])
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier, horizontal: 4 * widthMultiplier),
                        child: CustomButton(
                          height: 0,
                          minWidth: 0,
                          child: Ink(
                            height: 8 * heightMultiplier,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {

                                    },
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(1 * imageSizeMultiplier), bottomLeft: Radius.circular(1 * imageSizeMultiplier))
                                          // borderRadius: BorderRadius.circular(1 * imageSizeMultiplier)
                                        ),
                                      ),
                                      minimumSize: MaterialStateProperty.all(Size.zero),
                                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                                      backgroundColor: MaterialStateProperty.all(Colors.white),
                                      alignment: Alignment.center,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier, horizontal: 4 * widthMultiplier),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: CustomText(
                                                    text: product['product_name']??'',
                                                    // text: _products[index]['productDescription'],
                                                    align: TextAlign.center,
                                                    size: 1.6,
                                                    weight: FontWeight.normal,
                                                    color: Colors.black,
                                                  )
                                                ),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: CustomText(
                                                    text: product['name'],
                                                    // text: _products[index]['productDescription'],
                                                    align: TextAlign.center,
                                                    size: 1.2,
                                                    weight: FontWeight.normal,
                                                    color: Color(0xFF9D9C9C),
                                                  )
                                                ),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: CustomText(
                                                    text: '₱ ${double.parse(product['overall_price'].toString()).toStringAsFixed(2)}',
                                                    // text: _products[index]['productDescription'],
                                                    align: TextAlign.center,
                                                    size: 1.2,
                                                    weight: FontWeight.normal,
                                                    color: Color(0xFF9D9C9C),
                                                  )
                                                )
                                              ]
                                            )
                                          ),
                                          CustomButton(
                                            height: 0,
                                            minWidth: 0,
                                            child: TextButton(
                                              onPressed: () {
                                                if (product['quantity']>1) {
                                                  setState(() {
                                                    product['quantity']--;
                                                    product['overall_price']-=product['specific_price'];
                                                    _cart['total_price']-=product['specific_price'];
                                                    _cart['total_items']--;
                                                  });
                                                  _sharedPreferences.setString('cart', json.encode(_cart));
                                                  log(_cart.toString());
                                                }
                                              },
                                              style: ButtonStyle(
                                                overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                minimumSize: MaterialStateProperty.all(Size.zero),
                                                padding: MaterialStateProperty.all(EdgeInsets.zero),
                                              ),
                                              child: Ink(
                                                width: 6 * imageSizeMultiplier,
                                                height: 6 * imageSizeMultiplier,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                                                  color: appColor
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons.remove_rounded,
                                                    color: Colors.white,
                                                    size: 4 * imageSizeMultiplier,
                                                  )
                                                )
                                              )
                                            )
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 3 * widthMultiplier),
                                            child: CustomText(
                                              text: product['quantity'].toString(),
                                              // text: _products[index]['productDescription'],
                                              align: TextAlign.center,
                                              size: 1.4,
                                              weight: FontWeight.normal,
                                              color: Color(0xFF9D9C9C),
                                            )
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 3 * widthMultiplier),
                                            child: CustomButton(
                                              height: 0,
                                              minWidth: 0,
                                              child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    product['quantity']++;
                                                    product['overall_price']+=product['specific_price'];
                                                    _cart['total_price']+=product['specific_price'];
                                                    _cart['total_items']++;
                                                  });
                                                  _sharedPreferences.setString('cart', json.encode(_cart));
                                                  log(_cart.toString());
                                                },
                                                style: ButtonStyle(
                                                  overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  minimumSize: MaterialStateProperty.all(Size.zero),
                                                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                ),
                                                child: Ink(
                                                  width: 6 * imageSizeMultiplier,
                                                  height: 6 * imageSizeMultiplier,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                                                    color: appColor
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.add_rounded,
                                                      color: Colors.white,
                                                      size: 4 * imageSizeMultiplier,
                                                    )
                                                  )
                                                )
                                              )
                                            ),
                                          )
                                        ]
                                      )
                                    )
                                  )
                                ),
                                VerticalDivider(
                                  color: Colors.black12.withOpacity(0.05),
                                  width: 0.3 * widthMultiplier,
                                  thickness: 0.3 * widthMultiplier,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: CustomButton(
                                    height: 0,
                                    minWidth: 0,
                                    child: ElevatedButton(
                                      onPressed: () {

                                      },
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(1 * imageSizeMultiplier), bottomRight: Radius.circular(1 * imageSizeMultiplier))
                                            // borderRadius: BorderRadius.circular(1 * imageSizeMultiplier)
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(Size.zero),
                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                        backgroundColor: MaterialStateProperty.all(Colors.white),
                                        alignment: Alignment.center,
                                      ),
                                      child: Ink(
                                        height: 8 * heightMultiplier,
                                        width: 12 * widthMultiplier,
                                        child: Icon(
                                          Icons.delete_outline_rounded,
                                          color: appColor,
                                          size: 6 * imageSizeMultiplier,
                                        )
                                      )
                                    )
                                  )
                                )
                              ]
                            )
                          )
                        ),
                      ),
                    ]
                  )
                ),
                // Divider(
                //   color: Colors.black12.withOpacity(0.05),
                //   height: 0.3 * widthMultiplier,
                //   thickness: 0.3 * widthMultiplier,
                // ),
                // SizedBox(
                //   height: 2 * heightMultiplier,
                // ),
                // Divider(
                //   color: Colors.black12.withOpacity(0.05),
                //   height: 0.3 * widthMultiplier,
                //   thickness: 0.3 * widthMultiplier,
                // ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier),
                  margin: EdgeInsets.only(bottom: 4 * heightMultiplier),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Color(0xFF707070).withOpacity(.3), blurRadius: 0.6 * imageSizeMultiplier, offset: Offset(0, -0.6)),
                      BoxShadow(color: Color(0xFF707070).withOpacity(.5), blurRadius: 1 * imageSizeMultiplier, offset: Offset(0, 2))
                    ]
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4 * widthMultiplier),
                        child: Row(
                          children: [
                            CustomText(
                              text: 'Subtotal',
                              // text: _products[index]['productDescription'],
                              align: TextAlign.center,
                              size: 1.6,
                              weight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            Spacer(),
                            CustomText(
                              text: '₱ ${double.parse(_cart['total_price'].toString()).toStringAsFixed(2)}',
                              // text: _products[index]['productDescription'],
                              align: TextAlign.center,
                              size: 1.6,
                              weight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier, horizontal: 4 * widthMultiplier),
                        child: Row(
                          children: [
                            CustomText(
                              text: 'Concierge Fee',
                              // text: _products[index]['productDescription'],
                              align: TextAlign.center,
                              size: 1.6,
                              weight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            Spacer(),
                            CustomText(
                              text: '₱ ${double.parse(_cart['restaurant']['concierge_percentage'].toString()).toStringAsFixed(2)}',
                              // text: _products[index]['productDescription'],
                              align: TextAlign.center,
                              size: 1.6,
                              weight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4 * widthMultiplier),
                        child: Row(
                          children: [
                            CustomText(
                              text: 'Markup Fee',
                              // text: _products[index]['productDescription'],
                              align: TextAlign.center,
                              size: 1.6,
                              weight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            Spacer(),
                            CustomText(
                              text: '₱ ${double.parse(_cart['restaurant']['markup_percentage'].toString()).toStringAsFixed(2)}',
                              // text: _products[index]['productDescription'],
                              align: TextAlign.center,
                              size: 1.6,
                              weight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier, horizontal: 4 * widthMultiplier),
                        child: Divider(
                          color: Colors.black12.withOpacity(0.1),
                          height: 0.3 * widthMultiplier,
                          thickness: 0.3 * widthMultiplier,
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4 * widthMultiplier),
                        child: Row(
                          children: [
                            CustomText(
                              text: 'Total',
                              // text: _products[index]['productDescription'],
                              align: TextAlign.center,
                              size: 1.6,
                              weight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            Spacer(),
                            CustomText(
                              text: '₱ ${(
                                double.parse(_cart['total_price'].toString())
                                +
                                double.parse(_cart['restaurant']['concierge_percentage'].toString())
                                +
                                double.parse(_cart['restaurant']['markup_percentage'].toString())
                              ).toStringAsFixed(2)}',
                              // text: _products[index]['productDescription'],
                              align: TextAlign.center,
                              size: 1.6,
                              weight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ]
                  )
                ),
                FilledCustomButton(
                  text: 'Review Address and Payment Details', 
                  onPressed: () {

                  }, 
                  padding: 8, 
                  color: appColor, 
                  type: 'roundedbox'
                )
              ]
            )
          )
        ),
      )
    );
  }
}
