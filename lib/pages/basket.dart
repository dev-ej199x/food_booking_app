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

class BasketScren extends StatefulWidget {
  var specifics;
  BasketScren({
    Key key,@required this.specifics}): super(key: key);
  @override
  _BasketScrenState createState() => _BasketScrenState();
}

class _BasketScrenState extends State<BasketScren> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  TextEditingController _noteController = TextEditingController();
  SharedPreferences _sharedPreferences;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _loading = true;
  String _prepareOrder = 'On arrival';
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
      _loading = false;
    });
    log(_cart.toString());
  }


  _createOrder() async {
    Http().showLoadingOverlay(context);

    List order_request_products = [];
    _cart['order_request_products'].forEach((product) {
      List order_request_product_items = [];
      product['product_options'].forEach((option) {
        option['product_option_items'].forEach((item) {
          // order_request_product_items.add(item['id']);
          order_request_product_items.add({'id': item['id']});
        });
      });
      order_request_products.add({
        'variant_id': product['variant_id'],
        'quantity': product['quantity'],
        'note': product['note'],
        'product_option_items': order_request_product_items
      });
    });
    var request = {
      'restaurant_id': _cart['restaurant']['id'],
      'booking_time': DateFormat('HH:mm').format(widget.specifics['type'] == 'booking'?DateFormat('HH:mm a').parse(widget.specifics['time']):DateTime.now()),
      'booking_date': DateFormat('yyyy-MM-dd').format(widget.specifics['type'] == 'booking'?DateFormat('MM/dd/yyyy').parse(widget.specifics['date'].toString()):DateTime.now()),
      'number_of_person': widget.specifics['people'],
      'customers_note': '${_noteController.text}\nPrepare order $_prepareOrder',
      'payment_method': 'COD',
      'longitude': '6.999',
      'latitude': '6.999',
      'order_request_products': order_request_products
    };
    var response =
        await Http(url: 'orderRequests', body: request).postWithHeader();
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
            weight: FontWeight.bold,
          ),
        ),
      );
    } else if (response is Response) {
      log(response.body);
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
                weight: FontWeight.bold,
              ),
            ),
          );
      } else {
        Navigator.pop(context);
        _scaffoldKey.currentState
          .showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFF323232),
              content: CustomText(
                align: TextAlign.left,
                text: 'Order made',
                color: Colors.white,
                size: 1.6,
                weight: FontWeight.bold,
              ),
            ),
          );
        _sharedPreferences.setString('cart', '');
        Navigator.pop(context);
        Navigator.pop(context);
      }
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
                          text: 'Review Basket',
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
                                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: UpdateOrderScreen(index: _cart['order_request_products'].indexOf(product), details: product,)))
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
                                          setState(() {
                                            _cart['total_price']-=product['overall_price'];
                                            _cart['total_items']-=product['quantity'];
                                            _cart['order_request_products'].removeAt(_cart['order_request_products'].indexOf(product));
                                          });
                                          _sharedPreferences.setString('cart', json.encode(_cart));
                                          log(_cart.toString());
                                          if (_cart['order_request_products'].length == 0) {
                                            Navigator.pop(context);
                                          }
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
                          padding: EdgeInsets.only(top: 2 * heightMultiplier, left: 4 * widthMultiplier, right: 4 * widthMultiplier),
                          child: CustomText(
                            text: 'Prepare Order',
                            // text: _products[index]['productDescription'],
                            align: TextAlign.left,
                            size: 1.8,
                            weight: FontWeight.bold,
                            color: Colors.black,
                          )
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2 * heightMultiplier, top: 1 * heightMultiplier),
                        child: TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2 * imageSizeMultiplier)
                              ),
                              context: context, 
                              builder: (context) => Container(
                                height: 30 * heightMultiplier,
                                child: Column(
                                  children: [
                                    CustomText(
                                      text: 'Prepare Order',
                                      // text: _products[index]['productDescription'],
                                      align: TextAlign.center,
                                      size: 1.8,
                                      weight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    SimpleDialogOption(
                                      onPressed: () {
                                        setState(() {
                                          _prepareOrder = 'On Arrival';
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 100 * widthMultiplier,
                                        height: 4 * heightMultiplier,
                                        alignment: Alignment.center,
                                        child: CustomText(
                                          text: 'On Arrival',
                                          // text: _products[index]['productDescription'],
                                          align: TextAlign.center,
                                          size: 1.4,
                                          weight: FontWeight.normal,
                                          color: Colors.black,
                                        )
                                      )
                                    ),
                                    SimpleDialogOption(
                                      onPressed: () {
                                        setState(() {
                                          _prepareOrder = 'at least 30 minutes before schedule';
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 100 * widthMultiplier,
                                        height: 4 * heightMultiplier,
                                        alignment: Alignment.center,
                                        child: CustomText(
                                          text: 'at least 30 minutes before schedule',
                                          // text: _products[index]['productDescription'],
                                          align: TextAlign.center,
                                          size: 1.4,
                                          weight: FontWeight.normal,
                                          color: Colors.black,
                                        )
                                      )
                                    ),
                                    SimpleDialogOption(
                                      onPressed: () {
                                        setState(() {
                                          _prepareOrder = 'at least 1 hour before schedule';
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 100 * widthMultiplier,
                                        height: 4 * heightMultiplier,
                                        alignment: Alignment.center,
                                        child: CustomText(
                                          text: 'at least 1 hour before schedule',
                                          // text: _products[index]['productDescription'],
                                          align: TextAlign.center,
                                          size: 1.4,
                                          weight: FontWeight.normal,
                                          color: Colors.black,
                                        )
                                      )
                                    )
                                  ],
                                ),
                              )
                            );
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: MaterialStateProperty.all(Size.zero),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          child: CustomTextBox(
                            focusNode: null,
                            type: 'roundedbox',
                            border: true,
                            textInputAction: TextInputAction.next,
                            controller: null,
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            text: _prepareOrder,
                            obscureText: false,
                            padding: 4,
                            prefixIcon: null,
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              size: 8 * imageSizeMultiplier,
                            ),
                            enabled: false,
                            shadow: false,
                            keyboardType: TextInputType.text,
                          ),
                        )
                      ),
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier, horizontal: 4 * widthMultiplier),
                        child: CustomText(
                          maxLine: 2,
                          text: 'Please tell us if there is anything else you want us to prepare (such as a surprise)',
                          // text: _products[index]['productDescription'],
                          align: TextAlign.left,
                          size: 1.4,
                          weight: FontWeight.normal,
                          color: Colors.black54,
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2 * heightMultiplier, top: 1 * heightMultiplier),
                        child: CustomTextBox(
                          maxLine: 3,
                          focusNode: null,
                          type: 'roundedbox',
                          border: true,
                          textInputAction: TextInputAction.next,
                          controller: _noteController,
                          onSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          },
                          text: "e.g We are celebrating our 30th Aniversary",
                          obscureText: false,
                          padding: 4,
                          prefixIcon: null,
                          suffixIcon: null,
                          enabled: true,
                          shadow: false,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ]
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 2 * heightMultiplier),
                  child: FilledCustomButton(
                    text: 'Proceed Order', 
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _createOrder();
                    }, 
                    padding: 8, 
                    color: appColor, 
                    type: 'roundedbox'
                  )
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
                // FilledCustomButton(
                //   text: 'Review Payment Details', 
                //   onPressed: () {

                //   }, 
                //   padding: 8, 
                //   color: appColor, 
                //   type: 'roundedbox'
                // )
              ]
            )
          )
        ),
      )
    );
  }
}
