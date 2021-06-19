import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/button.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/filled-button.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:food_booking_app/defaults/textbox.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class OrderCart extends StatefulWidget {
  var specifics;
  OrderCart({
    Key key,@required this.specifics}): super(key: key);
  @override
  _OrderCartState createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  TextEditingController _noteController = TextEditingController();
  SharedPreferences _sharedPreferences;
  var _cart = {};
  // var _restaurants = {};
  double _total = 0;
  double _subFee = 0;
  double _conciergeFee = 0;
  double _priceWithConcierge = 0;
  double _priceWithMarkup = 0;
  double _markUpFee = 0;
  double _preparationTime = 0;
  bool _addInstruction = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _configure();
  }

  _configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    // _sharedPreferences.setString('cart', null);
    setState(() {
      _cart = json.decode(_sharedPreferences.getString('cart'));
    });
    log(_cart.toString());
    _computeTotal();
  }

  _computeTotal() {
    _cart['order_request_products'].forEach((product) {
      setState(() {
        _subFee += product['price'];
        // _conciergeFee = product['concierge_percentage'];
        // _markUpFee = product['markup_percentage'];
      });
    });
    setState(() {
      // _priceWithConcierge = _subFee * _conciergeFee;
      // _priceWithMarkup = _subFee * _markUpFee;
      // _total = _subFee + _priceWithConcierge + _priceWithMarkup;
      _total = _subFee;
    });
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
      'restaurant_id': _cart['restaurants']['restaurant_id'],
      'booking_time': DateFormat('HH:mm').format(widget.specifics['type'] == 'booking'?DateFormat('HH:mm a').parse(widget.specifics['time']):DateTime.now()),
      'booking_date': DateFormat('yyyy-MM-dd').format(widget.specifics['type'] == 'booking'?DateFormat('MMMM dd, yyyy').parse(widget.specifics['date']):DateTime.now()),
      'number_of_person': widget.specifics['people'],
      'customers_note': _noteController.text,
      'payment_method': 'COD',
      'longitude': '6.999',
      'latitude': '6.999',
      'order_request_products': order_request_products
    };
    print(request);
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
                text: 'SUCCESS',
                color: Colors.white,
                size: 1.6,
                weight: FontWeight.bold,
              ),
            ),
          );
      }
    }
  }

  _showOptionsDialog(var product) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setstate) => AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8 * imageSizeMultiplier),
              ),
            ),
            content: Container(
              height: 50 * heightMultiplier,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            8 * imageSizeMultiplier),
                        topRight: Radius.circular(
                            8 * imageSizeMultiplier),
                      ),
                      color: Color(0xff323030),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1 * heightMultiplier),
                      child: CustomText(
                        align: TextAlign.center,
                        text: 'Product Options',
                        size: 3,
                        color: Color(0xFFED1F56),
                        weight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: product['product_options'].length,
                          itemBuilder: (context, index) => Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width,
                                        padding: EdgeInsets.symmetric(horizontal: 4 * widthMultiplier, vertical: 1 * heightMultiplier),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          align: TextAlign.left,
                                          text: '${product['product_options'][index]['name']}:',
                                          weight: FontWeight.bold,
                                          color: Colors.black,
                                          size: 1.8,
                                        ),
                                        Row(
                                          children: [
                                            for (var item in product[
                                                        'product_options']
                                                    [index][
                                                'product_option_items'])
                                              CustomText(
                                                align: TextAlign.left,
                                                  text: '${item['name']}${product['product_options'][index]['product_option_items'].indexOf(item) == product['product_options'][index]['product_option_items'].length - 1 ? '' : ','}',
                                                  
                                          weight: FontWeight.normal,
                                          color: Colors.black,
                                          size: 1.8,),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(6 * heightMultiplier),
          child: AppBar(
            backgroundColor: Color(0xFFED1F56),
            title: Center(
              child: CustomText(
                text: 'CART',
                align: TextAlign.center,
                color: Colors.white,
                size: 3,
                weight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 6 * imageSizeMultiplier,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 6 * imageSizeMultiplier,
                  color: Color(0xFFED1F56),
                ),
              )
            ],
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
          child: _cart.length > 0? 
          SingleChildScrollView(
            child: Column(
              // alignment: Alignment.topCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Color(0xFF707070).withOpacity(.1), blurRadius: 1 * imageSizeMultiplier)
                    ],
                    color: Colors.white,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      if (_cart.containsKey('order_request_products'))
                      for (var product in _cart['order_request_products'])
                      CustomButton(
                        height: 0,
                        minWidth: 0,
                        child: TextButton(
                          onPressed: product['product_options'].length > 0?() {
                            _showOptionsDialog(product);
                          }:null,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero)
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2 * heightMultiplier, horizontal: 4 * widthMultiplier),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      height: 10 * imageSizeMultiplier,
                                      width: 10 * imageSizeMultiplier,
                                      margin: EdgeInsets.only(right: 4 * widthMultiplier),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black, width: .3 * imageSizeMultiplier),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(1 * imageSizeMultiplier)
                                      ),
                                      child: CustomText(
                                        align: TextAlign.left,
                                        text: product['quantity'].toString(),
                                        color: Colors.black,
                                        size: 1.2,
                                        weight: FontWeight.normal,
                                      ),
                                    ),
                                    CustomText(
                                      align: TextAlign.left,
                                      text: product['product_name'],
                                      color: Colors.black,
                                      size: 1.4,
                                      weight: FontWeight.normal,
                                    ),
                                    Spacer(),
                                    CustomText(
                                      align: TextAlign.left,
                                      text: '\$ ${double.parse(product['price'].toString()).toStringAsFixed(2)}',
                                      color: Colors.black,
                                      size: 1.4,
                                      weight: FontWeight.normal,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: .1 * heightMultiplier,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Color(0xFF707070).withOpacity(.25), blurRadius: 1 * imageSizeMultiplier, offset: Offset(0, 3))
                                  ],
                                  color: Colors.red,
                                ),
                              ),
                            ]
                          )
                        )
                      )
                    ],
                  )
                ),
                Container(
                  margin: EdgeInsets.only(top: 4 * heightMultiplier),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Color(0xFF707070).withOpacity(.1), blurRadius: 1 * imageSizeMultiplier)
                    ],
                    color: Colors.white,
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 4 * widthMultiplier, vertical: 2 * heightMultiplier),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children:[
                          CustomText(
                            align: TextAlign.left,
                            text: 'Subtotal',
                            color: Colors.black,
                            size: 1.6,
                            weight: FontWeight.bold,
                          ),
                          Spacer(),
                          CustomText(
                            align: TextAlign.left,
                            text: '\$ ${_subFee.toStringAsFixed(2)}',
                            color: Colors.black,
                            size: 1.6,
                            weight: FontWeight.normal,
                          ),
                        ]
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1 * heightMultiplier),
                        child: Row(
                          children:[
                            CustomText(
                              align: TextAlign.left,
                              text: 'Concierge Fee',
                              color: Colors.black,
                              size: 1.6,
                              weight: FontWeight.normal,
                            ),
                            Spacer(),
                            CustomText(
                              align: TextAlign.left,
                              text: '\$ ${_conciergeFee.toStringAsFixed(2)}',
                              color: Colors.black,
                              size: 1.6,
                              weight: FontWeight.normal,
                            ),
                          ]
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1 * heightMultiplier),
                        child: Row(
                          children:[
                            CustomText(
                              align: TextAlign.left,
                              text: 'Markup Fee',
                              color: Colors.black,
                              size: 1.6,
                              weight: FontWeight.normal,
                            ),
                            Spacer(),
                            CustomText(
                              align: TextAlign.left,
                              text: '\$ ${_markUpFee.toStringAsFixed(2)}',
                              color: Colors.black,
                              size: 1.6,
                              weight: FontWeight.normal,
                            ),
                          ]
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1 * heightMultiplier),
                        child: Row(
                          children:[
                            CustomText(
                              align: TextAlign.left,
                              text: 'Grand Total',
                              color: Colors.black,
                              size: 1.8,
                              weight: FontWeight.bold,
                            ),
                            Spacer(),
                            CustomText(
                              align: TextAlign.left,
                              text: '\$ ${_total.toStringAsFixed(2)}',
                              color: Colors.black,
                              size: 1.6,
                              weight: FontWeight.normal,
                            ),
                          ]
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2 * heightMultiplier),
                        child: Row(
                          children: [
                            Icon(
                              _addInstruction?Icons.close_rounded:Icons.add_rounded,
                              color: appColor,
                              size: 5 * imageSizeMultiplier,
                            ),
                            CustomButton(
                              height:0,
                              minWidth: 0,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _addInstruction = !_addInstruction;
                                  });
                                },
                                child: CustomText(
                                  align: TextAlign.left,
                                  text: _addInstruction?'Clear Instructions':'Add Instructions',
                                  color: appColor,
                                  size: 1.6,
                                  weight: FontWeight.bold,
                                )
                              )
                            )
                          ]
                        )
                      ),
                      if (_addInstruction)
                      CustomTextBox(
                        type: 'roundedbox',
                        shadow: false,
                        border: true,
                        controller: _noteController,
                        text: 'YOUR NOTE',
                        keyboardType: TextInputType.text,
                        enabled: true,
                        obscureText: false,
                        padding: 2,
                        prefixIcon: null,
                        suffixIcon: null,
                        focusNode: null,
                        onSubmitted: (value) {},
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 4 * heightMultiplier),
                  child: CustomButton(
                    height: 0,
                    minWidth: 0,
                    child: FilledCustomButton(
                      type: 'roundedbox',
                      padding: 8,
                      onPressed: () {
                        _createOrder();
                      },
                      text: ' PROCEED ',
                      color: appColor,
                    ),
                  )
                ),
              ],
            ),
          )
          :
          Shimmer.fromColors(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 1 * widthMultiplier),
                  child: SingleChildScrollView(
                    child: Column(
                      // alignment: Alignment.topCenter,
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1 * heightMultiplier),
                              child: Container(
                                child: Row(children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            1 * heightMultiplier),
                                    child: Icon(Icons.image,
                                        size:
                                            20 * imageSizeMultiplier),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            4 * widthMultiplier,
                                        vertical:
                                            1 * heightMultiplier),
                                    child: SizedBox(
                                      child: Container(
                                        color: Colors.green,
                                      ),
                                      width: 7 * widthMultiplier,
                                      height: 3 * heightMultiplier,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            4 * widthMultiplier,
                                        vertical:
                                            1 * heightMultiplier),
                                    child: SizedBox(
                                      child: Container(
                                        color: Colors.green,
                                      ),
                                      width: 5 * widthMultiplier,
                                      height: 3 * heightMultiplier,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3 * heightMultiplier,
                                        horizontal:
                                            8 * widthMultiplier),
                                    child: RaisedButton(
                                      splashColor: Colors.white,
                                      color: Colors.grey[200],
                                      shape: StadiumBorder(),
                                      onPressed: () {},
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 4 * heightMultiplier,
                          color: Colors.red,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 2 * heightMultiplier),
                          child: Container(
                            height: 20 * heightMultiplier,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: CustomTextBox(
                                        type: 'roundedbox',
                                        shadow: false,
                                        border: true,
                                        controller: _noteController,
                                        text: '',
                                        keyboardType: TextInputType.text,
                                        enabled: true,
                                        obscureText: false,
                                        padding: 8,
                                        prefixIcon: null,
                                        suffixIcon: null,
                                        focusNode: null,
                                        onSubmitted: (value) {},
                                        textInputAction: TextInputAction.done,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                4 * widthMultiplier),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: Container(
                                                color: Colors.green,
                                              ),
                                              height:
                                                  3 * heightMultiplier,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 2 * heightMultiplier),
                                              child: SizedBox(
                                                child: Container(
                                                  color: Colors.green,
                                                ),
                                                height: 3 *
                                                    heightMultiplier,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 2 * heightMultiplier),
                                              child: SizedBox(
                                                child: Container(
                                                  color: Colors.green,
                                                ),
                                                height: 3 *
                                                    heightMultiplier,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 2 * heightMultiplier),
                                              child: SizedBox(
                                                child: Container(
                                                  color: Colors.green,
                                                ),
                                                height: 3 *
                                                    heightMultiplier,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2 * heightMultiplier),
                          child: RaisedButton(
                            onPressed: () {},
                            child: CustomText(
                              align: TextAlign.left,
                              text: '',
                              color: Colors.white,
                              size: 2.4,
                              weight: FontWeight.bold,
                            ),
                            color: appColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]
            ),
            period: Duration(seconds: 2),
            baseColor: Colors.grey,
            highlightColor: appColor
          )
        )
      )
    );
  }
}
