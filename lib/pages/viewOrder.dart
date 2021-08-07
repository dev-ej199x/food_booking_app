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
import 'package:food_booking_app/pages/updateOrder.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'orderCart.dart';

class ViewOrderScren extends StatefulWidget {
  var details;
  ViewOrderScren({
    Key key,@required this.details}): super(key: key);
  @override
  _ViewOrderScrenState createState() => _ViewOrderScrenState();
}

class _ViewOrderScrenState extends State<ViewOrderScren> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  SharedPreferences _sharedPreferences;
  bool _loading = true;
  var _cart = {};
  
  void initState() {
    //TODO: implement initstate
    super.initState();
    _configure();
  }

  _configure() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _cart = widget.details;
      _loading = false;
    });
  }


  _cancelDialog() {
    TextEditingController reasonController = TextEditingController(text: '');
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            // backgroundColor: Color(0xff747473),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3 * imageSizeMultiplier),
              ),
            ),
            content: Container(
              width: 60 * widthMultiplier,
              height: 16 * heightMultiplier,
              child: Center(
                child: Column(
                  children: <Widget>[
                    CustomText(
                      align: TextAlign.left,
                      text: 'Reason for cancelling',
                      size: 1.6,
                      color: Colors.black,
                      weight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4 * widthMultiplier),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter reason here...'
                              ),
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              controller: reasonController,
                              keyboardType: TextInputType.text,
                              enabled: true,
                              obscureText: false,
                              focusNode: null,
                              onSubmitted: (value) {},
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10 * widthMultiplier,
                        right: 10 * widthMultiplier,
                        top: 1 * heightMultiplier
                      ),
                      child: ButtonTheme(
                        height: 5 * heightMultiplier,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                              horizontal: 4 * widthMultiplier),),
                            backgroundColor: MaterialStateProperty.all(appColor),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(1 * imageSizeMultiplier),
                              )
                            )
                          ),
                          onPressed: () {
                            if (reasonController.text.isNotEmpty)
                            _cancelOrder(reasonController.text);
                          },
                          child: Container(
                            child: Center(
                              child: CustomText(
                                align: TextAlign.left,
                                text: "Proceed",
                                size: 1.6,
                                color: Colors.white,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ),
          );
        });
      },
    );
  }

  _cancelOrder(String reason) async {
    Http().showLoadingOverlay(context);
    var response =
    await Http(url: 'orderRequests/${_cart['id']}', body: {
      'status_id': '5',
      'remarks': reason
    }).putWithHeader();
    if (response is String) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: CustomText(
            align: TextAlign.left,
            text: response,
            color: Colors.white,
            size: 1.6,
            weight: FontWeight.normal,
          ),
        ),
      );
    } else if (response is Response) {
      if (response.statusCode != 200) {
        Navigator.pop(context);
        _scaffoldKey.currentState
          .showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFF323232),
              content: CustomText(
                align: TextAlign.left,
                text: response.body,
                color: Colors.white,
                size: 1.6,
                weight: FontWeight.normal,
              ),
            ),
          );
      } else {
        Navigator.pop(context);
        setState(() {
          _cart['status'] = json.decode(response.body)['orderRequest']['status'];
        });
        _scaffoldKey.currentState
          .showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFF323232),
              content: CustomText(
                align: TextAlign.left,
                text: 'Order cancelled',
                color: Colors.white,
                size: 1.6,
                weight: FontWeight.normal,
              ),
            ),
          );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        // backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(6 * heightMultiplier),
          child: Ink(
            width: 100 * widthMultiplier,
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(right: 4 * widthMultiplier),
                child: Stack(
                  alignment: Alignment.centerLeft,
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
                    Padding(
                      padding: EdgeInsets.only(left: 4 * widthMultiplier,),
                      child: Align(
                        alignment: Alignment.center,
                        child: CustomText(
                          color: appColor,
                          align: TextAlign.center,
                          size: 3,
                          text: 'Order Details',
                          weight: FontWeight.bold,
                        )
                      )
                    )
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
          child: _loading?Container():SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 2 * heightMultiplier),
                  child: Ink(
                    padding: EdgeInsets.only(bottom: 2 * heightMultiplier, top: 1 * heightMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Color(0xFF707070).withOpacity(.1), blurRadius: 0.1 * imageSizeMultiplier, offset: Offset(0, 1))
                      ]
                    ),
                    child: Column(
                      children: [
                        if (_cart.isNotEmpty)
                        for (var product in _cart['order_request_product'])
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
                                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: UpdateOrderScreen(index: _cart['order_request_product'].indexOf(product), details: product,)))
                                        .then((response) {
                                          setState(() {
                                            _cart = _sharedPreferences.getString('cart').isNotEmpty?json.decode(_sharedPreferences.getString('cart')):{};
                                          });
                                        });
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
                                                      text: product['variant']['product']['name']??'',
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
                                                      text: product['variant']['name']??'',
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
                                                      text: '₱ ${double.parse(product['grand_total'].toString()).toStringAsFixed(2)}',
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
                                ]
                              )
                            )
                          ),
                        ),
                      ]
                    )
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
                  margin: EdgeInsets.only(bottom: 2 * heightMultiplier),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Color(0xFF707070).withOpacity(.3), blurRadius: 0.1 * imageSizeMultiplier, offset: Offset(0, -0.2)),
                      BoxShadow(color: Color(0xFF707070).withOpacity(.1), blurRadius: 0.1 * imageSizeMultiplier, offset: Offset(0, 1))
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
                              text: '₱ ${double.parse(_cart['sub_total'].toString()).toStringAsFixed(2)}',
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
                                double.parse(_cart['grand_total'].toString())
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier),
                  margin: EdgeInsets.only(bottom: 2 * heightMultiplier),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Color(0xFF707070).withOpacity(.3), blurRadius: 0.1 * imageSizeMultiplier, offset: Offset(0, -0.2)),
                      BoxShadow(color: Color(0xFF707070).withOpacity(.1), blurRadius: 0.1 * imageSizeMultiplier, offset: Offset(0, 1))
                    ]
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 1 * heightMultiplier, left: 4 * widthMultiplier, right: 4 * widthMultiplier),
                          child: CustomText(
                            text: 'Special Instructions',
                            // text: _products[index]['productDescription'],
                            align: TextAlign.left,
                            size: 1.8,
                            weight: FontWeight.bold,
                            color: Colors.black,
                          )
                        )
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier, horizontal: 4 * widthMultiplier),
                          child: CustomText(
                            maxLine: 2,
                            text: _cart['customers_note'],
                            // text: _products[index]['productDescription'],
                            align: TextAlign.left,
                            size: 1.4,
                            weight: FontWeight.normal,
                            color: Colors.black54,
                          )
                        )
                      ),
                    ]
                  ),
                ),
                if (_cart['status']['name'] == 'PENDING')
                Padding(
                  padding: EdgeInsets.only(bottom: 2 * heightMultiplier),
                  child: FilledCustomButton(
                    text: 'Cancel Order', 
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _cancelDialog();
                    }, 
                    padding: 8, 
                    color: appColor, 
                    type: 'roundedbox'
                  )
                ),
              ]
            )
          )
        ),
      )
    );
  }
}
